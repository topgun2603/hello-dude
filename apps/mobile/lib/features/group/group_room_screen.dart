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
import '../../data/ids.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../moderation/nudity_detector.dart';
import '../../widgets/common.dart';
import '../call/gift_sheet.dart' show giftsProvider;
import '../companion/companion_data.dart' show rupees;
import '../home/home_data.dart' show walletProvider;
import '../live/live_data.dart' show FloatingHeart, clockLeft;
import 'group_data.dart';

enum _Phase { loading, consent, lobby, live, ended }

class _Line {
  _Line(this.name, this.body, {this.highlight = false});
  final String name, body;
  final bool highlight;
}

/// One group video, for a member ([isHost] false) or its companion host.
///
/// Members agree to the price and to being on camera, wait in the lobby (free),
/// then everyone is on camera once enough people are in. The server charges each
/// minute; the app only shows the meter. Every phone checks its own camera on
/// device and pauses it on a flagged frame.
class GroupRoomScreen extends ConsumerStatefulWidget {
  const GroupRoomScreen({
    super.key,
    required this.groupId,
    this.isHost = false,
  });
  final String groupId;
  final bool isHost;

  @override
  ConsumerState<GroupRoomScreen> createState() => _GroupRoomScreenState();
}

class _GroupRoomScreenState extends ConsumerState<GroupRoomScreen> {
  _Phase _phase = _Phase.loading;
  GroupCard? _card;
  Room? _room;
  EventsListener<RoomEvent>? _roomEvents;
  LocalVideoTrack? _camera;
  bool _mic = true, _cam = true, _front = true, _paused = false, _busy = false;
  bool _noCoins = false, _lowBalance = false;
  int _minutes = 0, _waiting = 0, _earnedPaise = 0, _paidMinutes = 0;
  int? _coinsLeft;
  String? _endedText;
  DateTime? _liveSince;
  final _lines = <_Line>[];
  final _hearts = <int>[];
  int _heartSeq = 0;
  final _input = TextEditingController();
  Timer? _heartbeat, _safety, _clock;
  StreamSubscription<Map<String, dynamic>>? _events;
  NudityDetector? _detector;
  bool _checking = false;
  int _hits = 0; // flagged frames in a row
  String? _speakerId;

