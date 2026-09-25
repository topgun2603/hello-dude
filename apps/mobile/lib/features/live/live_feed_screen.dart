import 'dart:async';
import 'dart:math';
import 'dart:ui';

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
import '../../moderation/video_moderator.dart';
import '../../widgets/common.dart';
import '../call/gift_sheet.dart' show giftsProvider;
import '../home/home_data.dart' show walletProvider;
import 'live_data.dart';
import 'pk.dart';

/// Reels-style feed of lives: swipe up/down. Only the live on screen plays (and
/// is joined); the others are a still card, which keeps data use low. Follows
/// the list the caller came from (same filters and order) and loads more near
/// the end.
class LiveFeedScreen extends ConsumerStatefulWidget {
  const LiveFeedScreen({super.key, this.args = const LiveFeedArgs()});
  final LiveFeedArgs args;

  @override
  ConsumerState<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends ConsumerState<LiveFeedScreen> {
  PageController? _pages;
  int _current = 0;
  List<LiveCard>? _lives; // only grows while swiping, so pages don't jump
  int _total = 0;
  LivePricing? _pricing;
  bool _loadingMore = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _load();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _pages?.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final api = ref.read(apiProvider);
    try {
      final first = await fetchLives(api, widget.args.query);
      final lives = [...?widget.args.initial];
      for (final l in first.lives) {
        if (!lives.any((x) => x.id == l.id)) lives.add(l);
      }
      if (!mounted) return;
      final i = lives.indexWhere((l) => l.id == widget.args.startId);
      setState(() {
        _lives = lives;
        _total = first.total;
        _pricing = first.pricing;
        _current = i < 0 ? 0 : i;
        _pages = PageController(initialPage: _current);
      });
    } catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _more() async {
    final lives = _lives;
    if (lives == null || _loadingMore || lives.length >= _total) return;
    _loadingMore = true;
    try {
      final page = await fetchLives(
        ref.read(apiProvider),
        widget.args.query,
        offset: lives.length,
      );
      if (!mounted) return;
      setState(() {
        for (final l in page.lives) {
          if (!lives.any((x) => x.id == l.id)) lives.add(l);
        }
        _total = page.total;
      });
    } catch (_) {
      /* try again on the next swipe */
    } finally {
      _loadingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lives = _lives;
    return Scaffold(
      backgroundColor: Colors.black,
      body: lives == null
          ? Center(
              child: _error != null
                  ? Text(friendlyError(_error!), style: AppText.body(14))
                  : const CircularProgressIndicator(color: AppColors.pink),
            )
          : lives.isEmpty
          ? _Empty(onClose: () => context.pop())
          : PageView.builder(
              controller: _pages,
              scrollDirection: Axis.vertical,
              itemCount: lives.length,
              onPageChanged: (i) {
                setState(() => _current = i);
                if (i >= lives.length - 3) _more();
              },
              itemBuilder: (_, i) => LivePage(
                key: ValueKey(lives[i].id),
                card: lives[i],
                pricing: _pricing!,
                active: i == _current,
              ),
            ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded, color: Colors.white),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.live_tv_rounded,
                  color: AppColors.lilac,
                  size: 44,
                ),
                const SizedBox(height: 12),
                Text('Nobody is live right now', style: AppText.heading(18)),
                const SizedBox(height: 6),
                Text(
                  'Favourite companions to get a ping when they go live.',
                  textAlign: TextAlign.center,
                  style: AppText.body(14, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

enum _Phase { idle, joining, watching, locked, ended }

/// One live. Joins only while [active]; after the free preview the viewer opts in
/// to pay per minute, and the server charges each minute and removes them when
/// they stop paying.
class LivePage extends ConsumerStatefulWidget {
  const LivePage({
    super.key,
    required this.card,
    required this.pricing,
    required this.active,
  });
  final LiveCard card;
  final LivePricing pricing;
  final bool active;

  @override
  ConsumerState<LivePage> createState() => _LivePageState();
}

class _ChatLine {
  _ChatLine(this.name, this.body, {this.host = false, this.system = false});
  final String name, body;
  final bool host, system;
}

class _LivePageState extends ConsumerState<LivePage> {
  _Phase _phase = _Phase.idle;
  Room? _room;
  EventsListener<RoomEvent>? _roomEvents;
  VideoTrack? _video;
  LiveAccess? _access;
  int _viewers = 0;
  final _chat = <_ChatLine>[];
  final _hearts = <int>[];
  final _input = TextEditingController();
  Timer? _tick, _heartbeat;
  StreamSubscription<Map<String, dynamic>>? _events;
  VideoModerator? _moderator;
  bool _buying = false;
  bool _noCoins = false, _lowBalance = false;
  int? _coinsLeft;
  int _minutes = 0;
  int _heartSeq = 0;
  PkController? _pk;

  LiveCard get c => widget.card;

  @override
  void initState() {
    super.initState();
    _viewers = c.viewers;
    if (widget.active) _start();
  }

  @override
  void didUpdateWidget(LivePage old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) _start();
    if (!widget.active && old.active) _stop(leave: true);
  }

  @override
  void dispose() {
    _stop(leave: widget.active);
    _input.dispose();
    super.dispose();
  }

  // --- lifecycle -------------------------------------------------------------------

  Future<void> _start() async {
    _pk ??= PkController(api: ref.read(apiProvider), fromLiveId: c.id)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _events ??= ref.read(realtimeProvider).forLive(c.id).listen(_onEvent);
    _tick ??= Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    await _join();
  }

  void _stop({required bool leave}) {
    _tick?.cancel();
    _tick = null;
    _heartbeat?.cancel();
    _heartbeat = null;
    _events?.cancel();
    _events = null;
    _pk?.dispose();
    _pk = null;
    _disconnect();
    if (leave) {
      final api = ref.read(apiProvider);
      unawaited(api.send(() => api.lives.leaveLive(c.id)).catchError((_) {}));
    }
    if (mounted && _phase != _Phase.ended) _phase = _Phase.idle;
  }

  void _disconnect() {
    _moderator?.dispose();
    _moderator = null;
    _roomEvents?.dispose();
    _roomEvents = null;
    final r = _room;
    _room = null;
    _video = null;
    if (r != null) unawaited(r.disconnect().then((_) => r.dispose()));
  }

  Future<void> _join({bool pay = false}) async {
    if (!mounted) return;
    setState(() => _phase = _Phase.joining);
    final api = ref.read(apiProvider);
    try {
      final j = await api.call(
        () => api.lives.joinLive(c.id, JoinLiveRequest(pay: pay)),
      );
      if (!mounted || !widget.active) return;
      _access = j.access;
      _minutes = j.access.minutes;
      _coinsLeft = j.coinsLeft;
      _noCoins = false;
      _viewers = max(_viewers, j.live.viewers);
      await _connect(j);
      final battle = j.live.pkBattleId;
      if (battle != null && _pk?.showing != true) unawaited(_pk?.load(battle));
      _heartbeat ??= Timer.periodic(
        const Duration(seconds: 20),
        (_) => _beat(),
      );
      if (mounted) setState(() => _phase = _Phase.watching);
    } catch (e) {
      if (!mounted) return;
      switch (errorCode(e)) {
        case 'PAY_TO_WATCH':
          setState(() => _phase = _Phase.locked);
        case 'INSUFFICIENT_BALANCE':
          setState(() {
            _phase = _Phase.locked;
            _noCoins = true;
          });
        case 'LIVE_ENDED':
          setState(() => _phase = _Phase.ended);
        default:
          setState(() => _phase = _Phase.idle);
          showError(context, friendlyError(e));
      }
    }
  }

  Future<void> _connect(LiveJoin j) async {
    _disconnect();
    final room = Room(
      roomOptions: const RoomOptions(adaptiveStream: true, dynacast: true),
    );
    _room = room;
    unawaited(_loadChatHistory());
    _roomEvents = room.createListener()
      ..on<TrackSubscribedEvent>((e) {
        if (e.track is VideoTrack && mounted) {
          setState(() => _video = e.track as VideoTrack);
          // No viewer-side nudity check: grabbing frames of a remote track makes
          // flutter_webrtc dispose LiveKit's transceivers and crash the app. The
          // host's phone checks its own camera (pauses it + flags the frame).
        }
      })
      ..on<TrackUnsubscribedEvent>((e) {
        if (e.track == _video && mounted) setState(() => _video = null);
      })
      ..on<RoomDisconnectedEvent>((_) {
        // Removed by the server (time up) or the live ended: ask where we stand.
        if (mounted && _phase == _Phase.watching) _beat();
      });
    await room.connect(j.liveKitUrl, j.token);
    // A video track may already be there when we join.
    for (final p in room.remoteParticipants.values) {
      for (final pub in p.videoTrackPublications) {
        final t = pub.track;
        if (t != null && mounted) setState(() => _video = t);
      }
    }
  }

  Future<void> _beat() async {
    final api = ref.read(apiProvider);
    try {
      final a = await api.call(() => api.lives.liveHeartbeat(c.id));
      if (!mounted) return;
      _access = a;
      if (a.kind == LiveAccessKindEnum.none) _lock();
    } catch (_) {
      /* next beat */
    }
  }

  void _onTick() {
    if (!mounted) return;
    final ends = _access?.endsAt;
    if (_phase == _Phase.watching &&
        ends != null &&
        ends.isBefore(DateTime.now())) {
      _lock();
    } else {
      setState(() {});
    }
  }

  /// Recent chat from before this viewer joined (the server keeps the last 50).
  Future<void> _loadChatHistory() async {
    final api = ref.read(apiProvider);
    try {
      final h = await api.call(() => api.lives.liveChatHistory(c.id));
      if (!mounted || h.messages.isEmpty) return;
      final seen = {for (final l in _chat) '${l.name}|${l.body}'};
      final older = [
        for (final m in h.messages)
          if (!seen.contains('${m.displayName}|${m.body}'))
            _ChatLine(m.displayName, m.body, host: m.isHost),
      ];
      setState(() => _chat.insertAll(0, older));
    } catch (_) {
      /* chat history is a nicety; live chat still works */
    }
  }

  void _lock() {
    _disconnect();
    if (mounted && _phase != _Phase.ended)
      setState(() => _phase = _Phase.locked);
  }

  void _onEvent(Map<String, dynamic> e) {
    if (!mounted) return;
    if (_pk?.handle(e) == true) return;
    switch (e['kind']) {
      case 'chat':
        setState(() {
          _chat.add(
            _ChatLine(
              '${e['displayName']}',
              '${e['body']}',
              host: e['isHost'] == true,
            ),
          );
          if (_chat.length > 200) _chat.removeAt(0);
        });
      case 'gift':
        final g = (e['gift'] as Map?) ?? const {};
        setState(
          () => _chat.add(
            _ChatLine(
              '${e['displayName']}',
              'sent ${g['emoji'] ?? '🎁'} ${g['name'] ?? 'a gift'}',
              system: true,
            ),
          ),
        );
      case 'reaction':
        _floatHeart();
      case 'viewers':
        setState(() => _viewers = (e['count'] as num?)?.toInt() ?? _viewers);
      case 'charged':
        setState(() {
          _minutes = (e['minute'] as num?)?.toInt() ?? _minutes + 1;
          _coinsLeft = (e['coinsLeft'] as num?)?.toInt() ?? _coinsLeft;
        });
      case 'low_balance':
        setState(() => _lowBalance = true);
      case 'access':
        if (e['state'] == 'no_coins') _noCoins = true;
        _lock();
      case 'ended':
        _disconnect();
        setState(() => _phase = _Phase.ended);
    }
  }

  void _floatHeart() {
    final id = _heartSeq++;
    setState(() => _hearts.add(id));
    Timer(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _hearts.remove(id));
    });
  }

  // --- actions ---------------------------------------------------------------------

  /// "Keep watching": agree to pay per minute; the first minute is charged now.
  Future<void> _keepWatching() async {
    if (_buying) return;
    setState(() => _buying = true);
    try {
      await _join(pay: true);
      ref.invalidate(walletProvider);
    } finally {
      if (mounted) setState(() => _buying = false);
    }
  }

  Future<void> _sendChat() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    final api = ref.read(apiProvider);
    try {
      await api.send(
        () =>
            api.lives.sendLiveMessage(c.id, SendRoomMessageRequest(body: text)),
      );
      _input.clear();
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _heart() async {
    _floatHeart();
    final api = ref.read(apiProvider);
    unawaited(
      api
          .send(
            () => api.lives.sendLiveReaction(
              c.id,
              SendRoomReactionRequest(emoji: '❤️'),
            ),
          )
          .catchError((_) {}),
    );
  }

  Future<void> _gift() async {
    final gifts = await ref.read(giftsProvider.future);
    if (!mounted) return;
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
              Text(
                'Send ${c.host.displayName} a gift',
                style: AppText.heading(18),
              ),
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
                                color: AppColors.warning,
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
    // In a PK battle the viewer picks a side (either host can get it).
    String? toHost;
    final pk = _pk;
    if (pk != null && pk.active) {
      toHost = await pickPkSide(context, pk);
      if (toHost == null) return;
    }
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.lives.sendLiveGift(
          c.id,
          SendLiveGiftRequest(
            giftId: picked.id,
            clientRef: uuidV4(),
            toHostId: toHost,
          ),
        ),
      );
      ref.invalidate(walletProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _report() async {
    const reasons = [
      (ReportUserRequestReasonEnum.sexualContent, 'Sexual content'),
      (ReportUserRequestReasonEnum.abuse, 'Abusive or rude'),
      (ReportUserRequestReasonEnum.fraud, 'Asking for money / UPI'),
      (ReportUserRequestReasonEnum.underage, 'Seems under 18'),
      (ReportUserRequestReasonEnum.other, 'Something else'),
    ];
    final reason = await showModalBottomSheet<ReportUserRequestReasonEnum>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                'Report ${c.host.displayName}',
                style: AppText.heading(18),
              ),
            ),
            for (final (r, label) in reasons)
              ListTile(
                title: Text(label, style: AppText.body(15)),
                onTap: () => Navigator.pop(ctx, r),
              ),
          ],
        ),
      ),
    );
    if (reason == null) return;
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.safety.reportUser(
          ReportUserRequest(
            userId: c.host.id,
            reason: reason,
            details: 'Reported during a live',
          ),
        ),
      );
      if (mounted) {
        showError(
          context,
          "Thanks — we'll review this. You won't see ${c.host.displayName} again.",
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  // --- UI --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final watching = _phase == _Phase.watching;
    final hidden = _moderator?.hidden == true;
    final ends = _access?.endsAt;
    final left = ends?.difference(DateTime.now());
    final preview = _access?.kind == LiveAccessKindEnum.preview;
    final canChat = _access?.kind == LiveAccessKindEnum.paying;
    final perMin = widget.pricing.coinsPerMin;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video, or a card while joining / locked / not on screen.
        if (watching && _pk?.showing == true)
          const ColoredBox(color: Color(0xFF0A0A18))
        else if (watching && _video != null && !hidden)
          VideoTrackRenderer(_video!, fit: VideoViewFit.cover)
        else
          _Backdrop(card: c, blur: _phase == _Phase.locked || hidden),
        if (hidden)
          Center(
            child: Text(
              'Video hidden for safety',
              style: AppText.body(15, weight: FontWeight.w700),
            ),
          ),
        // Readability gradients.
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
                stops: [0, 0.22, 0.6, 1],
              ),
            ),
          ),
        ),
        if (watching && _pk?.showing == true)
          Positioned(
            top: MediaQuery.paddingOf(context).top + 96,
            left: 0,
            right: 0,
            child: PkBattleView(
              pk: _pk!,
              myVideo: _video != null && !hidden
                  ? VideoTrackRenderer(_video!, fit: VideoViewFit.cover)
                  : _Backdrop(card: c, blur: hidden),
            ),
          ),
        SafeArea(
          child: Column(
            children: [
              _TopBar(
                card: c,
                viewers: _viewers,
                onClose: () => context.pop(),
                onReport: _report,
              ),
              if (watching)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: _MeterPill(
                    preview: preview,
                    left: left,
                    coinsPerMin: perMin,
                    minutes: _minutes,
                    coinsLeft: _coinsLeft,
                  ),
                ),
              const Spacer(),
              if (_phase == _Phase.locked)
                _KeepWatching(
                  card: c,
                  coinsPerMin: perMin,
                  busy: _buying,
                  noCoins: _noCoins,
                  onKeepWatching: _keepWatching,
                  onAddCoins: () {
                    context.go('/home');
                    showError(
                      context,
                      'Open Wallet to add coins, then come back to the live.',
                    );
                  },
                ),
              if (_phase == _Phase.ended) _Ended(name: c.host.displayName),
              if (_phase == _Phase.joining || _phase == _Phase.idle)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              if (watching) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: _ChatList(lines: _chat, title: c.title),
                ),
                if (_lowBalance && canChat)
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
                      'Only ${_coinsLeft ?? 0} coins left — add coins to keep watching after this minute.',
                      style: AppText.body(13, weight: FontWeight.w700),
                    ),
                  ),
                _BottomBar(
                  input: _input,
                  canChat: canChat,
                  preview: preview,
                  coinsPerMin: perMin,
                  onSend: _sendChat,
                  onHeart: _heart,
                  onGift: _gift,
                  onKeepWatching: _keepWatching,
                ),
              ],
            ],
          ),
        ),
        // Floating hearts.
        for (final id in _hearts) FloatingHeart(key: ValueKey(id), seed: id),
      ],
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.card, required this.blur});
  final LiveCard card;
  final bool blur;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3B0764), Color(0xFF831843), Color(0xFF0A0A18)],
      ),
    ),
    child: ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: blur ? 12 : 0,
        sigmaY: blur ? 12 : 0,
      ),
      child: card.snapshotUrl != null
          // The latest still from the live, full screen, until the video starts.
          ? Image.network(
              Avatar.photoSrc(card.snapshotUrl!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _avatar(),
            )
          : _avatar(),
    ),
  );

  Widget _avatar() => Center(
    child: Avatar(
      name: card.host.displayName,
      avatarId: card.host.avatarId,
      photoUrl: card.host.photoUrl,
      size: 150,
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.card,
    required this.viewers,
    required this.onClose,
    required this.onReport,
  });
  final LiveCard card;
  final int viewers;
  final VoidCallback onClose, onReport;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 4, 0),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 12, 4),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Avatar(
                name: card.host.displayName,
                avatarId: card.host.avatarId,
                photoUrl: card.host.photoUrl,
                size: 34,
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.host.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(14, weight: FontWeight.w700),
                    ),
                    Text(
                      card.host.rating == null
                          ? 'New'
                          : '★ ${card.host.rating!.toStringAsFixed(1)}',
                      style: AppText.body(11.5, color: const Color(0xFFFCD34D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const LiveBadge(),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.visibility_outlined,
                size: 14,
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              Text(
                '$viewers',
                style: AppText.body(12, weight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Report',
          onPressed: onReport,
          icon: const Icon(Icons.flag_outlined, color: Colors.white),
        ),
        IconButton(
          tooltip: 'Close',
          onPressed: onClose,
          icon: const Icon(Icons.close_rounded, color: Colors.white),
        ),
      ],
    ),
  );
}

