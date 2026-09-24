import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../moderation/nudity_detector.dart';
import '../../widgets/common.dart';

/// The companion's own photo and its review state.
final myPhotoProvider = FutureProvider.autoDispose<MyPhoto>((ref) async {
  final api = ref.watch(apiProvider);
  return api.call(() => api.photos.getMyPhoto());
});

/// The companion's own avatar: their approved photo, else the illustration.
class MyAvatar extends ConsumerWidget {
  const MyAvatar({super.key, this.size = 46});
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(sessionProvider).profile!;
    final photo = p.role == ProfileRoleEnum.companion
        ? ref.watch(myPhotoProvider).valueOrNull?.photoUrl
        : null;
    return Avatar(
      name: p.displayName,
      avatarId: p.avatarId,
      size: size,
      photoUrl: photo,
    );
  }
}

/// Profile row: "Profile photo" with its review state; opens the sheet.
class ProfilePhotoTile extends ConsumerWidget {
  const ProfilePhotoTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final m = ref.watch(myPhotoProvider).valueOrNull;
    final (sub, color) = switch (m?.status) {
      MyPhotoStatusEnum.pending => ('Waiting for review', AppColors.warning),
      MyPhotoStatusEnum.approved => (
        'Callers see your photo',
        AppColors.success,
      ),
      MyPhotoStatusEnum.rejected => (
        'Not approved — tap to see why',
        AppColors.danger,
      ),
      _ => (
        'Add a photo — callers see your avatar now',
        AppColors.textSecondary,
      ),
    };
    return ListTile(
      leading: const Icon(
        Icons.photo_camera_front_outlined,
        color: Color(0xFF6EE7B7),
      ),
      title: const Text('Profile photo'),
      subtitle: Text(sub, style: AppText.body(13, color: color)),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF16142C),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) => const _PhotoSheet(),
      ),
    );
  }
}

class _PhotoSheet extends ConsumerStatefulWidget {
  const _PhotoSheet();

  @override
  ConsumerState<_PhotoSheet> createState() => _PhotoSheetState();
}

class _PhotoSheetState extends ConsumerState<_PhotoSheet> {
  bool _busy = false;

  Future<void> _pick(ImageSource source) async {
    final f = await ImagePicker().pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
      maxWidth: 1600,
      imageQuality: 88,
    );
    if (f == null || !mounted) return;
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      final bytes = await f.readAsBytes();
      // Same on-device check as video: obvious problems never leave the phone.
      try {
        final score = await (await sharedNudityDetector()).score(bytes);
        if (score >= 0.6) {
          if (mounted)
            showError(
              context,
              "This photo can't be used. Pick a clear, friendly photo of your face.",
            );
          return;
        }
      } catch (_) {
        /* no model on this phone — the admin still reviews every photo */
      }
      await api.call(
        () => api.photos.uploadMyPhoto(
          UploadMyPhotoRequest(imageBase64: base64Encode(bytes)),
        ),
      );
      ref.invalidate(myPhotoProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(() => api.photos.deleteMyPhoto());
      ref.invalidate(myPhotoProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = ref.watch(sessionProvider).profile!;
    final m = ref.watch(myPhotoProvider).valueOrNull;
    final hasAny = m?.photoUrl != null || m?.pendingUrl != null;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Profile photo', style: AppText.heading(20)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Preview(
                  label: m?.photoUrl != null
                      ? 'Callers see'
                      : 'Callers see (avatar)',
                  child: Avatar(
                    name: p.displayName,
                    avatarId: p.avatarId,
                    size: 96,
                    photoUrl: m?.photoUrl,
                  ),
                ),
                if (m?.pendingUrl != null) ...[
                  const SizedBox(width: 24),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 24),
                  _Preview(
                    label: 'Under review',
                    child: Avatar(
                      name: p.displayName,
                      avatarId: p.avatarId,
                      size: 96,
                      photoUrl: m!.pendingUrl,
                    ),
                  ),
                ],
              ],
            ),
            if (m?.status == MyPhotoStatusEnum.rejected &&
                m?.rejectReason != null) ...[
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'Not approved: ${m!.rejectReason}',
                  style: AppText.body(13.5),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Use a clear, recent photo of your own face — it must match your verification selfie. '
              'No group photos, no suggestive poses, no phone numbers or UPI IDs. '
              'Our team checks every photo before callers see it (usually within a day).',
              style: AppText.body(
                13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _busy ? null : () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Take photo'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                    ),
                    onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(_busy ? 'Uploading…' : 'Choose photo'),
                  ),
                ),
              ],
            ),
            if (hasAny)
              TextButton(
                onPressed: _busy ? null : _remove,
                child: Text(
                  'Remove photo — use my avatar',
                  style: AppText.body(14, color: AppColors.danger),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      child,
      const SizedBox(height: 6),
      Text(label, style: AppText.body(12, color: AppColors.textSecondary)),
    ],
  );
}
