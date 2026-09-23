import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/api.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'companion_data.dart';
import 'selfie_capture.dart';

const _green = Color(0xFF10B981);

/// Design: KycSelfie.dc.html stepper — 1 Aadhaar · 2 Selfie · 3 PAN & UPI.
class KycScreen extends ConsumerWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kyc = ref.watch(kycProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: kyc.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: _green)),
            error: (e, _) => Center(
              child: TextButton(
                onPressed: () => ref.invalidate(kycProvider),
                child: Text(friendlyError(e)),
              ),
            ),
            data: (s) => _Body(s),
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body(this.s);
  final KycState s;

  int get _step => !s.aadhaar.done
      ? 0
      : !s.selfie.done
      ? 1
      : 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locked =
        s.status == KycStateStatusEnum.submitted ||
        s.status == KycStateStatusEnum.approved;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        Row(
          children: [
            CircleIconButton(
              icon: Icons.arrow_back_rounded,
              tooltip: 'Back',
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/companion'),
            ),
            const SizedBox(width: 12),
            Text('Verify it\'s you', style: AppText.heading(22)),
          ],
        ),
        const SizedBox(height: 18),
        _Stepper(
          done: [s.aadhaar.done, s.selfie.done, s.pan.done && s.upi.done],
          current: locked ? 3 : _step,
        ),
        const SizedBox(height: 18),
        if (s.status == KycStateStatusEnum.submitted)
          const _Banner(
            icon: Icons.hourglass_top_rounded,
            color: Color(0xFFFBBF24),
            title: 'Under review',
            body:
                'We usually check within a few hours. You\'ll be able to go online once approved.',
          ),
        if (s.status == KycStateStatusEnum.approved)
          const _Banner(
            icon: Icons.verified_rounded,
            color: _green,
            title: 'You\'re verified',
            body: 'Go online from your home screen to start taking calls.',
          ),
        if (s.status == KycStateStatusEnum.rejected)
          _Banner(
            icon: Icons.error_outline_rounded,
            color: AppColors.danger,
            title: 'Please fix and resubmit',
            body: s.rejectReason ?? 'Something didn\'t match.',
          ),
        const SizedBox(height: 12),
        _AadhaarCard(s: s, locked: locked),
        const SizedBox(height: 12),
        _SelfieCard(s: s, locked: locked),
        const SizedBox(height: 12),
        _PanUpiCard(s: s, locked: locked),
        const SizedBox(height: 20),
        if (!locked)
          _SubmitButton(
            ready: s.aadhaar.done && s.selfie.done && s.pan.done && s.upi.done,
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline_rounded,
              size: 15,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              'Stored encrypted, used only for verification',
              style: AppText.body(12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.done, required this.current});
  final List<bool> done;
  final int current;

  @override
  Widget build(BuildContext context) {
    const labels = ['Aadhaar', 'Selfie', 'PAN & UPI'];
    return Row(
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                color: done[i - 1]
                    ? _green
                    : Colors.white.withValues(alpha: 0.15),
              ),
            ),
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done[i]
                      ? _green
                      : i == current
                      ? const Color(0x3310B981)
                      : Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: done[i] || i == current
                        ? _green
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: done[i]
                    ? const Icon(
                        Icons.check_rounded,
                        size: 17,
                        color: Colors.white,
                      )
                    : Text(
                        '${i + 1}',
                        style: AppText.body(13, weight: FontWeight.w700),
                      ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[i],
                style: AppText.body(
                  12,
                  color: i == current ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final Color color;
  final String title, body;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withValues(alpha: 0.45)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.body(15, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppText.body(
                  13.5,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.done,
    required this.child,
    this.summary,
  });
  final int number;
  final String title;
  final bool done;
  final String? summary;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: done ? const Color(0x5510B981) : AppColors.cardBorder,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$number · $title',
              style: AppText.heading(17, weight: FontWeight.w700),
            ),
            const Spacer(),
            if (done)
              const Icon(Icons.check_circle_rounded, color: _green, size: 22),
          ],
        ),
        if (summary != null) ...[
          const SizedBox(height: 4),
          Text(
            summary!,
            style: AppText.body(13.5, color: const Color(0xFF6EE7B7)),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    ),
  );
}