/// Free preview countdown, then the running cost: "3 coins/min · 4 min · 488 left".
class _MeterPill extends StatelessWidget {
  const _MeterPill({
    required this.preview,
    required this.left,
    required this.coinsPerMin,
    required this.minutes,
    required this.coinsLeft,
  });
  final bool preview;
  final Duration? left;
  final int coinsPerMin, minutes;
  final int? coinsLeft;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: preview ? const Color(0xCCB45309) : Colors.black45,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          preview ? Icons.hourglass_bottom_rounded : Icons.timer_outlined,
          size: 15,
          color: Colors.white,
        ),
        const SizedBox(width: 6),
        Text(
          preview
              ? 'Free preview ${clockLeft(left ?? Duration.zero)} · then $coinsPerMin coins/min'
              : '$coinsPerMin coins/min · $minutes min${coinsLeft == null ? '' : ' · $coinsLeft left'}',
          style: AppText.body(13, weight: FontWeight.w700),
        ),
      ],
    ),
  );
}

class _ChatList extends StatelessWidget {
  const _ChatList({required this.lines, required this.title});
  final List<_ChatLine> lines;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 90, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppText.heading(16),
          ),
          const SizedBox(height: 8),
          LiveChatOverlay(
            count: lines.length,
            itemBuilder: (context, i) {
              final l = lines[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black38,
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
                            color: l.host
                                ? const Color(0xFFFDE68A)
                                : const Color(0xFFF9A8D4),
                          ),
                        ),
                        TextSpan(
                          text: l.body,
                          style: AppText.body(
                            13,
                            color: l.system
                                ? const Color(0xFFFDE68A)
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.input,
    required this.canChat,
    required this.onSend,
    required this.onHeart,
    required this.onGift,
    required this.onKeepWatching,
    required this.preview,
    required this.coinsPerMin,
  });
  final TextEditingController input;
  final bool canChat;
  final VoidCallback onSend, onHeart, onGift, onKeepWatching;
  final bool preview;
  final int coinsPerMin;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
    child: Row(
      children: [
        Expanded(
          child: canChat
              ? TextField(
                  controller: input,
                  maxLength: 200,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                  style: AppText.body(14),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: 'Say something nice…',
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
                    suffixIcon: IconButton(
                      tooltip: 'Send',
                      onPressed: onSend,
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onKeepWatching,
                  child: Container(
                    height: 46,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      preview
                          ? 'Keep watching to chat · \$coinsPerMin coins/min'
                          : 'Chat opens when you keep watching',
                      style: AppText.body(14, color: Colors.white70),
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 8),
        _RoundAction(
          icon: Icons.card_giftcard_rounded,
          label: 'Send a gift',
          onTap: onGift,
          gradient: true,
        ),
        const SizedBox(width: 8),
        _RoundAction(
          icon: Icons.favorite_rounded,
          label: 'Send a heart',
          onTap: onHeart,
        ),
      ],
    ),
  );
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.gradient = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool gradient;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: label,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: gradient ? AppColors.brand : null,
          color: gradient ? null : Colors.black38,
        ),
        child: Icon(
          icon,
          color: gradient ? Colors.white : const Color(0xFFF472B6),
        ),
      ),
    ),
  );
}

