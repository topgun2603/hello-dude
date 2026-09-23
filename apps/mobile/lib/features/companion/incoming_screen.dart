import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/push.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../call/start_call.dart';

class IncomingArgs {
  const IncomingArgs({
    required this.callId,
    required this.video,
    required this.callerName,
    required this.callerAvatarId,
    this.autoAccept = false,
  });
  final String callId, callerName;
  final bool video;
  final int callerAvatarId;

  /// Already accepted on the native lock-screen call UI.
  final bool autoAccept;
}

/// Design: Incoming.dc.html — full screen, decline / accept, auto-missed after 45 s.
class IncomingScreen extends ConsumerStatefulWidget {
  const IncomingScreen({super.key, required this.args});
  final IncomingArgs args;

  @override
  ConsumerState<IncomingScreen> createState() => _IncomingScreenState();
}

class _IncomingScreenState extends ConsumerState<IncomingScreen> {
  static const _ringSeconds = 45;
  late final Timer _tick;
  Timer? _buzz;
  StreamSubscription<Map<String, dynamic>>? _events;
  StreamSubscription<CallAction>? _pushActions;
  int _left = _ringSeconds;
  bool _answering = false;

  IncomingArgs get a => widget.args;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_left <= 1) return _close('Missed call from ${a.callerName}');
      setState(() => _left--);
    });
    // Vibrate like a phone call until answered.
    _buzz = Timer.periodic(
      const Duration(milliseconds: 1400),
      (_) => HapticFeedback.heavyImpact(),
    );
    SystemSound.play(SystemSoundType.alert);
    // The caller hung up while ringing.
    _events = ref
        .read(realtimeProvider)
        .forCall(a.callId)
        .where((e) => e['t'] == 'call_ended')
        .listen((_) => _close('${a.callerName} cancelled the call'));
    // Accept / Decline pressed on the native call UI while this screen is open.
    _pushActions = ref
        .read(pushProvider)
        .actions
        .where((x) => x.callId == a.callId)
        .listen(
          (x) => x.kind == CallActionKind.accept ? _accept() : _decline(),
        );
    if (a.autoAccept)
      WidgetsBinding.instance.addPostFrameCallback((_) => _accept());
  }

  @override
  void dispose() {
    _tick.cancel();
    _buzz?.cancel();
    _events?.cancel();
    _pushActions?.cancel();
    // This screen handled the call; the native call UI must not keep ringing.
    dismissIncomingCallUi(a.callId);
    super.dispose();
  }

  void _close(String message) {
    if (!mounted) return;
    _tick.cancel();
    _buzz?.cancel();
    context.pop();
    showError(context, message);
  }

  Future<void> _decline() async {
    _buzz?.cancel();
    final api = ref.read(apiProvider);
    try {
      await api.call(() => api.calls.rejectCall(a.callId));
    } catch (_) {
      /* already over */
    }
    if (mounted) context.pop();
  }

  Future<void> _accept() async {
    if (_answering) return;
    setState(() => _answering = true);
    _buzz?.cancel();
    final api = ref.read(apiProvider);
    try {
      final join = await api.call(() => api.calls.acceptCall(a.callId));
      if (!mounted) return;
      context.pushReplacement(
        '/call',
        extra: CallArgs(
          callId: join.callId,
          liveKitUrl: join.liveKitUrl,
          room: join.room,
          token: join.token,
          coinsPerMin: join.coinsPerMin,
          video: a.video,
          otherName: a.callerName,
          otherAvatarId: a.callerAvatarId,
          subtitle: 'Caller',
          asCompanion: true,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _close(
        errorCode(e) == 'CALL_NOT_RINGING'
            ? 'This call has already ended'
            : friendlyError(e),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GlowBackground(
          child: SafeArea(
            child: FillScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              children: [
                Center(
                  child: Text(
                    'Incoming ${a.video ? 'video' : 'voice'} call',
                    style: AppText.body(
                      15,
                      color: AppColors.textMuted,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: _Pulse(
                    child: Avatar(
                      name: a.callerName,
                      avatarId: a.callerAvatarId,
                      size: 128,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  a.callerName,
                  textAlign: TextAlign.center,
                  style: AppText.heading(32, spacing: -0.6),
                ),
                const SizedBox(height: 6),
                Text(
                  'Someone wants to talk to you',
                  textAlign: TextAlign.center,
                  style: AppText.body(15, color: AppColors.textMuted),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: Color(0xFF6EE7B7),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You can end, report or block anytime. Your number is never shared.',
                          style: AppText.body(
                            13.5,
                            color: AppColors.textMuted,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Round(
                      label: 'Decline',
                      color: AppColors.danger,
                      icon: Icons.call_end_rounded,
                      onTap: _answering ? null : _decline,
                    ),
                    _Round(
                      label: _answering ? 'Connecting…' : 'Accept',
                      color: const Color(0xFF10B981),
                      icon: a.video
                          ? Icons.videocam_rounded
                          : Icons.call_rounded,
                      onTap: _answering ? null : _accept,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Missed automatically in 0:${_left.toString().padLeft(2, '0')}',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Round extends StatelessWidget {
  const _Round({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.45),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 34),
          ),
          const SizedBox(height: 10),
          Text(label, style: AppText.body(14, weight: FontWeight.w600)),
        ],
      ),
    ),
  );
}

class _Pulse extends StatefulWidget {
  const _Pulse({required this.child});
  final Widget child;

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (context, child) => Stack(
      alignment: Alignment.center,
      children: [
        for (final d in [0.0, 0.5])
          Opacity(
            opacity: (1 - ((_c.value + d) % 1)).clamp(0, 1) * 0.6,
            child: Container(
              width: 128 + 90 * ((_c.value + d) % 1),
              height: 128 + 90 * ((_c.value + d) % 1),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF10B981), width: 2),
              ),
            ),
          ),
        child!,
      ],
    ),
    child: widget.child,
  );
}

/// Keeps the name used by the shell's listener in one place.
IncomingArgs incomingFromEvent(Map<String, dynamic> e) {
  final caller = (e['caller'] as Map?) ?? const {};
  return IncomingArgs(
    callId: e['callId'] as String,
    video: e['callType'] == 'video',
    callerName: (caller['displayName'] as String?) ?? 'Caller',
    callerAvatarId: (caller['avatarId'] as int?) ?? 1,
  );
}

/// From the incoming_call push payload (see services/api/src/push.ts).
IncomingArgs incomingFromPush(
  String callId,
  Map<String, dynamic> d, {
  bool autoAccept = false,
}) => IncomingArgs(
  callId: callId,
  video: d['callType'] == 'video',
  callerName: (d['callerName'] as String?) ?? 'Caller',
  callerAvatarId: int.tryParse('${d['callerAvatarId']}') ?? 1,
  autoAccept: autoAccept,
);
