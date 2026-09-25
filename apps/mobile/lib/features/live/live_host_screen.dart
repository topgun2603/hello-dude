import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pesu_api/api.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../moderation/nudity_detector.dart';
import '../../widgets/common.dart';
import '../companion/companion_data.dart' show rupees;
import 'live_data.dart';
import 'pk.dart';

/// Companion home → Go live: a title, then the host screen.
Future<void> showGoLiveSheet(BuildContext context, WidgetRef ref) async {
  final join = await showModalBottomSheet<LiveJoin>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF16142C),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _GoLiveSheet(),
  );
  if (join != null && context.mounted)
    await context.push('/live-host', extra: join);
}

class _GoLiveSheet extends ConsumerStatefulWidget {
  const _GoLiveSheet();

  @override
  ConsumerState<_GoLiveSheet> createState() => _GoLiveSheetState();
}

class _GoLiveSheetState extends ConsumerState<_GoLiveSheet> {
  final _title = TextEditingController(text: "Let's talk!");
  bool _starting = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() => _starting = true);
    final api = ref.read(apiProvider);
    try {
      final j = await api.call(
        () => api.lives.startLive(StartLiveRequest(title: _title.text.trim())),
      );
      if (mounted) Navigator.pop(context, j);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(
      20,
      16,
      20,
      20 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const LiveBadge(),
              const SizedBox(width: 10),
              Text('Go live', style: AppText.heading(20)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Viewers get a short free preview, then pay per minute to keep watching. You earn from every paid minute and gift. '
            "You won't get 1:1 calls while you're live. A live with nobody watching for 10 minutes ends on its own. "
            'Keep it friendly — lives are checked for safety.',
            style: AppText.body(
              13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _title,
            maxLength: 60,
            style: AppText.body(15),
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'What will you talk about?',
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE11D48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: _starting || _title.text.trim().length < 3
                  ? null
                  : _start,
              icon: const Icon(Icons.videocam_rounded),
              label: Text(
                _starting ? 'Starting…' : 'Start live',
                style: AppText.heading(16),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// The companion's own live: camera, viewers, earnings, chat and gifts.
class LiveHostScreen extends ConsumerStatefulWidget {
  const LiveHostScreen({super.key, required this.join});
  final LiveJoin join;

  @override
  ConsumerState<LiveHostScreen> createState() => _LiveHostScreenState();
}

class _Line {
  _Line(this.name, this.body, {this.highlight = false});
  final String name, body;
  final bool highlight;
}

class _LiveHostScreenState extends ConsumerState<LiveHostScreen> {
  final _room = Room();
  LocalVideoTrack? _camera;
  bool _mic = true, _front = true, _ended = false, _paused = false;
  int _viewers = 0, _earnedPaise = 0, _paidMinutes = 0;
  final _lines = <_Line>[];
  final _hearts = <int>[];
  int _heartSeq = 0;
  final _input = TextEditingController();
  Timer? _heartbeat, _safety, _clock;
  StreamSubscription<Map<String, dynamic>>? _events;
  final _startedAt = DateTime.now();
  NudityDetector? _detector;
  bool _checking = false;
  int _hits = 0; // flagged frames in a row
  DateTime? _lastSnapshot;
  late final PkController _pk;
  bool _challenging = false;

  String get liveId => widget.join.live.id;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _pk = PkController(api: ref.read(apiProvider), fromLiveId: liveId)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _events = ref.read(realtimeProvider).forLive(liveId).listen(_onEvent);
    _heartbeat = Timer.periodic(const Duration(seconds: 15), (_) => _beat());
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
    _connect();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _heartbeat?.cancel();
    _safety?.cancel();
    _clock?.cancel();
    _events?.cancel();
    _pk.dispose();
    _input.dispose();
    unawaited(_room.disconnect().then((_) => _room.dispose()));
    super.dispose();
  }

  Future<void> _connect() async {
    try {
      await _room.connect(widget.join.liveKitUrl, widget.join.token);
      await _room.localParticipant?.setMicrophoneEnabled(true);
      await _room.localParticipant?.setCameraEnabled(
        true,
        cameraCaptureOptions: const CameraCaptureOptions(
          params: VideoParametersPresets.h480_43,
        ),
      );
      final pub = _room.localParticipant?.videoTrackPublications.firstOrNull;
      if (mounted) setState(() => _camera = pub?.track);
      _startSafety();
    } catch (e) {
      if (mounted)
        showError(context, "Couldn't start the camera. ${friendlyError(e)}");
    }
  }

  /// On-device check of our own camera every 4 s. A flagged frame pauses the
  /// camera for 15 s and goes to the admin moderation queue.
  Future<void> _startSafety() async {
    try {
      _detector = await sharedNudityDetector();
    } catch (_) {
      return;
    }
    _safety = Timer.periodic(const Duration(seconds: 4), (_) => _check());
  }

  Future<void> _check() async {
    final track = _camera, detector = _detector;
    if (track == null || detector == null || _checking || _paused || _ended)
      return;
    _checking = true;
    try {
      final jpeg = (await track.mediaStreamTrack.captureFrame()).asUint8List();
      final score = await detector.score(jpeg);
      if (!mounted) return;
      if (score < 0.7) {
        _hits = 0;
        _maybeSnapshot(jpeg);
        return;
      }
      // One flagged frame is often a misread (blur, lighting): act on two in a row.
      if (++_hits < 2) return;
      _hits = 0;
      setState(() => _paused = true);
      await _room.localParticipant?.setCameraEnabled(false);
      final api = ref.read(apiProvider);
      final small = await compute(shrinkForUpload, jpeg);
      unawaited(
        api
            .call(
              () => api.lives.flagLiveFrame(
                liveId,
                FlagLiveFrameRequest(
                  frameBase64: base64Encode(small),
                  score: score,
                ),
              ),
            )
            .then<void>((_) {}, onError: (_) {}),
      );
      Timer(const Duration(seconds: 15), () async {
        if (!mounted || _ended) return;
        await _room.localParticipant?.setCameraEnabled(true);
        final pub = _room.localParticipant?.videoTrackPublications.firstOrNull;
        if (mounted) {
          setState(() {
            _paused = false;
            _camera = pub?.track;
          });
        }
      });
    } catch (_) {
      /* next check */
    } finally {
      _checking = false;
    }
  }

  /// About once a minute, a checked-clean frame becomes the live's card
  /// picture in the Live tab (the server also limits how often).
  void _maybeSnapshot(Uint8List jpeg) {
    final last = _lastSnapshot;
    if (last != null &&
        DateTime.now().difference(last) < const Duration(seconds: 60))
      return;
    _lastSnapshot = DateTime.now();
    final api = ref.read(apiProvider);
    unawaited(
      compute(shrinkForUpload, jpeg)
          .then(
            (small) => api.send(
              () => api.lives.uploadLiveSnapshot(
                liveId,
                UploadLiveSnapshotRequest(frameBase64: base64Encode(small)),
              ),
            ),
          )
          .then<void>((_) {}, onError: (_) {}),
    );
  }

  Future<void> _beat() async {
    final api = ref.read(apiProvider);
    try {
      final h = await api.call(() => api.lives.liveHostHeartbeat(liveId));
      if (!mounted) return;
      setState(() {
        _viewers = h.viewers;
        _earnedPaise = h.earnedPaise;
        _paidMinutes = h.paidMinutes;
      });
      if (h.status == LiveHostHeartbeat200ResponseStatusEnum.ended)
        _onEnded('This live was ended');
    } catch (_) {
      /* next beat */
    }
  }

  void _onEvent(Map<String, dynamic> e) {
    if (!mounted) return;
    if (_pk.handle(e)) {
      if (e['kind'] == 'pk_ended') _beat();
      return;
    }
    switch (e['kind']) {
      case 'pk_invite':
        _onPkInvite(e['battle']);
      case 'pk_declined':
        setState(() => _challenging = false);
        showError(context, 'She said no to the battle this time.');
      case 'chat':
        _add(_Line('${e['displayName']}', '${e['body']}'));
      case 'gift':
        final g = (e['gift'] as Map?) ?? const {};
        _add(
          _Line(
            '${e['displayName']}',
            'sent ${g['emoji'] ?? '🎁'} ${g['name'] ?? 'a gift'}',
            highlight: true,
          ),
        );
        _beat();
      case 'pass':
        _add(
          _Line(
            '${e['displayName']}',
            'bought ${e['minutes']} min',
            highlight: true,
          ),
        );
        _beat();
      case 'reaction':
        final id = _heartSeq++;
        setState(() => _hearts.add(id));
        Timer(const Duration(milliseconds: 1800), () {
          if (mounted) setState(() => _hearts.remove(id));
        });
      case 'empty_warning':
        showError(
          context,
          "Nobody is watching right now — your live ends in ${e['endsInMinutes'] ?? 5} min unless someone joins.",
        );
      case 'limit_warning':
        showError(
          context,
          'Your live ends in ${e['endsInMinutes'] ?? 5} min (the time limit). Say goodbye to your viewers!',
        );
      case 'viewers':
        setState(() => _viewers = (e['count'] as num?)?.toInt() ?? _viewers);
      case 'ended':
        final reason = e['reason'];
        _onEnded(
          reason == 'admin' ? 'An admin ended this live' : 'Your live ended',
        );
    }
  }

  /// Challenge another live host.
  Future<void> _challenge() async {
    final api = ref.read(apiProvider);
    try {
      final opponent = await pickPkOpponent(context, api, widget.join.live.host.id);
      if (opponent == null || !mounted) return;
      await api.call(() => api.lives.challengePk(liveId, ChallengePkRequest(opponentLiveId: opponent)));
      if (!mounted) return;
      setState(() => _challenging = true);
      showError(context, 'Challenge sent — waiting up to 30 s for her to accept.');
      Timer(const Duration(seconds: 32), () {
        if (mounted && !_pk.active) setState(() => _challenging = false);
      });
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _onPkInvite(dynamic json) async {
    final b = PkBattle.fromJson(json);
    if (b == null || _pk.showing) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        Timer(const Duration(seconds: 28), () {
          if (ctx.mounted) Navigator.maybePop(ctx, false);
        });
        return AlertDialog(
          title: const Text('PK battle? ⚡'),
          content: Text(
            '${b.a.hostName} challenges you to a 5-minute battle. Both lives show side by side; whoever gets more gift coins wins a PK winner badge.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not now')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Accept')),
          ],
        );
      },
    );
    final api = ref.read(apiProvider);
    try {
      if (ok == true) {
        await api.call(() => api.lives.acceptPk(b.id));
      } else {
        await api.call(() => api.lives.declinePk(b.id));
      }
    } catch (e) {
      if (mounted && ok == true) showError(context, friendlyError(e));
    }
  }

  void _add(_Line l) => setState(() {
    _lines.add(l);
    if (_lines.length > 40) _lines.removeAt(0);
  });

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final api = ref.read(apiProvider);
    try {
      await api.send(
        () => api.lives.sendLiveMessage(
          liveId,
          SendRoomMessageRequest(body: text),
        ),
      );
      _input.clear();
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _flip() async {
    final t = _camera;
    if (t == null) return;
    _front = !_front;
    await t.setCameraPosition(
      _front ? CameraPosition.front : CameraPosition.back,
    );
    if (mounted) setState(() {});
  }

  Future<void> _toggleMic() async {
    _mic = !_mic;
    await _room.localParticipant?.setMicrophoneEnabled(_mic);
    if (mounted) setState(() {});
  }

  Future<void> _end() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('End your live?'),
        content: Text(
          'You earned ${rupees(_earnedPaise)} so far ($_paidMinutes paid minutes plus gifts).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Keep going'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('End live'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final api = ref.read(apiProvider);
    await api.send(() => api.lives.endLive(liveId)).catchError((_) {});
    await _beat();
    _onEnded('You ended the live');
  }

  void _onEnded(String title) {
    if (_ended) return;
    _ended = true;
    _safety?.cancel();
    _heartbeat?.cancel();
    unawaited(_room.disconnect());
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(
          'Earned ${rupees(_earnedPaise)} · $_paidMinutes paid minutes · live for ${clockLeft(DateTime.now().difference(_startedAt))}',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              if (mounted) context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cam = _camera;
    return PopScope(
      canPop: _ended,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _end();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_pk.showing)
              const ColoredBox(color: Color(0xFF0A0A18))
            else if (cam != null && !_paused)
              VideoTrackRenderer(
                cam,
                fit: VideoViewFit.cover,
                mirrorMode: _front
                    ? VideoViewMirrorMode.mirror
                    : VideoViewMirrorMode.off,
              )
            else
              const ColoredBox(color: Color(0xFF16142C)),
            if (_paused)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Your camera is paused for a moment — our safety check flagged the picture. Keep it friendly.',
                    textAlign: TextAlign.center,
                    style: AppText.body(15, weight: FontWeight.w700),
                  ),
                ),
              ),
            const IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x99000000),
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                    stops: [0, 0.2, 0.6, 1],
                  ),
                ),
              ),
            ),
            if (_pk.showing)
              Positioned(
                top: MediaQuery.paddingOf(context).top + 58,
                left: 0,
                right: 0,
                child: PkBattleView(
                  pk: _pk,
                  myVideo: cam != null && !_paused
                      ? VideoTrackRenderer(
                          cam,
                          fit: VideoViewFit.cover,
                          mirrorMode: _front ? VideoViewMirrorMode.mirror : VideoViewMirrorMode.off,
                        )
                      : const ColoredBox(color: Color(0xFF16142C)),
                ),
              ),
            for (final id in _hearts)
              FloatingHeart(key: ValueKey(id), seed: id),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
                    child: Row(
                      children: [
                        const LiveBadge(),
                        const SizedBox(width: 8),
                        _Chip(
                          icon: Icons.timer_outlined,
                          text: clockLeft(
                            DateTime.now().difference(_startedAt),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _Chip(
                          icon: Icons.visibility_outlined,
                          text: '$_viewers',
                        ),
                        const SizedBox(width: 6),
                        _Chip(
                          icon: Icons.currency_rupee_rounded,
                          text: rupees(_earnedPaise).replaceAll('₹', ''),
                          accent: true,
                        ),
                        const Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFE11D48),
                          ),
                          onPressed: _ended ? null : _end,
                          child: const Text('End'),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 80, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final l
                              in _lines.length > 7
                                  ? _lines.sublist(_lines.length - 7)
                                  : _lines)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: l.highlight
                                      ? const Color(0x66B45309)
                                      : Colors.black38,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${l.name} ',
                                        style: AppText.body(
                                          13,
                                          weight: FontWeight.w800,
                                          color: const Color(0xFFF9A8D4),
                                        ),
                                      ),
                                      TextSpan(
                                        text: l.body,
                                        style: AppText.body(13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _input,
                            maxLength: 200,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _send(),
                            style: AppText.body(14),
                            decoration: InputDecoration(
                              counterText: '',
                              hintText: 'Say hi to your viewers…',
                              hintStyle: AppText.body(
                                14,
                                color: Colors.white60,
                              ),
                              filled: true,
                              fillColor: Colors.black38,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(999),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _Round(
                          icon: _mic
                              ? Icons.mic_rounded
                              : Icons.mic_off_rounded,
                          label: _mic ? 'Mute' : 'Unmute',
                          onTap: _toggleMic,
                        ),
                        const SizedBox(width: 8),
                        _Round(
                          icon: Icons.bolt_rounded,
                          label: 'PK battle',
                          onTap: _pk.showing || _challenging ? null : _challenge,
                        ),
                        const SizedBox(width: 8),
                        _Round(
                          icon: Icons.cameraswitch_rounded,
                          label: 'Flip camera',
                          onTap: _flip,
                        ),
                      ],
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

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.text, this.accent = false});
  final IconData icon;
  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: accent ? const Color(0x9910B981) : Colors.black38,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 3),
        Text(text, style: AppText.body(12, weight: FontWeight.w700)),
      ],
    ),
  );
}

class _Round extends StatelessWidget {
  const _Round({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onTap != null,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black38,
        ),
        child: Icon(icon, color: onTap == null ? Colors.white38 : Colors.white),
      ),
    ),
  );
}