/// After the free preview: agree to pay per minute (or add coins first).
class _KeepWatching extends ConsumerWidget {
  const _KeepWatching({
    required this.card,
    required this.coinsPerMin,
    required this.busy,
    required this.noCoins,
    required this.onKeepWatching,
    required this.onAddCoins,
  });
  final LiveCard card;
  final int coinsPerMin;
  final bool busy, noCoins;
  final VoidCallback onKeepWatching, onAddCoins;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coins = ref.watch(walletProvider).valueOrNull?.coins;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xE616142C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            noCoins
                ? "You're out of coins"
                : 'Keep watching ${card.host.displayName}',
            textAlign: TextAlign.center,
            style: AppText.heading(19),
          ),
          const SizedBox(height: 6),
          Text(
            noCoins
                ? 'Watching costs $coinsPerMin coins a minute. Add coins and come back — the live is still on.'
                : '$coinsPerMin coins a minute, paid at the start of each minute. Leave anytime — you only pay for the minutes you watch. Chat opens too.',
            textAlign: TextAlign.center,
            style: AppText.body(
              13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: noCoins
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFFDB2777),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              onPressed: busy ? null : (noCoins ? onAddCoins : onKeepWatching),
              child: Text(
                noCoins
                    ? 'Add coins'
                    : (busy
                          ? 'Starting…'
                          : 'Keep watching · $coinsPerMin coins/min'),
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
    );
  }
}

class _Ended extends StatelessWidget {
  const _Ended({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.all(16),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xE616142C),
      borderRadius: BorderRadius.circular(24),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.live_tv_rounded, color: AppColors.lilac, size: 36),
        const SizedBox(height: 8),
        Text('$name ended the live', style: AppText.heading(18)),
        const SizedBox(height: 4),
        Text(
          'Swipe for more lives',
          style: AppText.body(13.5, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}
