import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'companion_data.dart';
import '../notifications/notifications_screen.dart';
import '../chat/chat_screens.dart';
import '../rooms/rooms_screens.dart';
import '../group/group_host.dart' show HostGroupsCard;
import '../live/live_data.dart' show LiveBadge;
import '../live/live_host_screen.dart' show showGoLiveSheet;
import 'profile_photo.dart' show MyAvatar;

const _green = Color(0xFF10B981);
const _teal = Color(0xFF0E7490);

/// Design: CompanionHome.dc.html — greeting, big online switch, today's numbers, recent calls.
class CompanionHomeTab extends ConsumerWidget {
  const CompanionHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(sessionProvider).profile!;
    final home = ref.watch(companionHomeProvider);
    ref.listen(companionHomeProvider, (_, next) {
      final h = next.valueOrNull;
      if (h != null) ref.read(presenceProvider.notifier).adopt(h.online);
    });

    return RefreshIndicator(
      color: _green,
      onRefresh: () async => ref.invalidate(companionHomeProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          Row(
            children: [
              const MyAvatar(size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi, ${profile.displayName}',
                      style: AppText.heading(22),
                    ),
                    Text(
                      home.valueOrNull?.kycStatus ==
                              CompanionHome200ResponseKycStatusEnum.approved
                          ? 'KYC verified companion'
                          : 'Companion · not verified yet',
                      style: AppText.body(13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const ChatButton(),
              const SizedBox(width: 8),
              const NotificationBell(),
            ],
          ),
          const SizedBox(height: 14),
          Material(
            color: const Color(0x1F10B981),
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(
                Icons.emoji_events_rounded,
                color: Color(0xFFFCD34D),
              ),
              title: const Text('Rewards'),
              subtitle: const Text('Your level, daily goal and bonuses'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push('/rewards'),
            ),
          ),
          const SizedBox(height: 10),
          const VoiceRoomsCard(host: true),
          const SizedBox(height: 18),
          home.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator(color: _green)),
            ),
            error: (e, _) => Text(
              friendlyError(e),
              style: AppText.body(14, color: AppColors.textMuted),
            ),
            data: (h) =>
                h.kycStatus == CompanionHome200ResponseKycStatusEnum.approved
                ? _Approved(h)
                : _NotApproved(h.kycStatus),
          ),
        ],
      ),
    );
  }
}

class _NotApproved extends StatelessWidget {
  const _NotApproved(this.status);
  final CompanionHome200ResponseKycStatusEnum status;

