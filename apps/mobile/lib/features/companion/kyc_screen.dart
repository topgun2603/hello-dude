import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/api.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import 'companion_data.dart';
import 'selfie_capture.dart';

const _green = Color(0xFF10B981);
const _mint = Color(0xFF6EE7B7);
const _amber = Color(0xFFFBBF24);
const _companion = LinearGradient(colors: [_green, Color(0xFF0E7490)]);

/// Guided flow, one step per page: Age (18+) · Selfie · Voice intro (women) ·
/// UPI · Send. No Aadhaar. PAN is optional (any time, even after approval);
/// without it withdrawals carry 20% TDS. Once sent (or approved) the screen
/// shows the status instead of the steps.
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
            data: (s) =>
                s.status == KycStateStatusEnum.submitted ||
                    s.status == KycStateStatusEnum.approved
                ? _StatusView(s)
                : _Wizard(s),
          ),
        ),
      ),
    );
  }
}

enum _Step { age, selfie, voice, upi, review }

extension on _Step {
  String get label => switch (this) {
    _Step.age => 'Age',
    _Step.selfie => 'Selfie',
    _Step.voice => 'Voice',
    _Step.upi => 'UPI',
    _Step.review => 'Send',
  };

  IconData get icon => switch (this) {
    _Step.age => Icons.cake_outlined,
    _Step.selfie => Icons.face_retouching_natural_rounded,
    _Step.voice => Icons.mic_none_rounded,
    _Step.upi => Icons.account_balance_wallet_outlined,
    _Step.review => Icons.verified_user_outlined,
  };

  KycStateRedoEnum? get redo => switch (this) {
    _Step.age => KycStateRedoEnum.age,
    _Step.selfie => KycStateRedoEnum.selfie,
    _Step.voice => KycStateRedoEnum.voice,
    _Step.upi => KycStateRedoEnum.upi,
    _Step.review => null,
  };
}

List<_Step> _stepsFor(KycState s) => [
  _Step.age,
  _Step.selfie,
  if (s.voice.needed) _Step.voice,
  _Step.upi,
  _Step.review,
];

bool _isDone(KycState s, _Step st) => switch (st) {
  _Step.age => s.age.done,
  _Step.selfie => s.selfie.done,
  _Step.voice => s.voice.done,
  _Step.upi => s.upi.done,
  _Step.review => false,
};

String _redoLabel(KycStateRedoEnum r) => switch (r) {
  KycStateRedoEnum.age => 'date of birth',
  KycStateRedoEnum.selfie => 'selfie',
  KycStateRedoEnum.voice => 'voice intro',
  KycStateRedoEnum.pan => 'PAN',
  KycStateRedoEnum.upi => 'UPI ID',
};