  String get groupId => widget.groupId;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _events = ref.read(realtimeProvider).forGroup(groupId).listen(_onEvent);
    _clock = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _phase == _Phase.live) setState(() {});
    });
    _load();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _heartbeat?.cancel();
    _safety?.cancel();
    _clock?.cancel();
    _events?.cancel();
    _input.dispose();
    _roomEvents?.dispose();
    final r = _room;
    if (r != null) unawaited(r.disconnect().then((_) => r.dispose()));
    super.dispose();
  }

  // --- state from the server ------------------------------------------------------

  Future<void> _load() async {
    final api = ref.read(apiProvider);
    try {
      if (widget.isHost) {
        _applyHost(
          await api.call(() => api.groups.groupHostHeartbeat(groupId)),
        );
        _heartbeat = Timer.periodic(
          const Duration(seconds: 15),
          (_) => _beat(),
        );
        return;
      }
      final groups = await api.call(() => api.groups.listGroups());
      final g = groups.groups.where((x) => x.id == groupId).firstOrNull;
      if (g == null) return _end('This group has ended');
      setState(() => _card = g);
      if (g.mySeat == GroupCardMySeatEnum.joined) {
        await _join(agree: true);
      } else {
        setState(() => _phase = _Phase.consent);
      }
    } catch (e) {
      if (mounted) _end(friendlyError(e));
    }
  }

  void _applyHost(GroupHostState s) {
    if (!mounted) return;
    setState(() {
      _card = s.group;
      _waiting = s.waiting;
      _earnedPaise = s.earnedPaise;
      _paidMinutes = s.paidMinutes;
    });
    if (s.group.status == GroupCardStatusEnum.ended)
      return _end('This group has ended');
    if (s.room != null && _room == null) unawaited(_connect(s.room!));
    if (s.group.status == GroupCardStatusEnum.live) {
      _liveSince ??= s.group.startedAt ?? DateTime.now();
      if (_phase != _Phase.live) setState(() => _phase = _Phase.live);
    } else if (_phase != _Phase.lobby && _phase != _Phase.live) {
      setState(() => _phase = _Phase.lobby);
    }
  }

  Future<void> _join({required bool agree}) async {
    final api = ref.read(apiProvider);
    setState(() => _busy = true);
    try {
      final j = await api.call(
        () => api.groups.joinGroup(groupId, JoinGroupRequest(agree: agree)),
      );
      if (!mounted) return;
      ref.invalidate(walletProvider);
      setState(() {
        _card = j.group;
        _minutes = j.minutes;
        _coinsLeft = j.coinsLeft;
        _noCoins = false;
      });
      _heartbeat ??= Timer.periodic(
        const Duration(seconds: 20),
        (_) => _beat(),
      );
      if (j.room != null) {
        _liveSince ??= j.group.startedAt ?? DateTime.now();
        setState(() => _phase = _Phase.live);
        if (_room == null) await _connect(j.room!);
      } else {
        setState(() => _phase = _Phase.lobby);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      final code = errorCode(e);
      if (code == 'INSUFFICIENT_BALANCE') {
        setState(() {
          _noCoins = true;
          _phase = _Phase.consent;
        });
      } else if (code == 'GROUP_ENDED') {
        _end('This group has ended');
      } else {
        showError(context, friendlyError(e));
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _beat() async {
    final api = ref.read(apiProvider);
    try {
      if (widget.isHost) {
        _applyHost(
          await api.call(() => api.groups.groupHostHeartbeat(groupId)),
        );
        return;
      }
      final h = await api.call(() => api.groups.groupHeartbeat(groupId));
      if (!mounted) return;
      setState(() {
        _card = h.group;
        _minutes = h.minutes;
      });
      if (h.group.status == GroupCardStatusEnum.ended)
        return _end('This group has ended');
      if (h.group.status == GroupCardStatusEnum.live &&
          _room == null &&
          _phase == _Phase.lobby) {
        await _join(agree: true);
      }
    } catch (_) {
      /* next beat */
    }
  }

  void _onEvent(Map<String, dynamic> e) {
    if (!mounted) return;
    switch (e['kind']) {
      case 'waiting':
        setState(() => _waiting = (e['count'] as num?)?.toInt() ?? _waiting);
      case 'started':
        if (widget.isHost) {
          _beat();
        } else if (_room == null) {
          _join(agree: true);
        }
      case 'charged':
        setState(() {
          _minutes = (e['minute'] as num?)?.toInt() ?? _minutes + 1;
          _coinsLeft = (e['coinsLeft'] as num?)?.toInt() ?? _coinsLeft;
        });
      case 'low_balance':
        setState(() => _lowBalance = true);
      case 'removed':
        _end(
          e['state'] == 'no_coins'
              ? "You're out of coins, so you left the group. Add coins to join again."
              : 'The host removed you from this group',
        );
      case 'few_warning':
        showError(
          context,
          'Too few people left — the group ends in ${e['endsInSeconds'] ?? 60} s unless someone joins.',
        );
      case 'joined':
        _add(_Line('${e['displayName']}', 'joined', highlight: true));
        if (widget.isHost) _beat();
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
        if (widget.isHost) _beat();
      case 'reaction':
        final id = _heartSeq++;
        setState(() => _hearts.add(id));
        Timer(const Duration(milliseconds: 1800), () {
          if (mounted) setState(() => _hearts.remove(id));
        });
      case 'ended':
        _end(switch (e['reason']) {
          'too_few' => 'The group ended — too few people were left',
          'not_enough_members' =>
            "Not enough people joined, so the group didn't start. You weren't charged.",
          'time_limit' => 'The group reached its time limit',
          'admin' => 'This group was ended by the safety team',
          'host_lost' => 'The host left, so the group ended',
          _ => 'The group has ended',
        });
    }
  }

  void _add(_Line l) => setState(() {
    _lines.add(l);
    if (_lines.length > 40) _lines.removeAt(0);
  });

  // --- LiveKit --------------------------------------------------------------------

  Future<void> _connect(GroupRoom info) async {
    // Adaptive stream + dynacast: small tiles get low simulcast layers, and
    // layers nobody watches aren't sent — keeps a 10-person grid affordable.
    final room = Room(
      roomOptions: RoomOptions(
        adaptiveStream: true,
        dynacast: true,
        defaultCameraCaptureOptions: CameraCaptureOptions(
          params: widget.isHost
              ? VideoParametersPresets.h480_43
              : VideoParametersPresets.h360_43,
        ),
        defaultVideoPublishOptions: const VideoPublishOptions(simulcast: true),
      ),
    );
    _room = room;
    _roomEvents = room.createListener()
      ..on<ActiveSpeakersChangedEvent>((e) {
        final top = e.speakers.where((p) => p is RemoteParticipant).firstOrNull;
        if (top != null && mounted) setState(() => _speakerId = top.identity);
      })
      ..on<ParticipantConnectedEvent>((_) => mounted ? setState(() {}) : null)
      ..on<ParticipantDisconnectedEvent>(
        (_) => mounted ? setState(() {}) : null,
      )
      ..on<TrackSubscribedEvent>((_) => mounted ? setState(() {}) : null)
      ..on<TrackUnsubscribedEvent>((_) => mounted ? setState(() {}) : null)
      ..on<TrackMutedEvent>((_) => mounted ? setState(() {}) : null)
      ..on<TrackUnmutedEvent>((_) => mounted ? setState(() {}) : null)
      ..on<RoomDisconnectedEvent>((_) {
        if (mounted && _phase != _Phase.ended) setState(() {});
      });
    try {
      await room.connect(info.liveKitUrl, info.token);
      await room.localParticipant?.setMicrophoneEnabled(true);
      await room.localParticipant?.setCameraEnabled(true);
      final pub = room.localParticipant?.videoTrackPublications.firstOrNull;
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
    if (track == null ||
        detector == null ||
        _checking ||
        _paused ||
        !_cam ||
        _phase == _Phase.ended)
      return;
    _checking = true;
    try {
      final jpeg = (await track.mediaStreamTrack.captureFrame()).asUint8List();
      final score = await detector.score(jpeg);
      if (!mounted) return;
      if (score < 0.7) {
        _hits = 0;
        return;
      }
      // One flagged frame is often a misread (blur, lighting): act on two in a row.
      if (++_hits < 2) return;
      _hits = 0;
      setState(() => _paused = true);
      await _room?.localParticipant?.setCameraEnabled(false);
      final api = ref.read(apiProvider);
      final small = await compute(shrinkForUpload, jpeg);
      unawaited(
        api
            .call(
              () => api.groups.flagGroupFrame(
                groupId,
                FlagGroupFrameRequest(
                  frameBase64: base64Encode(small),
                  score: score,
                ),
              ),
            )
            .then<void>((_) {}, onError: (_) {}),
      );
      Timer(const Duration(seconds: 15), () async {
        if (!mounted || _phase == _Phase.ended) return;
        if (_cam) await _room?.localParticipant?.setCameraEnabled(true);
        final pub = _room?.localParticipant?.videoTrackPublications.firstOrNull;
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

  Future<void> _toggleMic() async {
    _mic = !_mic;
    await _room?.localParticipant?.setMicrophoneEnabled(_mic);
    if (mounted) setState(() {});
  }

  Future<void> _toggleCam() async {
    if (_paused) return;
    _cam = !_cam;
    await _room?.localParticipant?.setCameraEnabled(_cam);
    final pub = _room?.localParticipant?.videoTrackPublications.firstOrNull;
    if (mounted) setState(() => _camera = pub?.track);
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

  // --- actions ---------------------------------------------------------------------

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final api = ref.read(apiProvider);
    try {
      await api.send(
        () => api.groups.sendGroupMessage(
          groupId,
          SendRoomMessageRequest(body: text),
        ),
      );
      _input.clear();
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _heart() async {
    final api = ref.read(apiProvider);
    await api
        .send(
          () => api.groups.sendGroupReaction(
            groupId,
            SendRoomReactionRequest(emoji: '❤️'),
          ),
        )
        .catchError((_) {});
  }

  Future<void> _gift() async {
    final gifts = await ref.read(giftsProvider.future);
    if (!mounted) return;
    final host = _card?.host.displayName ?? 'the host';
    final picked = await showModalBottomSheet<Gift>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Send $host a gift', style: AppText.heading(18)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final g in gifts)
                    InkWell(
                      onTap: () => Navigator.pop(ctx, g),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 78,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(g.emoji, style: const TextStyle(fontSize: 26)),
                            Text(g.name, style: AppText.body(12)),
                            Text(
                              '${g.coins}',
                              style: AppText.body(
                                11.5,
                                color: const Color(0xFFFCD34D),
                                weight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (picked == null || !mounted) return;
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(
        () => api.groups.sendGroupGift(
          groupId,
          SendGiftRequest(giftId: picked.id, clientRef: uuidV4()),
        ),
      );
      if (mounted) setState(() => _coinsLeft = r.coinsLeft);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  /// Long-press a tile: report / block / (host) remove.
  Future<void> _personMenu(Participant p) async {
    final name = p.name.isNotEmpty ? p.name : 'this person';
    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: AppColors.danger),
              title: Text('Report $name'),
              onTap: () => Navigator.pop(ctx, 'report'),
            ),
            if (widget.isHost)
              ListTile(
                leading: const Icon(
                  Icons.person_remove_outlined,
                  color: AppColors.danger,
                ),
                title: Text('Report and remove $name'),
                onTap: () => Navigator.pop(ctx, 'remove'),
              ),
            ListTile(
              leading: const Icon(Icons.block_rounded),
              title: Text('Block $name'),
              subtitle: const Text("You won't see each other again"),
              onTap: () => Navigator.pop(ctx, 'block'),
            ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;
    final api = ref.read(apiProvider);
    try {
      if (action == 'block') {
        await api.send(
          () => api.safety.blockUser(BlockUserRequest(userId: p.identity)),
        );
        if (mounted) groupSnack(context, 'Blocked $name');
        return;
      }
      final reason = await showModalBottomSheet<ReportInGroupRequestReasonEnum>(
        context: context,
        backgroundColor: const Color(0xFF16142C),
        builder: (ctx) => SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final (r, label) in const [
                (
                  ReportInGroupRequestReasonEnum.sexualContent,
                  'Nudity or sexual content',
                ),
                (ReportInGroupRequestReasonEnum.abuse, 'Abuse or harassment'),
                (ReportInGroupRequestReasonEnum.underage, 'Looks under 18'),
                (
                  ReportInGroupRequestReasonEnum.offPlatform,
                  'Asked for my number / to pay outside the app',
                ),
                (ReportInGroupRequestReasonEnum.fraud, 'Asking for money'),
                (ReportInGroupRequestReasonEnum.spam, 'Spam'),
              ])
                ListTile(
                  title: Text(label),
                  onTap: () => Navigator.pop(ctx, r),
                ),
            ],
          ),
        ),
      );
      if (reason == null) return;
      await api.send(
        () => api.groups.reportInGroup(
          groupId,
          ReportInGroupRequest(
            userId: p.identity,
            reason: reason,
            remove: action == 'remove',
          ),
        ),
      );
      if (mounted)
        groupSnack(context, 'Thanks — our safety team will review it.');
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _leave() async {
    if (_phase == _Phase.ended ||
        _phase == _Phase.consent ||
        _phase == _Phase.loading) {
      if (mounted) context.pop();
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          widget.isHost ? 'End the group for everyone?' : 'Leave the group?',
        ),
        content: Text(
          widget.isHost
              ? 'You earned ${rupees(_earnedPaise)} so far ($_paidMinutes paid minutes plus gifts).'
              : _phase == _Phase.live
              ? 'You paid for $_minutes min. Leaving stops the charge.'
              : "You haven't paid anything yet.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(widget.isHost ? 'End group' : 'Leave'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final api = ref.read(apiProvider);
    if (widget.isHost) {
      await api.send(() => api.groups.endGroup(groupId)).catchError((_) {});
      await _beat();
    } else {
      await api.send(() => api.groups.leaveGroup(groupId)).catchError((_) {});
    }
    ref.invalidate(groupsProvider);
    if (mounted) context.pop();
  }

  void _end(String text) {
    if (_phase == _Phase.ended) return;
    _heartbeat?.cancel();
    _safety?.cancel();
    unawaited(_room?.disconnect());
    ref.invalidate(groupsProvider);
    if (!mounted) return;
    setState(() {
      _phase = _Phase.ended;
      _endedText = text;
    });
  }

  // --- UI ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) => PopScope(
    canPop:
        _phase == _Phase.ended ||
        _phase == _Phase.consent ||
        _phase == _Phase.loading,
    onPopInvokedWithResult: (didPop, _) {
      if (!didPop) _leave();
    },
    child: Scaffold(
      backgroundColor: const Color(0xFF0A0A18),
      body: switch (_phase) {
        _Phase.loading => const Center(child: CircularProgressIndicator()),
        _Phase.consent => _Consent(
          card: _card!,
          busy: _busy,
          noCoins: _noCoins,
          onJoin: () => _join(agree: true),
          onAddCoins: () {
            context.go('/home');
            showError(
              context,
              'Open Wallet to add coins, then come back to the group.',
            );
          },
        ),
        _Phase.lobby => _lobby(),
        _Phase.live => _live(),
        _Phase.ended => _ended(),
      },
    ),
  );

  Widget _topBar({required List<Widget> chips}) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 8, 0),
    child: Row(
      children: [
        Expanded(child: Wrap(spacing: 6, runSpacing: 6, children: chips)),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFE11D48),
          ),
          onPressed: _leave,
          child: Text(widget.isHost ? 'End' : 'Leave'),
        ),
      ],
    ),
  );

  Widget _lobby() {
    final c = _card;
    final need = c?.minMembers ?? 3;
    final waiting = widget.isHost ? _waiting : (c?.members ?? _waiting);
    final cam = _camera;
    return SafeArea(
      child: Column(
        children: [
          _topBar(
            chips: [
              const _Chip(icon: Icons.hourglass_top_rounded, text: 'Lobby'),
              _Chip(
                icon: Icons.people_alt_outlined,
                text: '$waiting/$need to start',
              ),
            ],
          ),
          const Spacer(),
          if (widget.isHost && cam != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 180,
                height: 240,
                child: VideoTrackRenderer(
                  cam,
                  fit: VideoViewFit.cover,
                  mirrorMode: VideoViewMirrorMode.mirror,
                ),
              ),
            )
          else
            const Icon(Icons.groups_rounded, size: 72, color: groupGreen),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Text(
                  c?.title ?? 'Group video',
                  textAlign: TextAlign.center,
                  style: AppText.heading(20),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.isHost
                      ? 'Waiting for people to join. The group starts when $need are in — then you earn from every minute.'
                      : "Waiting for ${need - waiting > 0 ? '${need - waiting} more' : 'the start'}. "
                            "You won't pay anything until it starts (${c?.coinsPerMin ?? 12} coins/min then).",
                  textAlign: TextAlign.center,
                  style: AppText.body(
                    14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                LinearProgressIndicator(
                  value: (waiting / need).clamp(0, 1).toDouble(),
                  color: groupGreen,
                  backgroundColor: Colors.white12,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(99),
                ),
              ],
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  List<Participant> _people() {
    final room = _room;
    if (room == null) return const [];
    final remotes = room.remoteParticipants.values.toList();
    final hostId = _card?.host.id;
    // Host first, then whoever is speaking, then the rest.
    remotes.sort((a, b) {
      int rank(Participant p) =>
          p.identity == hostId ? 0 : (p.identity == _speakerId ? 1 : 2);
      return rank(a).compareTo(rank(b));
    });
    return [
      ...remotes,
      if (room.localParticipant != null) room.localParticipant!,
    ];
  }

  Widget _live() {
    final people = _people();
    final c = _card;
    final perMin = c?.coinsPerMin ?? 12;
    return Stack(
      fit: StackFit.expand,
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 52, bottom: 132),
            child: _Grid(
              people: people,
              focusId: people.isEmpty ? null : people.first.identity,
              localPaused: _paused,
              front: _front,
              onLongPress: (p) =>
                  p is RemoteParticipant ? _personMenu(p) : null,
            ),
          ),
        ),
        for (final id in _hearts) FloatingHeart(key: ValueKey(id), seed: id),
        SafeArea(
          child: Column(
            children: [
              _topBar(
                chips: [
                  _Chip(
                    icon: Icons.timer_outlined,
                    text: clockLeft(
                      DateTime.now().difference(_liveSince ?? DateTime.now()),
                    ),
                  ),
                  _Chip(
                    icon: Icons.people_alt_outlined,
                    text: '${people.length}/${(c?.maxMembers ?? 10) + 1}',
                  ),
                  if (widget.isHost)
                    _Chip(
                      icon: Icons.currency_rupee_rounded,
                      text: rupees(_earnedPaise).replaceAll('₹', ''),
                      accent: true,
                    )
                  else
                    _Chip(
                      icon: Icons.toll_rounded,
                      text:
                          '$perMin/min · $_minutes min${_coinsLeft == null ? '' : ' · $_coinsLeft left'}',
                    ),
                ],
              ),
              const Spacer(),
              if (_paused)
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCC9F1239),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Your camera is paused for a moment — our safety check flagged the picture.',
                    style: AppText.body(13, weight: FontWeight.w700),
                  ),
                ),
              if (_lowBalance && !widget.isHost)
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xCCB45309),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Only ${_coinsLeft ?? 0} coins left — add coins to stay after this minute.',
                    style: AppText.body(13, weight: FontWeight.w700),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 80, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final l
                          in _lines.length > 4
                              ? _lines.sublist(_lines.length - 4)
                              : _lines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: l.highlight
                                  ? const Color(0x66065F46)
                                  : Colors.black45,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${l.name} ',
                                    style: AppText.body(
                                      12.5,
                                      weight: FontWeight.w800,
                                      color: const Color(0xFF6EE7B7),
                                    ),
                                  ),
                                  TextSpan(
                                    text: l.body,
                                    style: AppText.body(12.5),
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
                padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
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
                          hintText: 'Say something…',
                          hintStyle: AppText.body(14, color: Colors.white60),
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
                    const SizedBox(width: 6),
                    _Round(
                      icon: Icons.favorite_rounded,
                      label: 'Send a heart',
                      onTap: _heart,
                      color: const Color(0xFFF472B6),
                    ),
                    if (!widget.isHost) ...[
                      const SizedBox(width: 6),
                      _Round(
                        icon: Icons.card_giftcard_rounded,
                        label: 'Send a gift',
                        onTap: _gift,
                        color: const Color(0xFFFCD34D),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Round(
                      icon: _mic ? Icons.mic_rounded : Icons.mic_off_rounded,
                      label: _mic ? 'Mute' : 'Unmute',
                      onTap: _toggleMic,
                    ),
                    const SizedBox(width: 14),
                    _Round(
                      icon: _cam
                          ? Icons.videocam_rounded
                          : Icons.videocam_off_rounded,
                      label: _cam ? 'Camera off' : 'Camera on',
                      onTap: _toggleCam,
                    ),
                    const SizedBox(width: 14),
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
    );
  }

  Widget _ended() => SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.groups_rounded, size: 64, color: groupGreen),
          const SizedBox(height: 16),
          Text(
            _endedText ?? 'The group has ended',
            textAlign: TextAlign.center,
            style: AppText.heading(19),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isHost
                ? 'Earned ${rupees(_earnedPaise)} · $_paidMinutes paid minutes'
                : (_minutes > 0
                      ? 'You paid for $_minutes min. See Coin history for every minute.'
                      : ''),
            textAlign: TextAlign.center,
            style: AppText.body(14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: groupGreen,
              minimumSize: const Size(200, 50),
            ),
            onPressed: () => context.pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    ),
  );
}

/// Before joining: price, camera disclosure, and the join button.
class _Consent extends ConsumerWidget {
  const _Consent({
    required this.card,
    required this.busy,
    required this.noCoins,
    required this.onJoin,
    required this.onAddCoins,
  });
  final GroupCard card;
  final bool busy, noCoins;
  final VoidCallback onJoin, onAddCoins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(walletProvider).valueOrNull?.coins;
    return SafeArea(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => context.pop(),
            ),
          ),
          const Spacer(),
          Avatar(
            name: card.host.displayName,
            avatarId: card.host.avatarId,
            photoUrl: card.host.photoUrl,
            size: 84,
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Text(
                  card.title,
                  textAlign: TextAlign.center,
                  style: AppText.heading(21),
                ),
                const SizedBox(height: 4),
                Text(
                  'with ${card.host.displayName} · ${card.members}/${card.maxMembers} in',
                  style: AppText.body(14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 22),
                for (final (icon, text) in [
                  (
                    Icons.videocam_rounded,
                    'Everyone in the group can see your camera and hear you.',
                  ),
                  (
                    Icons.toll_rounded,
                    '${card.coinsPerMin} coins a minute, paid at the start of each minute — only once the group starts.',
                  ),
                  (
                    Icons.logout_rounded,
                    'Leave anytime. You only pay for minutes you stay.',
                  ),
                  (
                    Icons.shield_outlined,
                    'Keep it friendly. Cameras are safety-checked, and you can report anyone.',
                  ),
                  (
                    Icons.wifi_rounded,
                    'Group video uses more data than a 1:1 call — Wi-Fi is best.',
                  ),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, size: 20, color: groupGreen),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            text,
                            style: AppText.body(13.5, height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Column(
              children: [
                if (noCoins)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'You need at least ${card.coinsPerMin} coins to join.',
                      style: AppText.body(
                        13.5,
                        color: AppColors.warning,
                        weight: FontWeight.w700,
                      ),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: noCoins ? AppColors.warning : groupGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    onPressed: busy ? null : (noCoins ? onAddCoins : onJoin),
                    child: Text(
                      noCoins
                          ? 'Add coins'
                          : (busy
                                ? 'Joining…'
                                : 'Agree & join · ${card.coinsPerMin} coins/min'),
                      style: AppText.heading(16),
                    ),
                  ),
                ),
                if (coins != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'You have $coins coins',
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Video tiles: the first person large, everyone else in a grid below.
class _Grid extends StatelessWidget {
  const _Grid({
    required this.people,
    required this.focusId,
    required this.localPaused,
    required this.front,
    required this.onLongPress,
  });
  final List<Participant> people;
  final String? focusId;
  final bool localPaused, front;
  final void Function(Participant) onLongPress;

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) return const Center(child: CircularProgressIndicator());
    final focus = people.first;
    final rest = people.skip(1).toList();
    final cols = rest.length <= 2 ? 2 : 3;
    return LayoutBuilder(
      builder: (context, box) {
        final tileW = (box.maxWidth - 8 * (cols + 1)) / cols;
        final tileH = tileW * 4 / 3;
        final rows = (rest.length / cols).ceil();
        final restH = rows == 0 ? 0.0 : rows * (tileH + 8);
        final focusH = (box.maxHeight - restH - 8).clamp(160.0, box.maxHeight);
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: SizedBox(
                  height: focusH,
                  child: _Tile(
                    p: focus,
                    localPaused: localPaused,
                    front: front,
                    onLongPress: onLongPress,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final p in rest)
                      SizedBox(
                        width: tileW,
                        height: tileH,
                        child: _Tile(
                          p: p,
                          localPaused: localPaused,
                          front: front,
                          onLongPress: onLongPress,
                          small: true,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.p,
    required this.localPaused,
    required this.front,
    required this.onLongPress,
    this.small = false,
  });
  final Participant p;
  final bool localPaused, front, small;
  final void Function(Participant) onLongPress;

  @override
  Widget build(BuildContext context) {
    final local = p is LocalParticipant;
    final pub = p.videoTrackPublications.where((t) => !t.muted).firstOrNull;
    final track = pub?.track as VideoTrack?;
    final show = track != null && !(local && localPaused);
    final name = local ? 'You' : (p.name.isNotEmpty ? p.name : 'Guest');
    return GestureDetector(
      onLongPress: local ? null : () => onLongPress(p),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(small ? 14 : 20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: Color(0xFF16142C)),
            if (show)
              VideoTrackRenderer(
                track,
                fit: VideoViewFit.cover,
                mirrorMode: local && front
                    ? VideoViewMirrorMode.mirror
                    : VideoViewMirrorMode.off,
              )
            else
              Center(
                child: Icon(
                  Icons.videocam_off_rounded,
                  color: Colors.white38,
                  size: small ? 26 : 40,
                ),
              ),
            if (p.isSpeaking)
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: groupGreen, width: 3),
                  borderRadius: BorderRadius.circular(small ? 14 : 20),
                ),
              ),
            Positioned(
              left: 6,
              bottom: 6,
              right: 6,
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(
                          small ? 11 : 13,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  if (!p.isMicrophoneEnabled()) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.mic_off_rounded,
                      size: 14,
                      color: Colors.white70,
                    ),
                  ],
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: accent ? const Color(0x9910B981) : Colors.black45,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 4),
        Text(text, style: AppText.body(12, weight: FontWeight.w700)),
      ],
    ),
  );
}

class _Round extends StatelessWidget {
  const _Round({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black45,
        ),
        child: Icon(icon, color: color),
      ),
    ),
  );
}