  @override
  Widget build(BuildContext context) {
    final (title, body, cta) = switch (status) {
      CompanionHome200ResponseKycStatusEnum.submitted => (
        'Verification under review',
        'We\'ll let you know soon. Then you can go online.',
        'View details',
      ),
      CompanionHome200ResponseKycStatusEnum.rejected => (
        'Verification needs a fix',
        'Open it to see what to change.',
        'Fix and resubmit',
      ),
      _ => (
        'Finish verification',
        'Aadhaar, a live selfie, then PAN and UPI. About 5 minutes.',
        'Continue',
      ),
    };
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [_green, _teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            color: Colors.white,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(title, style: AppText.heading(22)),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppText.body(
              14,
              color: const Color(0xFFD1FAE5),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _teal,
              minimumSize: const Size.fromHeight(46),
            ),
            onPressed: () => context.push('/kyc'),
            child: Text(
              cta,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _Approved extends ConsumerStatefulWidget {
  const _Approved(this.h);
  final CompanionHome200Response h;

  @override
  ConsumerState<_Approved> createState() => _ApprovedState();
}

class _ApprovedState extends ConsumerState<_Approved> {
  bool _switching = false;

  /// Optimistic copies of the call-type switches while a save is in flight.
  bool? _audio, _video;
  bool _savingTypes = false;

  Future<void> _setTypes({required bool audio, required bool video}) async {
    if (!audio && !video) {
      showError(context, "Keep voice or video on, or you won't get any calls");
      return;
    }
    setState(() {
      _audio = audio;
      _video = video;
      _savingTypes = true;
    });
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.companion.setCompanionCallTypes(
          SetCompanionCallTypesRequest(audio: audio, video: video),
        ),
      );
      ref.invalidate(companionHomeProvider);
    } catch (e) {
      if (mounted) {
        setState(() => _audio = _video = null); // back to what the server says
        showError(context, friendlyError(e));
      }
    } finally {
      if (mounted) setState(() => _savingTypes = false);
    }
  }

  Future<void> _toggle(bool online) async {
    setState(() => _switching = true);
    try {
      await ref.read(presenceProvider.notifier).set(online);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _switching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final online = ref.watch(presenceProvider);
    final h = widget.h;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: online
                ? const LinearGradient(
                    colors: [_green, _teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: online ? null : AppColors.card,
            border: Border.all(
              color: online ? Colors.transparent : AppColors.cardBorder,
            ),
            boxShadow: online
                ? const [
                    BoxShadow(
                      color: Color(0x5510B981),
                      blurRadius: 30,
                      offset: Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      online ? 'You\'re online' : 'You\'re offline',
                      style: AppText.heading(22),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      online
                          ? 'Callers can reach you now. Keep the app open.'
                          : 'Go online when you\'re ready to talk.',
                      style: AppText.body(
                        13.5,
                        color: online
                            ? const Color(0xFFD1FAE5)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: online ? 'Go offline' : 'Go online',
                child: Transform.scale(
                  scale: 1.3,
                  child: Switch(
                    value: online,
                    onChanged: _switching ? null : _toggle,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0x66FFFFFF),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Calls you take',
          style: AppText.heading(15, weight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Builder(
          builder: (context) {
            final audio = _audio ?? h.takesAudio;
            final video = h.videoEnabled && (_video ?? h.takesVideo);
            String state(bool on) => !on
                ? 'Off'
                : online
                ? 'Accepting'
                : 'When you go online';
            return Row(
              children: [
                Expanded(
                  child: _Mode(
                    icon: Icons.call_rounded,
                    label: 'Voice',
                    value: state(audio),
                    on: audio,
                    live: online && audio,
                    onChanged: _savingTypes
                        ? null
                        : (v) => _setTypes(audio: v, video: video),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _Mode(
                    icon: Icons.videocam_rounded,
                    label: 'Video',
                    value: h.videoEnabled
                        ? state(video)
                        : 'Locked · after training',
                    on: video,
                    live: online && video,
                    locked: !h.videoEnabled,
                    onLockedTap: () => context.push('/academy'),
                    onChanged: _savingTypes || !h.videoEnabled
                        ? null
                        : (v) => _setTypes(audio: audio, video: v),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _GoLiveCard(unlocked: h.videoEnabled),
        const SizedBox(height: 12),
        HostGroupsCard(unlocked: h.videoEnabled),
        const SizedBox(height: 20),
        Text('Today', style: AppText.heading(17, weight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _Stat(
                label: 'Earned',
                value: rupees(h.today.earnedPaise),
                highlight: true,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Stat(label: 'Calls', value: '${h.today.calls}'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _Stat(
                label: 'Talk time',
                value: talkTime(h.today.talkSeconds),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: ListTile(
            onTap: () => context.push('/academy'),
            leading: const Icon(
              Icons.school_outlined,
              color: Color(0xFF6EE7B7),
            ),
            title: Text(
              'Companion academy',
              style: AppText.body(15, weight: FontWeight.w700),
            ),
            subtitle: Text(
              h.videoEnabled
                  ? 'Video calls unlocked'
                  : 'Finish 5 short lessons to unlock video calls',
              style: AppText.body(12.5, color: AppColors.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Text(
                'Recent calls',
                style: AppText.heading(17, weight: FontWeight.w700),
              ),
            ),
            TextButton(
              onPressed: () => context.push('/call-history'),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        if (h.recent.isEmpty)
          Text(
            'No calls yet. Go online and your first call will show up here.',
            style: AppText.body(13.5, color: AppColors.textSecondary),
          ),
        for (final c in h.recent)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Avatar(
                  name: c.callerName,
                  avatarId: c.callerAvatarId,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.callerName,
                        style: AppText.body(15, weight: FontWeight.w700),
                      ),
                      Text(
                        c.durationSeconds != null
                            ? '${c.type == CompanionHome200ResponseRecentInnerTypeEnum.video ? 'Video' : 'Voice'} · ${talkTime(c.durationSeconds!)}'
                            : c.status,
                        style: AppText.body(13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Text(
                  c.earnedPaise > 0 ? '+${rupees(c.earnedPaise)}' : '—',
                  style: AppText.body(
                    15,
                    weight: FontWeight.w700,
                    color: c.earnedPaise > 0
                        ? const Color(0xFF6EE7B7)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// One call type the companion takes, with its own switch. Video shows a lock
/// (tap → academy) until it's unlocked.
class _Mode extends StatelessWidget {
  const _Mode({
    required this.icon,
    required this.label,
    required this.value,
    required this.on,
    required this.live,
    required this.onChanged,
    this.locked = false,
    this.onLockedTap,
  });
  final IconData icon;
  final String label, value;

  /// Switched on by the companion.
  final bool on;

  /// On and online: calls of this type can ring now.
  final bool live;
  final bool locked;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onLockedTap;

  static const _green = Color(0xFF6EE7B7);

  @override
  Widget build(BuildContext context) => Semantics(
    toggled: locked ? null : on,
    button: locked,
    label: locked
        ? '$label calls locked. Finish the academy to unlock.'
        : '$label calls',
    excludeSemantics: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: locked
          ? onLockedTap
          : (onChanged == null ? null : () => onChanged!(!on)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
        decoration: BoxDecoration(
          color: on ? const Color(0x1A10B981) : AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: on ? const Color(0x6610B981) : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(
              locked ? Icons.lock_outline_rounded : icon,
              size: 20,
              color: live ? _green : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppText.body(14, weight: FontWeight.w700)),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(
                      12,
                      color: live ? _green : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (!locked)
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: on,
                  onChanged: onChanged,
                  activeThumbColor: Colors.white,
                  activeTrackColor: const Color(0xFF10B981),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.label,
    required this.value,
    this.highlight = false,
  });
  final String label, value;
  final bool highlight;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.body(12.5, color: AppColors.textSecondary)),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            value,
            style: AppText.heading(
              20,
              color: highlight ? const Color(0xFF6EE7B7) : Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

/// Go live: stream to many viewers who pay by the pass. Needs video unlocked.
class _GoLiveCard extends ConsumerWidget {
  const _GoLiveCard({required this.unlocked});
  final bool unlocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Semantics(
    button: true,
    label: unlocked ? 'Go live' : 'Go live is locked until video calls unlock',
    excludeSemantics: true,
    child: InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: unlocked
          ? () => showGoLiveSheet(context, ref)
          : () => context.push('/academy'),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: unlocked
              ? const LinearGradient(
                  colors: [Color(0xFF9F1239), Color(0xFF7C3AED)],
                )
              : null,
          color: unlocked ? null : AppColors.card,
          border: Border.all(
            color: unlocked ? Colors.transparent : AppColors.cardBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: unlocked ? 0.18 : 0.08),
              ),
              child: Icon(
                unlocked ? Icons.videocam_rounded : Icons.lock_outline_rounded,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Go live', style: AppText.heading(17)),
                      if (unlocked) ...[
                        const SizedBox(width: 8),
                        const LiveBadge(small: true),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    unlocked
                        ? 'Stream to many at once. Earn from every pass and gift.'
                        : 'Unlocks with video calls — finish the academy.',
                    style: AppText.body(
                      12.5,
                      color: unlocked
                          ? Colors.white70
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white70),
          ],
        ),
      ),
    ),
  );
}