/// Uploads, refreshes the KYC state and shows server errors.
Future<void> _run(
  BuildContext context,
  WidgetRef ref,
  Future<Object?> Function(PesuApi api) action, {
  String? ok,
}) async {
  final api = ref.read(apiProvider);
  try {
    await api.call(() => action(api));
    ref.invalidate(kycProvider);
    if (ok != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok)));
    }
  } catch (e) {
    if (context.mounted) showError(context, friendlyError(e));
  }
}

// ---------------------------------------------------------------------------
class _AadhaarCard extends ConsumerStatefulWidget {
  const _AadhaarCard({required this.s, required this.locked});
  final KycState s;
  final bool locked;

  @override
  ConsumerState<_AadhaarCard> createState() => _AadhaarCardState();
}

class _AadhaarCardState extends ConsumerState<_AadhaarCard> {
  final _code = TextEditingController();
  PlatformFile? _file;
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final f = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['zip'],
    );
    if (f != null) setState(() => _file = f);
  }

  Future<void> _upload() async {
    if (_file == null) return;
    final bytes = await _file!.readAsBytes();
    setState(() => _busy = true);
    await _run(
      context,
      ref,
      (api) => api.companion.uploadAadhaar(
        UploadAadhaarRequest(
          zipBase64: base64Encode(bytes),
          shareCode: _code.text.trim(),
        ),
      ),
      ok: 'Aadhaar verified',
    );
    if (mounted)
      setState(() {
        _busy = false;
        _file = null;
        _code.clear();
      });
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.s.aadhaar;
    return _StepCard(
      number: 1,
      title: 'Aadhaar offline e-KYC',
      done: a.done,
      summary: a.done ? '${a.name} · Aadhaar ending ${a.last4}' : null,
      child: widget.locked
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. On myaadhaar.uidai.gov.in open “Offline eKYC”.\n2. Set a 4-character share code and download the ZIP.\n3. Pick that ZIP here and enter the same share code.',
                  style: AppText.body(
                    13.5,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _pick,
                  icon: const Icon(Icons.folder_zip_outlined),
                  label: Text(
                    _file?.name ??
                        (a.done ? 'Replace with a new ZIP' : 'Choose ZIP file'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (_file != null) ...[
                  const SizedBox(height: 10),
                  TextField(
                    controller: _code,
                    maxLength: 4,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      labelText: 'Share code',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 10),
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _green),
                    onPressed: _busy || _code.text.trim().length != 4
                        ? null
                        : _upload,
                    child: Text(
                      _busy
                          ? 'Checking with UIDAI signature…'
                          : 'Verify Aadhaar',
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

// ---------------------------------------------------------------------------
class _SelfieCard extends ConsumerWidget {
  const _SelfieCard({required this.s, required this.locked});
  final KycState s;
  final bool locked;

  @override
  Widget build(BuildContext context, WidgetRef ref) => _StepCard(
    number: 2,
    title: 'Live selfie',
    done: s.selfie.done,
    summary: s.selfie.done ? 'Selfie taken' : null,
    child: locked
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We match it with your Aadhaar photo. Callers never see it.',
                style: AppText.body(13.5, color: AppColors.textMuted),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  for (final t in const [
                    'Blink twice',
                    'Bright, even light',
                    'No sunglasses or mask',
                    'Only you in the frame',
                  ])
                    Chip(
                      label: Text(t, style: AppText.body(12.5)),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: _green),
                onPressed: !s.aadhaar.done
                    ? null
                    : () async {
                        final shot = await Navigator.of(context)
                            .push<SelfieResult>(
                              MaterialPageRoute(
                                builder: (_) => const SelfieCapture(),
                              ),
                            );
                        if (shot == null || !context.mounted) return;
                        await _run(
                          context,
                          ref,
                          (api) => api.companion.uploadSelfie(
                            UploadSelfieRequest(
                              imageBase64: base64Encode(shot.jpeg),
                              blinks: shot.blinks,
                            ),
                          ),
                          ok: 'Selfie saved',
                        );
                      },
                icon: const Icon(Icons.photo_camera_front_outlined),
                label: Text(
                  s.selfie.done
                      ? 'Retake selfie'
                      : s.aadhaar.done
                      ? 'Start camera'
                      : 'Finish Aadhaar first',
                ),
              ),
            ],
          ),
  );
}

// ---------------------------------------------------------------------------
class _PanUpiCard extends ConsumerStatefulWidget {
  const _PanUpiCard({required this.s, required this.locked});
  final KycState s;
  final bool locked;

  @override
  ConsumerState<_PanUpiCard> createState() => _PanUpiCardState();
}

class _PanUpiCardState extends ConsumerState<_PanUpiCard> {
  final _pan = TextEditingController();
  final _upi = TextEditingController();
  XFile? _panPhoto;
  bool _busy = false;

  @override
  void dispose() {
    _pan.dispose();
    _upi.dispose();
    super.dispose();
  }

  bool get _panValid => RegExp(
    r'^[A-Z]{3}P[A-Z][0-9]{4}[A-Z]$',
  ).hasMatch(_pan.text.trim().toUpperCase());
  bool get _upiValid => RegExp(
    r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z][a-zA-Z0-9.]{1,63}$',
  ).hasMatch(_upi.text.trim());

  Future<void> _savePan() async {
    final bytes = await _panPhoto!.readAsBytes();
    setState(() => _busy = true);
    if (!mounted) return;
    await _run(
      context,
      ref,
      (api) => api.companion.uploadPan(
        UploadPanRequest(
          panNumber: _pan.text.trim().toUpperCase(),
          imageBase64: base64Encode(bytes),
        ),
      ),
      ok: 'PAN saved',
    );
    if (mounted)
      setState(() {
        _busy = false;
        _panPhoto = null;
        _pan.clear();
      });
  }

  Future<void> _saveUpi() async {
    setState(() => _busy = true);
    await _run(
      context,
      ref,
      (api) => api.companion.setUpi(SetUpiRequest(upiId: _upi.text.trim())),
      ok: 'UPI ID saved',
    );
    if (mounted)
      setState(() {
        _busy = false;
        _upi.clear();
      });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final summary = [
      if (s.pan.done) 'PAN ••••${s.pan.last4}',
      if (s.upi.done) s.upi.masked!,
    ].join(' · ');
    return _StepCard(
      number: 3,
      title: 'PAN & UPI',
      done: s.pan.done && s.upi.done,
      summary: summary.isEmpty ? null : summary,
      child: widget.locked
          ? const SizedBox.shrink()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'PAN is needed to deduct TDS. Earnings are paid to your UPI ID.',
                  style: AppText.body(13.5, color: AppColors.textMuted),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _pan,
                  maxLength: 10,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: s.pan.done ? 'Replace PAN number' : 'PAN number',
                    hintText: 'ABCPE1234F',
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final f = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            maxWidth: 1600,
                            imageQuality: 80,
                          );
                          if (f != null) setState(() => _panPhoto = f);
                        },
                        icon: const Icon(Icons.badge_outlined),
                        label: Text(
                          _panPhoto == null
                              ? 'Photo of PAN card'
                              : 'Photo added ✓',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: _green),
                      onPressed: _busy || !_panValid || _panPhoto == null
                          ? null
                          : _savePan,
                      child: const Text('Save PAN'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _upi,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: s.upi.done ? 'Change UPI ID' : 'UPI ID',
                    hintText: 'name@okaxis',
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: _green),
                    onPressed: _busy || !_upiValid ? null : _saveUpi,
                    child: const Text('Save UPI'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _SubmitButton extends ConsumerStatefulWidget {
  const _SubmitButton({required this.ready});
  final bool ready;

  @override
  ConsumerState<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends ConsumerState<_SubmitButton> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) => GradientButton(
    label: widget.ready ? 'Submit for review' : 'Finish all 3 steps',
    loading: _busy,
    onPressed: !widget.ready
        ? null
        : () async {
            setState(() => _busy = true);
            await _run(
              context,
              ref,
              (api) => api.companion.submitKyc(),
              ok: 'Sent for review',
            );
            ref.invalidate(companionHomeProvider);
            if (mounted) setState(() => _busy = false);
          },
  );
}