/// Uploads, refreshes the KYC state and shows server errors. True on success.
Future<bool> _run(
  BuildContext context,
  WidgetRef ref,
  Future<Object?> Function(PesuApi api) action, {
  String? ok,
}) async {
  final api = ref.read(apiProvider);
  try {
    final before = ref.read(kycProvider).valueOrNull?.status;
    final result = await api.call(() => action(api));
    ref.invalidate(kycProvider);
    // Sending the last thing a rejection asked for puts it back in review.
    final resubmitted =
        before == KycStateStatusEnum.rejected &&
        result is KycState &&
        result.status == KycStateStatusEnum.submitted;
    if (resubmitted) ref.invalidate(companionHomeProvider);
    final msg = resubmitted ? 'Sent for review again ✓' : ok;
    if (msg != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
    return true;
  } catch (e) {
    if (context.mounted) showError(context, friendlyError(e));
    return false;
  }
}

// ---------------------------------------------------------------------------
class _Wizard extends StatefulWidget {
  const _Wizard(this.s);
  final KycState s;

  @override
  State<_Wizard> createState() => _WizardState();
}

class _WizardState extends State<_Wizard> {
  late _Step _page = _firstOpen;

  KycState get s => widget.s;
  List<_Step> get _steps => _stepsFor(s);

  /// The first step still to do (Send once everything is in).
  _Step get _firstOpen =>
      _steps.firstWhere((st) => st == _Step.review || !_isDone(s, st));

  bool _canOpen(_Step st) =>
      _isDone(s, st) || _steps.indexOf(st) <= _steps.indexOf(_firstOpen);

  void _go(_Step st) => setState(() => _page = st);

  /// After a step is saved: the next one still to do, else Send.
  void _next(_Step from) {
    final after = _steps.skip(_steps.indexOf(from) + 1);
    _go(after.firstWhere((st) => st == _Step.review || !_isDone(s, st)));
  }

  @override
  Widget build(BuildContext context) {
    if (!_steps.contains(_page)) _page = _firstOpen;
    final i = _steps.indexOf(_page);
    final rejected = s.status == KycStateStatusEnum.rejected;
    return PopScope(
      canPop: i == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _go(_steps[i - 1]);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => i > 0
                          ? _go(_steps[i - 1])
                          : context.canPop()
                          ? context.pop()
                          : context.go('/companion'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Verify it\'s you',
                        style: AppText.heading(22),
                      ),
                    ),
                    Text(
                      'Step ${i + 1} of ${_steps.length}',
                      style: AppText.body(13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _Progress(
                  steps: _steps,
                  current: _page,
                  isDone: (st) => _isDone(s, st),
                  onTap: (st) => _canOpen(st) ? _go(st) : null,
                ),
                if (rejected) ...[
                  const SizedBox(height: 14),
                  _Banner(
                    icon: Icons.error_outline_rounded,
                    color: AppColors.danger,
                    title: s.redo.isEmpty
                        ? 'Please fix and resubmit'
                        : 'Please send again: ${s.redo.map(_redoLabel).join(', ')}',
                    body: [
                      s.rejectReason ?? 'Something didn\'t match.',
                      if (s.redo.isNotEmpty)
                        'It goes back for review by itself once you send ${s.redo.length == 1 ? 'it' : 'them'}.',
                    ].join('\n'),
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              layoutBuilder: (current, previous) => Stack(
                fit: StackFit.expand,
                children: [...previous, ?current],
              ),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0.06, 0),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: KeyedSubtree(
                key: ValueKey(_page),
                child: switch (_page) {
                  _Step.age => _AgePage(s: s, onNext: () => _next(_Step.age)),
                  _Step.selfie => _SelfiePage(
                    s: s,
                    onNext: () => _next(_Step.selfie),
                  ),
                  _Step.voice => _VoicePage(
                    s: s,
                    onNext: () => _next(_Step.voice),
                  ),
                  _Step.upi => _UpiPage(s: s, onNext: () => _next(_Step.upi)),
                  _Step.review => _ReviewPage(s: s, onEdit: _go),
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Segmented bar: filled = done, glowing = where you are. Tap to jump.
class _Progress extends StatelessWidget {
  const _Progress({
    required this.steps,
    required this.current,
    required this.isDone,
    required this.onTap,
  });
  final List<_Step> steps;
  final _Step current;
  final bool Function(_Step) isDone;
  final void Function(_Step) onTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (final (n, st) in steps.indexed) ...[
        if (n > 0) const SizedBox(width: 6),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(st),
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    gradient: isDone(st) || st == current ? _companion : null,
                    color: isDone(st) || st == current
                        ? null
                        : Colors.white.withValues(alpha: 0.12),
                    boxShadow: st == current
                        ? const [
                            BoxShadow(color: Color(0x8810B981), blurRadius: 8),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isDone(st)) ...[
                      const Icon(Icons.check_rounded, size: 13, color: _mint),
                      const SizedBox(width: 2),
                    ],
                    Flexible(
                      child: Text(
                        st.label,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        style: AppText.body(
                          12,
                          weight: st == current
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: st == current
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ],
  );
}

/// Big glowing icon at the top of each step.
class _Hero extends StatelessWidget {
  const _Hero(this.icon, {this.color = _green, this.size = 96});
  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.38),
            color.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 36),
        ],
      ),
      child: Icon(icon, size: size * 0.46, color: Colors.white),
    ),
  );
}

/// Hero, title, explanation, the step's content, and buttons at the bottom.
class _Page extends StatelessWidget {
  const _Page({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.actions,
  });
  final IconData icon;
  final String title, subtitle;
  final List<Widget> content, actions;

  @override
  Widget build(BuildContext context) => FillScrollView(
    padding: const EdgeInsets.fromLTRB(20, 26, 20, 20),
    children: [
      _Hero(icon),
      const SizedBox(height: 20),
      Text(title, textAlign: TextAlign.center, style: AppText.heading(24)),
      const SizedBox(height: 8),
      Text(
        subtitle,
        textAlign: TextAlign.center,
        style: AppText.body(14, color: AppColors.textMuted, height: 1.45),
      ),
      const SizedBox(height: 24),
      ...content,
      const Spacer(),
      const SizedBox(height: 20),
      ...actions,
    ],
  );
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
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: color.withValues(alpha: 0.45)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.body(14, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(
                body,
                style: AppText.body(
                  13,
                  color: AppColors.textMuted,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

/// Green "already saved" tile.
class _DoneTile extends StatelessWidget {
  const _DoneTile({required this.title, required this.subtitle});
  final String title, subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0x1F10B981),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0x5510B981)),
    ),
    child: Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: _green, size: 26),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppText.body(15, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppText.body(13, color: _mint)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, this.icon, this.onPressed});
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon ?? Icons.refresh_rounded, size: 20),
    label: Text(label, style: AppText.body(15, weight: FontWeight.w600)),
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(52),
      shape: const StadiumBorder(),
      side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
    ),
  );
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.lock_outline_rounded,
          size: 15,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'Stored encrypted, used only for verification',
            style: AppText.body(12.5, color: AppColors.textSecondary),
          ),
        ),
      ],
    ),
  );
}

