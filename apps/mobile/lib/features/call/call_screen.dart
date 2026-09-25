import 'dart:async';
import 'dart:convert';
import 'dart:ui' show ImageFilter;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../moderation/nudity_detector.dart';
import '../../moderation/video_moderator.dart';
import '../../widgets/common.dart';
import '../home/buy_coins.dart' show showBuyCoinsSheet;
import '../home/home_data.dart';
import '../companion/companion_data.dart';
import 'gift_sheet.dart';
import 'start_call.dart';

enum _Phase { ringing, connecting, live, ended }

/// Design: InCall.dc.html. The caller joins the LiveKit room straight away;
/// billing starts when the server says both sides joined (call_connected).
class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key, required this.args});
  final CallArgs args;

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  static const _ringTimeout = Duration(seconds: 45);

  final _room = Room(
    roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
  );
  EventsListener<RoomEvent>? _roomEvents;
  StreamSubscription<Map<String, dynamic>>? _serverEvents;
  Timer? _ringTimer, _tick;
  final _clock = Stopwatch();

  late _Phase _phase = a.asCompanion ? _Phase.connecting : _Phase.ringing;
  bool _muted = false, _speaker = true, _camera = false;
  bool _lowBalance = false;
  int? _balance;
  VideoTrack? _remoteVideo;
  VideoModerator? _moderator;
  (String, String)? _giftFlash; // emoji, caption
  Timer? _giftTimer;

  void _showGift(String emoji, String caption) {
    _giftTimer?.cancel();
    setState(() => _giftFlash = (emoji, caption));
    _giftTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _giftFlash = null);
    });
  }

  CallArgs get a => widget.args;

  @override
  void initState() {
    super.initState();
    _camera = a.video;
    _serverEvents = ref
        .read(realtimeProvider)
        .forCall(a.callId)
        .listen(_onServerEvent);
    if (!a.asCompanion) {
      _ringTimer = Timer(_ringTimeout, () => _hangUp(reason: 'timeout'));
    }
    _join();
  }

  Future<void> _join() async {
    _roomEvents = _room.createListener()
      ..on<ParticipantConnectedEvent>((_) => _verifyConnected())
      ..on<TrackSubscribedEvent>((e) {
        _verifyConnected();
        if (e.track is VideoTrack) {
          setState(() => _remoteVideo = e.track as VideoTrack);
        }
      })
      ..on<TrackUnsubscribedEvent>((e) {
        if (e.track == _remoteVideo) setState(() => _remoteVideo = null);
      })
      ..on<RoomDisconnectedEvent>((_) {
        if (_phase != _Phase.ended) _hangUp(reason: 'network');
      })
      // The other phone left the room (hung up, lost network or the app died):
      // end the call now so billing stops and the companion is free again,
      // instead of waiting ~30-50 s for the server's sweeper to notice.
      ..on<ParticipantDisconnectedEvent>((_) {
        if (_phase == _Phase.live) _hangUp(reason: 'other_left');
      });
    try {
      await _room.connect(a.liveKitUrl, a.token);
      await _room.localParticipant?.setMicrophoneEnabled(true);
      if (a.video) {
        await _room.localParticipant?.setCameraEnabled(
          true,
          cameraCaptureOptions: const CameraCaptureOptions(
            params: VideoParametersPresets.h480_43,
          ),
        );
        unawaited(_startModeration());
      }
      await AudioManager.instance.setSpeakerOutputPreferred(_speaker);
    } catch (e) {
      if (mounted)
        showError(context, "Couldn't connect the call. ${friendlyError(e)}");
      await _hangUp(reason: 'network');
    }
  }

  /// On-device nudity check of this phone's OWN camera (see lib/moderation), like
  /// lives and groups. Silent in 1:1 calls: nothing changes on screen; flagged
  /// frames go to the admin Moderation queue (the companion also has report,
  /// block and recording).
  ///
  /// Never grab frames of the other person's video: for a remote track
  /// flutter_webrtc calls PeerConnection.getTransceivers(), which disposes the
  /// transceivers LiveKit is still using and crashes the app mid-call (native
  /// abort / null pointer in RtpSender.dispose). Local tracks don't go that way.
  Future<void> _startModeration() async {
    if (!a.video || _moderator != null) return;
    final NudityDetector detector;
    try {
      detector = await sharedNudityDetector();
    } catch (e) {
      debugPrint('nudity model failed to load: $e');
      return;
    }
    if (!mounted || _phase == _Phase.ended || _moderator != null) return;
    final api = ref.read(apiProvider);
    _moderator =
        VideoModerator(
            detector: detector,
            silent: true,
            capture: () async {
              if (!_camera) return null;
              final track = _room
                  .localParticipant
                  ?.videoTrackPublications
                  .firstOrNull
                  ?.track;
              if (track == null) return null;
              final frame = await track.mediaStreamTrack.captureFrame();
              return frame.asUint8List();
            },
            report: (jpeg, score) async {
              final small = await compute(shrinkForUpload, jpeg);
              await api.call(
                () => api.calls.flagVideoFrame(
                  a.callId,
                  FlagVideoFrameRequest(
                    frameBase64: base64Encode(small),
                    score: score,
                    own: true,
                  ),
                ),
              );
            },
          )
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..start();
  }

  /// LiveKit Cloud can't reach the API with webhooks, so the app nudges the
  /// server when it sees the other person; the server checks with LiveKit itself
  /// before any billing starts. Retries a few times while the call connects.
  bool _verifying = false;
  Future<void> _verifyConnected() async {
    if (_verifying || _phase == _Phase.live || _phase == _Phase.ended) return;
    _verifying = true;
    final api = ref.read(apiProvider);
    try {
      for (
        var i = 0;
        i < 5 && mounted && _phase != _Phase.live && _phase != _Phase.ended;
        i++
      ) {
        final r = await api.call(() => api.calls.verifyCallConnected(a.callId));
        if (r.connected) break;
        await Future<void>.delayed(const Duration(seconds: 2));
      }
    } catch (_) {
      /* the sweep catches up */
    } finally {
      _verifying = false;
    }
  }

  void _onServerEvent(Map<String, dynamic> e) {
    switch (e['t']) {
      case 'call_accepted':
        setState(() => _phase = _Phase.connecting);
      case 'call_connected':
        _ringTimer?.cancel();
        _clock.start();
        _tick = Timer.periodic(
          const Duration(seconds: 1),
          (_) => setState(() {}),
        );
        setState(() {
          _phase = _Phase.live;
          _balance = e['balanceAfterFirstMinute'] as int?;
          _lowBalance = _balance != null && _balance! < a.coinsPerMin;
        });
      case 'low_balance':
        setState(() => _lowBalance = true);
      case 'gift_received':
        final gift = (e['gift'] as Map?) ?? const {};
        final paise = (e['paiseEarned'] as int?) ?? 0;
        _showGift(
          gift['emoji'] as String? ?? '🎁',
          '${a.otherName} sent a ${gift['name'] ?? 'gift'} · +₹${(paise / 100).toStringAsFixed(paise % 100 == 0 ? 0 : 2)}',
        );
      case 'call_ended':
        _finish(e['reason'] as String? ?? 'ended');
    }
  }

  Future<void> _hangUp({String reason = 'caller_hangup'}) async {
    if (_phase == _Phase.ended) return;
    final api = ref.read(apiProvider);
    try {
      await api.call(() => api.calls.endCall(a.callId));
    } catch (_) {
      /* the server's sweeper closes it anyway */
    }
    _finish(reason);
  }

  void _finish(String reason) {
    if (_phase == _Phase.ended || !mounted) return;
    final wasLive = _phase == _Phase.live;
    setState(() => _phase = _Phase.ended);
    _cleanup();
    ref.invalidate(walletProvider);
    ref.invalidate(callHistoryProvider);
    if (a.asCompanion) {
      ref.invalidate(companionHomeProvider);
      ref.invalidate(earningsProvider);
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            wasLive
                ? 'Call with ${a.otherName} ended · ${_format(_clock.elapsed)}'
                : 'Call ended before it connected',
          ),
        ),
      );
      return;
    }
    if (wasLive) {
      context.pushReplacement('/rate', extra: a);
    } else {
      context.pop();
      final msg = switch (reason) {
        'companion_reject' =>
          '${a.otherName} is busy right now. Try again in a bit.',
        'timeout' ||
        'missed' => "${a.otherName} didn't pick up. You weren't charged.",
        'balance' => 'Not enough coins to start the call.',
        'network' =>
          'The call dropped before it connected. You weren\'t charged.',
        _ => 'Call cancelled. You weren\'t charged.',
      };
      showError(context, msg);
    }
  }

  void _cleanup() {
    _moderator?.dispose();
    _moderator = null;
    _ringTimer?.cancel();
    _tick?.cancel();
    _giftTimer?.cancel();
    _clock.stop();
    _serverEvents?.cancel();
    _roomEvents?.dispose();
    _room.disconnect();
  }

  @override
  void dispose() {
    _cleanup();
    _room.dispose();
    super.dispose();
  }

  Future<void> _report() async {
    final choice =
        await showModalBottomSheet<(ReportUserRequestReasonEnum, bool, String)>(
          context: context,
          isScrollControlled: true,
          backgroundColor: const Color(0xFF16142C),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (context) =>
              _ReportSheet(name: a.otherName, live: _phase == _Phase.live),
        );
    if (choice == null || !mounted) return;
    final (reason, alsoBlock, details) = choice;
    final api = ref.read(apiProvider);
    try {
      final call = await api.call(() => api.calls.getCall(a.callId));
      await api.call(
        () => api.safety.reportUser(
          ReportUserRequest(
            userId: call.other.id,
            callId: a.callId,
            reason: reason,
            alsoBlock: alsoBlock,
            details: details.isEmpty ? null : details,
          ),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanks. We will review this report.')),
        );
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
    await _hangUp();
  }

  String get _status => switch (_phase) {
    _Phase.ringing => 'Ringing…',
    _Phase.connecting => 'Connecting…',
    _Phase.live => _format(_clock.elapsed),
    _Phase.ended => 'Call ended',
  };

  static String _format(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final showVideo = a.video && _remoteVideo != null;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final end = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF16142C),
            title: const Text('End this call?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Keep talking'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'End call',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ],
          ),
        );
        if (end == true) _hangUp();
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (showVideo)
              Positioned.fill(
                child: _moderator?.hidden == true
                    ? _HiddenVideo(track: _remoteVideo!, onReport: _report)
                    : VideoTrackRenderer(
                        _remoteVideo!,
                        fit: VideoViewFit.cover,
                      ),
              )
            else
              const Positioned.fill(
                child: GlowBackground(child: SizedBox.expand()),
              ),
            if (_giftFlash != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      key: ValueKey(_giftFlash),
                      tween: Tween(begin: 0.4, end: 1),
                      duration: const Duration(milliseconds: 450),
                      curve: Curves.elasticOut,
                      builder: (context, s, child) =>
                          Transform.scale(scale: s, child: child),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _giftFlash!.$1,
                            style: const TextStyle(fontSize: 96),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _giftFlash!.$2,
                              style: AppText.body(15, weight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: FillScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 46),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 15,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Private ${a.video ? 'video' : 'voice'} call',
                            style: AppText.body(
                              13.5,
                              color: AppColors.textMuted,
                              weight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      CircleIconButton(
                        icon: Icons.flag_outlined,
                        tooltip: 'Report or block',
                        onPressed: _report,
                      ),
                    ],
                  ),
                  if (!showVideo) ...[
                    const SizedBox(height: 40),
                    _PulsingAvatar(
                      name: a.otherName,
                      avatarId: a.otherAvatarId,
                      active: _phase != _Phase.live,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      a.otherName,
                      textAlign: TextAlign.center,
                      style: AppText.heading(28, spacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      a.subtitle,
                      textAlign: TextAlign.center,
                      style: AppText.body(14, color: AppColors.textMuted),
                    ),
                  ] else
                    const SizedBox(height: 12),
                  const SizedBox(height: 14),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _status,
                        style: AppText.body(18, weight: FontWeight.w700)
                            .copyWith(
                              letterSpacing: 1,
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    ),
                  ),
                  if (_phase != _Phase.live && _phase != _Phase.ended) ...[
                    const SizedBox(height: 10),
                    Text(
                      a.video
                          ? 'Video is checked on your phone for nudity. If you report, the last few minutes of audio are kept for review.'
                          : 'If you report this call, the last few minutes of audio are kept for review.',
                      textAlign: TextAlign.center,
                      style: AppText.body(12, color: AppColors.hint),
                    ),
                  ],
                  if (_phase == _Phase.live && !a.asCompanion) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${a.coinsPerMin} coins / min',
                      textAlign: TextAlign.center,
                      style: AppText.body(12.5, color: AppColors.textSecondary),
                    ),
                  ],
                  const Spacer(),
                  if (a.video && _camera && _room.localParticipant != null)
                    _LocalPreview(participant: _room.localParticipant!),
                  if (_lowBalance && !a.asCompanion) ...[
                    const SizedBox(height: 12),
                    _LowBalanceBanner(coins: _balance),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: _Control(
                          icon: _muted
                              ? Icons.mic_off_rounded
                              : Icons.mic_none_rounded,
                          label: _muted ? 'Muted' : 'Mute',
                          on: _muted,
                          onTap: () async {
                            setState(() => _muted = !_muted);
                            await _room.localParticipant?.setMicrophoneEnabled(
                              !_muted,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _Control(
                          icon: Icons.volume_up_rounded,
                          label: 'Speaker',
                          on: _speaker,
                          onTap: () async {
                            setState(() => _speaker = !_speaker);
                            await AudioManager.instance
                                .setSpeakerOutputPreferred(_speaker);
                          },
                        ),
                      ),
                      if (!a.asCompanion)
                        Expanded(
                          child: _Control(
                            icon: Icons.card_giftcard_rounded,
                            label: 'Gift',
                            on: false,
                            onTap: _phase == _Phase.live
                                ? () async {
                                    final g = await showGiftSheet(
                                      context,
                                      callId: a.callId,
                                      toName: a.otherName,
                                    );
                                    if (g != null)
                                      _showGift(
                                        g.emoji,
                                        'You sent a ${g.name}',
                                      );
                                  }
                                : null,
                          ),
                        ),
                      Expanded(
                        child: _Control(
                          icon: _camera
                              ? Icons.videocam_rounded
                              : Icons.videocam_off_outlined,
                          label: _camera ? 'Video on' : 'Video',
                          on: _camera,
                          onTap: a.video
                              ? () async {
                                  setState(() => _camera = !_camera);
                                  await _room.localParticipant
                                      ?.setCameraEnabled(_camera);
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Center(
                    child: Semantics(
                      button: true,
                      label: 'End call',
                      child: GestureDetector(
                        onTap: () => _hangUp(),
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFB7185), Color(0xFFE11D48)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x66E11D48),
                                blurRadius: 24,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.call_end_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingAvatar extends StatefulWidget {
  const _PulsingAvatar({
    required this.name,
    required this.avatarId,
    required this.active,
  });
  final String name;
  final int avatarId;
  final bool active;

  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 230,
    child: AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = widget.active ? _c.value : 0.5;
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 208 + 20 * t,
              height: 208 + 20 * t,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x2EF472B6)),
              ),
            ),
            Container(
              width: 180 + 10 * t,
              height: 180 + 10 * t,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x4DF472B6), width: 1.5),
              ),
            ),
            Container(
              width: 154,
              height: 154,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0x29EC4899),
              ),
            ),
            child!,
          ],
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.85),
            width: 3,
          ),
        ),
        child: Avatar(name: widget.name, avatarId: widget.avatarId, size: 118),
      ),
    ),
  );
}