// ---------------------------------------------------------------------------
class _AgePage extends ConsumerStatefulWidget {
  const _AgePage({required this.s, required this.onNext});
  final KycState s;
  final VoidCallback onNext;

  @override
  ConsumerState<_AgePage> createState() => _AgePageState();
}

class _AgePageState extends ConsumerState<_AgePage> {
  DateTime? _dob;
  bool _confirmed = false, _busy = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _iso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static String _pretty(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static int _years(DateTime d) {
    final now = DateTime.now();
    final hadBirthday =
        now.month > d.month || (now.month == d.month && now.day >= d.day);
    return now.year - d.year - (hadBirthday ? 0 : 1);
  }

  Future<void> _pick() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 22, now.month, now.day),
      firstDate: DateTime(1940),
      lastDate: now,
      helpText: 'Your date of birth',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDatePickerMode: DatePickerMode.year,
    );
    if (d != null) setState(() => _dob = d);
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    final ok = await _run(
      context,
      ref,
      (api) => api.companion.confirmCompanionAge(
        ConfirmCompanionAgeRequest(birthDate: _iso(_dob!), confirm18: true),
      ),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.s.age;
    final picking = _dob != null;
    return _Page(
      icon: _Step.age.icon,
      title: 'When were you born?',
      subtitle:
          'Companions must be 18 or older. Giving a false age gets the account closed.',
      content: [
        if (a.done && !picking) ...[
          _DoneTile(
            title: 'Born ${a.birthDate}',
            subtitle: '${a.age} years · saved',
          ),
          const SizedBox(height: 12),
        ],
        Material(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: _busy ? null : _pick,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: picking
                      ? const Color(0x8810B981)
                      : AppColors.cardBorder,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_rounded, color: _mint),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.done ? 'Change date of birth' : 'Date of birth',
                          style: AppText.body(
                            12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          picking ? _pretty(_dob!) : 'Tap to pick',
                          style: AppText.heading(
                            18,
                            weight: FontWeight.w700,
                            color: picking ? Colors.white : AppColors.hint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (picking)
                    Text(
                      '${_years(_dob!)} yrs',
                      style: AppText.body(
                        14,
                        weight: FontWeight.w700,
                        color: _mint,
                      ),
                    )
                  else
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!a.done || picking) ...[
          const SizedBox(height: 12),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _confirmed = !_confirmed),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      gradient: _confirmed ? _companion : null,
                      border: Border.all(
                        color: _confirmed
                            ? _green
                            : Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: _confirmed
                        ? const Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'I confirm I am 18 or older',
                      style: AppText.body(15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
      actions: [
        GradientButton(
          gradient: _companion,
          label: picking ? 'Save & continue' : 'Continue',
          loading: _busy,
          onPressed: picking
              ? (_confirmed ? _save : null)
              : (a.done ? widget.onNext : null),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
class _SelfiePage extends ConsumerWidget {
  const _SelfiePage({required this.s, required this.onNext});
  final KycState s;
  final VoidCallback onNext;

  Future<void> _capture(BuildContext context, WidgetRef ref) async {
    final shot = await Navigator.of(context).push<SelfieResult>(
      MaterialPageRoute(builder: (_) => const SelfieCapture()),
    );
    if (shot == null || !context.mounted) return;
    final ok = await _run(
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
    if (ok) onNext();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const tips = [
      (Icons.remove_red_eye_outlined, 'Blink twice'),
      (Icons.wb_sunny_outlined, 'Bright, even light'),
      (Icons.masks_outlined, 'No sunglasses or mask'),
      (Icons.person_outline_rounded, 'Only you in the frame'),
    ];
    Widget tip((IconData, String) t) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(t.$1, size: 20, color: _mint),
            const SizedBox(width: 10),
            Expanded(child: Text(t.$2, style: AppText.body(13, height: 1.25))),
          ],
        ),
      ),
    );
    return _Page(
      icon: _Step.selfie.icon,
      title: 'Take a live selfie',
      subtitle:
          'Our team checks it before you can take calls. Callers never see it.',
      content: [
        Row(children: [tip(tips[0]), const SizedBox(width: 10), tip(tips[1])]),
        const SizedBox(height: 10),
        Row(children: [tip(tips[2]), const SizedBox(width: 10), tip(tips[3])]),
        if (s.selfie.done) ...[
          const SizedBox(height: 16),
          const _DoneTile(
            title: 'Selfie saved',
            subtitle: 'Our team compares it during review',
          ),
        ],
      ],
      actions: s.selfie.done
          ? [
              GradientButton(
                gradient: _companion,
                label: 'Continue',
                onPressed: onNext,
              ),
              const SizedBox(height: 10),
              _SecondaryButton(
                label: 'Retake selfie',
                onPressed: () => _capture(context, ref),
              ),
            ]
          : [
              GradientButton(
                gradient: _companion,
                icon: Icons.photo_camera_front_outlined,
                label: s.age.done ? 'Start camera' : 'Add your age first',
                onPressed: s.age.done ? () => _capture(context, ref) : null,
              ),
            ],
    );
  }
}

// ---------------------------------------------------------------------------
/// Women companions read a random sentence aloud (3–15 s). An admin listens to
/// it next to the selfie; the clip is deleted once they decide.
class _VoicePage extends ConsumerStatefulWidget {
  const _VoicePage({required this.s, required this.onNext});
  final KycState s;
  final VoidCallback onNext;

  @override
  ConsumerState<_VoicePage> createState() => _VoicePageState();
}

class _VoicePageState extends ConsumerState<_VoicePage>
    with SingleTickerProviderStateMixin {
  static const _maxSeconds = 15;
  final _recorder = AudioRecorder();
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );
  bool _recording = false, _busy = false;
  int _seconds = 0;
  Timer? _tick;

  @override
  void dispose() {
    _tick?.cancel();
    _pulse.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        showError(context, 'Allow the microphone to record your voice intro.');
      }
      return;
    }
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_intro_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 22050,
        numChannels: 1,
      ),
      path: path,
    );
    setState(() {
      _recording = true;
      _seconds = 0;
    });
    unawaited(_pulse.repeat());
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
      if (_seconds >= _maxSeconds) _stop();
    });
  }

  Future<void> _stop() async {
    _tick?.cancel();
    _pulse
      ..stop()
      ..reset();
    final path = await _recorder.stop();
    setState(() => _recording = false);
    if (path == null || !mounted) return;
    final file = File(path);
    if (_seconds < 3) {
      showError(context, 'That was too short — read the whole sentence.');
      unawaited(file.delete().catchError((_) => file));
      return;
    }
    setState(() => _busy = true);
    final bytes = await file.readAsBytes();
    unawaited(file.delete().catchError((_) => file));
    if (!mounted) return;
    final ok = await _run(
      context,
      ref,
      (api) => api.companion.uploadVoiceIntro(
        UploadVoiceIntroRequest(audioBase64: base64Encode(bytes)),
      ),
      ok: 'Voice intro saved',
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.s.voice;
    final color = _recording ? AppColors.danger : _green;
    final status = _busy
        ? 'Saving…'
        : _recording
        ? '0:${_seconds.toString().padLeft(2, '0')} / 0:$_maxSeconds · tap to stop'
        : v.done
        ? 'Recorded ✓ · tap to record again'
        : 'Tap to record · 3–15 seconds';
    return _Page(
      icon: _Step.voice.icon,
      title: 'Record your voice intro',
      subtitle:
          'Read this aloud in your normal voice. Only our team hears it, and it is deleted after review.',
      content: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
          decoration: BoxDecoration(
            color: const Color(0x2210B981),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0x5510B981)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.format_quote_rounded,
                    color: _mint,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Read this aloud',
                    style: AppText.body(
                      12.5,
                      weight: FontWeight.w600,
                      color: _mint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                v.sentence ?? 'Loading your sentence…',
                style: AppText.heading(
                  19,
                  weight: FontWeight.w700,
                ).copyWith(height: 1.35),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        Center(
          child: GestureDetector(
            onTap: _busy || v.sentence == null
                ? null
                : (_recording ? _stop : _start),
            child: SizedBox(
              width: 132,
              height: 132,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_recording)
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (_, _) => Container(
                        width: 88 + 44 * _pulse.value,
                        height: 88 + 44 * _pulse.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(
                            alpha: 0.35 * (1 - _pulse.value),
                          ),
                        ),
                      ),
                    ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _recording
                          ? const LinearGradient(
                              colors: [Color(0xFFF43F5E), AppColors.danger],
                            )
                          : _companion,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.5),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: _busy
                        ? const Padding(
                            padding: EdgeInsets.all(30),
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _recording ? Icons.stop_rounded : Icons.mic_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        if (_recording)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 6),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: _seconds / _maxSeconds,
                minHeight: 4,
                color: AppColors.danger,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
        Text(
          status,
          textAlign: TextAlign.center,
          style: AppText.body(
            13.5,
            color: v.done && !_recording ? _mint : AppColors.textSecondary,
          ),
        ),
      ],
      actions: [
        GradientButton(
          gradient: _companion,
          label: 'Continue',
          onPressed: v.done && !_recording && !_busy ? widget.onNext : null,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
class _UpiPage extends ConsumerStatefulWidget {
  const _UpiPage({required this.s, required this.onNext});
  final KycState s;
  final VoidCallback onNext;

  @override
  ConsumerState<_UpiPage> createState() => _UpiPageState();
}

class _UpiPageState extends ConsumerState<_UpiPage> {
  final _upi = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _upi.dispose();
    super.dispose();
  }

  bool get _typing => _upi.text.trim().isNotEmpty;

  bool get _upiValid => RegExp(
    r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z][a-zA-Z0-9.]{1,63}$',
  ).hasMatch(_upi.text.trim());

  Future<void> _save() async {
    setState(() => _busy = true);
    final ok = await _run(
      context,
      ref,
      (api) => api.companion.setUpi(SetUpiRequest(upiId: _upi.text.trim())),
      ok: 'UPI ID saved',
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      _upi.clear();
      widget.onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.s.upi;
    return _Page(
      icon: _Step.upi.icon,
      title: 'Where should we pay you?',
      subtitle: 'Your earnings are withdrawn to this UPI ID.',
      content: [
        if (u.done) ...[
          _DoneTile(
            title: u.masked ?? 'UPI ID saved',
            subtitle: 'Payouts go here · type a new one to change it',
          ),
          const SizedBox(height: 14),
        ],
        TextField(
          controller: _upi,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          onChanged: (_) => setState(() {}),
          style: AppText.body(16),
          decoration: InputDecoration(
            labelText: u.done ? 'New UPI ID' : 'UPI ID',
            hintText: 'yourname@okaxis',
            prefixIcon: const Icon(Icons.alternate_email_rounded),
            suffixIcon: _upiValid
                ? const Icon(Icons.check_circle_rounded, color: _green)
                : null,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline_rounded, size: 16, color: _amber),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Double-check it — money sent to a wrong UPI ID can\'t be pulled back.',
                style: AppText.body(
                  12.5,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ],
      actions: [
        GradientButton(
          gradient: _companion,
          label: _typing ? 'Save & continue' : 'Continue',
          loading: _busy,
          onPressed: _typing
              ? (_upiValid ? _save : null)
              : (u.done ? widget.onNext : null),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
/// Everything at a glance; tap a row to fix it. PAN (optional) and Submit.
class _ReviewPage extends ConsumerStatefulWidget {
  const _ReviewPage({required this.s, required this.onEdit});
  final KycState s;
  final void Function(_Step) onEdit;

  @override
  ConsumerState<_ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<_ReviewPage> {
  bool _busy = false;

  Future<void> _submit() async {
    setState(() => _busy = true);
    await _run(
      context,
      ref,
      (api) => api.companion.submitKyc(),
      ok: 'Sent for review',
    );
    ref.invalidate(companionHomeProvider);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    final ready = _stepsFor(
      s,
    ).where((st) => st != _Step.review).every((st) => _isDone(s, st));
    // After a rejection that names what to redo, sending it resubmits by itself.
    final redoing = s.redo.isNotEmpty;
    return _Page(
      icon: _Step.review.icon,
      title: redoing ? 'Send what was asked' : 'Ready to send?',
      subtitle: redoing
          ? 'Fix the items marked below. It goes back for review by itself.'
          : 'Check your details. We usually review within a few hours.',
      content: [
        _Checklist(s: s, onEdit: widget.onEdit),
        const SizedBox(height: 14),
        _PanCard(s: s, locked: false),
      ],
      actions: [
        if (!redoing)
          GradientButton(
            gradient: _companion,
            label: ready ? 'Submit for review' : 'Finish the steps above',
            icon: ready ? Icons.send_rounded : null,
            loading: _busy,
            onPressed: ready ? _submit : null,
          ),
        const _PrivacyNote(),
      ],
    );
  }
}

/// One card listing each step with its status. Rows open the step when
/// [onEdit] is given (read-only on the status screen).
class _Checklist extends StatelessWidget {
  const _Checklist({required this.s, this.onEdit, this.editable});
  final KycState s;
  final void Function(_Step)? onEdit;

  /// Rows that open [onEdit]; null = all of them.
  final Set<_Step>? editable;

  (String, String) _text(_Step st) => switch (st) {
    _Step.age => (
      'Date of birth',
      s.age.done ? '${s.age.age} years' : 'Not added',
    ),
    _Step.selfie => ('Live selfie', s.selfie.done ? 'Taken' : 'Not taken'),
    _Step.voice => ('Voice intro', s.voice.done ? 'Recorded' : 'Not recorded'),
    _Step.upi => (
      'UPI ID',
      s.upi.done ? (s.upi.masked ?? 'Saved') : 'Not added',
    ),
    _Step.review => ('', ''),
  };

  @override
  Widget build(BuildContext context) {
    final steps = _stepsFor(s).where((st) => st != _Step.review).toList();
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            for (final (n, st) in steps.indexed) ...[
              if (n > 0)
                Divider(height: 1, color: Colors.white.withValues(alpha: 0.06)),
              _row(st),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(_Step st) {
    final done = _isDone(s, st);
    final redo = s.redo.contains(st.redo);
    final (title, detail) = _text(st);
    final edit = onEdit != null && (editable?.contains(st) ?? true);
    return InkWell(
      onTap: edit ? () => onEdit!(st) : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done
                    ? const Color(0x2610B981)
                    : Colors.white.withValues(alpha: 0.07),
              ),
              child: Icon(
                st.icon,
                size: 20,
                color: done ? _mint : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.body(15, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    detail,
                    style: AppText.body(
                      13,
                      color: done ? _mint : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (redo && !done)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Send again',
                  style: AppText.body(
                    11.5,
                    weight: FontWeight.w700,
                    color: const Color(0xFFFDA4AF),
                  ),
                ),
              )
            else if (done)
              const Icon(Icons.check_circle_rounded, color: _green, size: 22)
            else if (edit)
              Text(
                'Add',
                style: AppText.body(14, weight: FontWeight.w700, color: _mint),
              ),
            if (edit) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
/// Sent or approved: what happens next, what was sent, and PAN (which can be
/// added any time after approval).
class _StatusView extends StatelessWidget {
  const _StatusView(this.s);
  final KycState s;

  @override
  Widget build(BuildContext context) {
    final approved = s.status == KycStateStatusEnum.approved;
    return FillScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
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
            Text('Verification', style: AppText.heading(22)),
          ],
        ),
        const SizedBox(height: 30),
        _Hero(
          approved ? Icons.verified_rounded : Icons.hourglass_top_rounded,
          color: approved ? _green : _amber,
          size: 112,
        ),
        const SizedBox(height: 22),
        Text(
          approved ? 'You\'re verified' : 'Under review',
          textAlign: TextAlign.center,
          style: AppText.heading(26),
        ),
        const SizedBox(height: 8),
        Text(
          approved
              ? 'Go online from your home screen to start taking calls.'
              : 'We usually check within a few hours. You\'ll be able to go online once approved.',
          textAlign: TextAlign.center,
          style: AppText.body(14, color: AppColors.textMuted, height: 1.45),
        ),
        const SizedBox(height: 26),
        // UPI can change any time (not while a withdrawal is pending).
        _Checklist(
          s: s,
          editable: const {_Step.upi},
          onEdit: (_) => showChangeUpiSheet(context),
        ),
        const SizedBox(height: 14),
        // PAN stays open after approval: it can be added any time.
        _PanCard(s: s, locked: !approved),
        const Spacer(),
        const SizedBox(height: 20),
        GradientButton(
          gradient: _companion,
          label: 'Back to home',
          onPressed: () => context.go('/companion'),
        ),
        const _PrivacyNote(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
/// Optional: PAN lowers the TDS on withdrawals (20% without it). Folded until
/// tapped so it doesn't look like a required step.
class _PanCard extends ConsumerStatefulWidget {
  const _PanCard({required this.s, required this.locked});
  final KycState s;
  final bool locked;

  @override
  ConsumerState<_PanCard> createState() => _PanCardState();
}

class _PanCardState extends ConsumerState<_PanCard> {
  final _pan = TextEditingController();
  XFile? _panPhoto;
  bool _busy = false;
  late bool _open = widget.s.redo.contains(KycStateRedoEnum.pan);

  @override
  void dispose() {
    _pan.dispose();
    super.dispose();
  }

  bool get _panValid => RegExp(
    r'^[A-Z]{3}P[A-Z][0-9]{4}[A-Z]$',
  ).hasMatch(_pan.text.trim().toUpperCase());

  Future<void> _savePan() async {
    final bytes = await _panPhoto!.readAsBytes();
    if (!mounted) return;
    setState(() => _busy = true);
    final ok = await _run(
      context,
      ref,
      (api) => api.companion.uploadPan(
        UploadPanRequest(
          panNumber: _pan.text.trim().toUpperCase(),
          imageBase64: base64Encode(bytes),
        ),
      ),
      ok: 'PAN saved — lower TDS from your next withdrawal',
    );
    if (mounted) {
      setState(() {
        _busy = false;
        if (ok) {
          _open = false;
          _panPhoto = null;
          _pan.clear();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.s.pan;
    final redo = widget.s.redo.contains(KycStateRedoEnum.pan);
    final accent = p.done ? _green : _amber;
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withValues(alpha: 0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: widget.locked
                  ? null
                  : () => setState(() => _open = !_open),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.16),
                    ),
                    child: Icon(Icons.badge_outlined, size: 20, color: accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'PAN · optional',
                          style: AppText.body(15, weight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          redo
                              ? 'Send your PAN again'
                              : p.done
                              ? '••••${p.last4} on file · lower TDS applies'
                              : 'Without it, 20% TDS on every withdrawal',
                          style: AppText.body(
                            13,
                            color: redo
                                ? const Color(0xFFFDA4AF)
                                : p.done
                                ? _mint
                                : const Color(0xFFFCD34D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!widget.locked)
                    Text(
                      _open ? 'Close' : (p.done ? 'Replace' : 'Add'),
                      style: AppText.body(
                        14,
                        weight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                ],
              ),
            ),
            if (_open && !widget.locked) ...[
              const SizedBox(height: 12),
              Text(
                'Without a PAN, 20% TDS is deducted from every withdrawal (the law for payments without PAN). '
                'Add your PAN to pay the normal, much lower TDS.',
                style: AppText.body(
                  12.5,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pan,
                maxLength: 10,
                textCapitalization: TextCapitalization.characters,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: p.done ? 'New PAN number' : 'PAN number',
                  hintText: 'ABCPE1234F',
                  counterText: '',
                  suffixIcon: _panValid
                      ? const Icon(Icons.check_circle_rounded, color: _green)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      icon: _panPhoto == null
                          ? Icons.photo_camera_outlined
                          : Icons.check_rounded,
                      label: _panPhoto == null
                          ? 'Photo of card'
                          : 'Photo added',
                      onPressed: () async {
                        final f = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          maxWidth: 1600,
                          imageQuality: 80,
                        );
                        if (f != null) setState(() => _panPhoto = f);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GradientButton(
                      gradient: _companion,
                      label: 'Save PAN',
                      loading: _busy,
                      onPressed: !_panValid || _panPhoto == null
                          ? null
                          : _savePan,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
/// Change the payout UPI ID after verification (Earnings → Change, or the
/// UPI row on the status page). The server refuses while a withdrawal is
/// pending, and a change right before a payout is flagged for review.
Future<void> showChangeUpiSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16142C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _ChangeUpiSheet(),
    );

class _ChangeUpiSheet extends ConsumerStatefulWidget {
  const _ChangeUpiSheet();

  @override
  ConsumerState<_ChangeUpiSheet> createState() => _ChangeUpiSheetState();
}

class _ChangeUpiSheetState extends ConsumerState<_ChangeUpiSheet> {
  final _upi = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _upi.dispose();
    super.dispose();
  }

  bool get _valid => RegExp(
    r'^[a-zA-Z0-9.\-_]{2,256}@[a-zA-Z][a-zA-Z0-9.]{1,63}$',
  ).hasMatch(_upi.text.trim());

  Future<void> _save() async {
    setState(() => _busy = true);
    final ok = await _run(
      context,
      ref,
      (api) => api.companion.setUpi(SetUpiRequest(upiId: _upi.text.trim())),
      ok: 'UPI ID changed',
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (ok) {
      ref.invalidate(earningsProvider);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(kycProvider).valueOrNull?.upi.masked;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Change UPI ID', style: AppText.heading(20)),
              const SizedBox(height: 6),
              Text(
                current == null
                    ? 'Your withdrawals go to this UPI ID.'
                    : 'Now paying to $current. Withdrawals after this go to the new ID.',
                style: AppText.body(13.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _upi,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                onChanged: (_) => setState(() {}),
                style: AppText.body(16),
                decoration: InputDecoration(
                  labelText: 'New UPI ID',
                  hintText: 'yourname@okaxis',
                  prefixIcon: const Icon(Icons.alternate_email_rounded),
                  suffixIcon: _valid
                      ? const Icon(Icons.check_circle_rounded, color: _green)
                      : null,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: _amber,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Double-check it — money sent to a wrong UPI ID can\'t be pulled back. '
                      'You can\'t change it while a withdrawal is being paid.',
                      style: AppText.body(
                        12.5,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              GradientButton(
                gradient: _companion,
                label: 'Save UPI ID',
                loading: _busy,
                onPressed: _valid ? _save : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