class _LocalPreview extends StatelessWidget {
  const _LocalPreview({required this.participant});
  final LocalParticipant participant;

  @override
  Widget build(BuildContext context) {
    final pub = participant.videoTrackPublications.firstOrNull;
    final track = pub?.track;
    if (track == null) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerRight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 110,
          height: 160,
          child: VideoTrackRenderer(track, fit: VideoViewFit.cover),
        ),
      ),
    );
  }
}

class _LowBalanceBanner extends StatelessWidget {
  const _LowBalanceBanner({required this.coins});
  final int? coins;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
    decoration: BoxDecoration(
      color: const Color(0x24F59E0B),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0x73FBBF24)),
    ),
    child: Row(
      children: [
        const Icon(Icons.timer_outlined, color: Color(0xFFFBBF24)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About 1 min left',
                style: AppText.body(14, weight: FontWeight.w700),
              ),
              Text(
                'Add coins to keep talking.',
                style: AppText.body(12.5, color: const Color(0xFFFDE68A)),
              ),
            ],
          ),
        ),
        Material(
          color: const Color(0xFFFBBF24),
          shape: const StadiumBorder(),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: () => showBuyCoinsSheet(context),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Text(
                'Add coins',
                style: AppText.body(
                  14,
                  color: const Color(0xFF1C1917),
                  weight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _Control extends StatelessWidget {
  const _Control({
    required this.icon,
    required this.label,
    required this.on,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool on;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    toggled: on,
    enabled: onTap != null,
    child: GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap == null ? 0.4 : 1,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: on ? Colors.white : Colors.white.withValues(alpha: 0.1),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Icon(
                icon,
                color: on ? const Color(0xFF6D28D9) : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(label, style: AppText.body(13, weight: FontWeight.w600)),
          ],
        ),
      ),
    ),
  );
}

/// Design: Report.dc.html — reason, details, "Also block", recording notice.
class _ReportSheet extends StatefulWidget {
  const _ReportSheet({required this.name, required this.live});
  final String name;
  final bool live;

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  ReportUserRequestReasonEnum? _reason;
  bool _block = true;
  final _details = TextEditingController();

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Report ${widget.name}', style: AppText.heading(20)),
          const SizedBox(height: 4),
          Text(
            'What happened? Only our safety team sees this.',
            style: AppText.body(13.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          RadioGroup<ReportUserRequestReasonEnum>(
            groupValue: _reason,
            onChanged: (v) => setState(() => _reason = v),
            child: Column(
              children: [
                for (final (r, label) in const [
                  (
                    ReportUserRequestReasonEnum.sexualContent,
                    'Sexual or explicit content',
                  ),
                  (
                    ReportUserRequestReasonEnum.abuse,
                    'Abusive or threatening language',
                  ),
                  (
                    ReportUserRequestReasonEnum.offPlatform,
                    'Asked for my number / to pay outside the app',
                  ),
                  (ReportUserRequestReasonEnum.fraud, 'Asking for money'),
                  (ReportUserRequestReasonEnum.underage, 'Seems under 18'),
                  (ReportUserRequestReasonEnum.other, 'Something else'),
                ])
                  RadioListTile<ReportUserRequestReasonEnum>(
                    value: r,
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    activeColor: AppColors.pink,
                    title: Text(label),
                  ),
              ],
            ),
          ),
          TextField(
            controller: _details,
            maxLength: 500,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Tell us more (optional)',
            ),
          ),
          SwitchListTile(
            value: _block,
            onChanged: (v) => setState(() => _block = v),
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppColors.pink,
            title: Text('Also block ${widget.name}'),
          ),
          if (widget.live)
            Text(
              "We keep this call's audio from now for review. It's deleted once the report is closed.",
              style: AppText.body(
                12.5,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          const SizedBox(height: 14),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.danger,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: _reason == null
                ? null
                : () => Navigator.pop(context, (
                    _reason!,
                    _block,
                    _details.text.trim(),
                  )),
            child: Text(
              widget.live ? 'Report and end call' : 'Report',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    ),
  );
}

/// The other person's video, blurred because the on-device check found nudity.
class _HiddenVideo extends StatelessWidget {
  const _HiddenVideo({required this.track, required this.onReport});
  final VideoTrack track;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 40,
            sigmaY: 40,
            tileMode: TileMode.decal,
          ),
          child: VideoTrackRenderer(track, fit: VideoViewFit.cover),
        ),
        const ColoredBox(color: Color(0xB30A0A18)),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.shield_outlined,
                  size: 48,
                  color: AppColors.pinkSoft,
                ),
                const SizedBox(height: 12),
                Text(
                  'Video hidden for your safety',
                  textAlign: TextAlign.center,
                  style: AppText.heading(20),
                ),
                const SizedBox(height: 6),
                Text(
                  'It may show nudity, which is not allowed. Our safety team has been sent one frame to review. You can keep talking, or report and end the call.',
                  textAlign: TextAlign.center,
                  style: AppText.body(14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.danger,
                  ),
                  onPressed: onReport,
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Report & end call'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
