import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:pesu_api/api.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/ids.dart';
import '../../data/languages.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../call/gift_sheet.dart' show giftsProvider;
import '../home/home_data.dart';

final roomCategoriesProvider =
    FutureProvider.autoDispose<List<ListLanguages200ResponseInner>>((ref) {
      final api = ref.read(apiProvider);
      return api.call(() => api.rooms.listRoomCategories());
    });

final roomsProvider = FutureProvider.autoDispose
    .family<List<RoomCard>, String?>((ref, category) {
      final api = ref.read(apiProvider);
      return api.call(() => api.rooms.listRooms(category: category));
    });

const _reactions = ['❤️', '😂', '👏', '🔥', '😮', '🙏'];

/// Entry card for the caller home.
class VoiceRoomsCard extends StatelessWidget {
  const VoiceRoomsCard({super.key, this.host = false});
  final bool host;

  @override
  Widget build(BuildContext context) => Material(
    color: const Color(0x1FDB2777),
    borderRadius: BorderRadius.circular(18),
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      leading: const Icon(Icons.graphic_eq_rounded, color: AppColors.pinkSoft),
      title: Text(host ? 'Host a voice room' : 'Voice rooms'),
      subtitle: Text(
        host
            ? 'Talk to many at once and earn gifts'
            : 'Join a live group chat · listening is free',
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => context.push('/rooms'),
    ),
  );
}

/// Design: Rooms.dc.html — category chips, live room cards (first one featured), "+" to start (companions).
class RoomsScreen extends ConsumerStatefulWidget {
  const RoomsScreen({super.key});

  @override
  ConsumerState<RoomsScreen> createState() => _RoomsScreenState();
}

class _RoomsScreenState extends ConsumerState<RoomsScreen> {
  String? _category;

  Future<void> _start() async {
    final r = await showModalBottomSheet<RoomJoin>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF16142C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _StartRoomSheet(),
    );
    if (r != null && mounted)
      await context.push('/room/${r.room.id}', extra: r);
    ref.invalidate(roomsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final isCompanion =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.companion;
    final cats = ref.watch(roomCategoriesProvider).valueOrNull ?? const [];
    final rooms = ref.watch(roomsProvider(_category));
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async => ref.invalidate(roomsProvider(_category)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Voice rooms',
                        style: AppText.heading(22),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCompanion)
                      Semantics(
                        button: true,
                        label: 'Start a room',
                        child: GestureDetector(
                          onTap: _start,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.brand,
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Join a live group chat in your language. Listening is free.',
                  style: AppText.body(14, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final (code, name) in [
                        (null, 'All'),
                        ...cats.map((c) => (c.code, c.name)),
                      ])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(name),
                            selected: _category == code,
                            onSelected: (_) => setState(() => _category = code),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ...rooms.when(
                  loading: () => [
                    const Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ],
                  error: (e, _) => [
                    Text(friendlyError(e), style: AppText.body(15)),
                  ],
                  data: (list) => list.isEmpty
                      ? [
                          const SizedBox(height: 40),
                          const Icon(
                            Icons.graphic_eq_rounded,
                            size: 52,
                            color: AppColors.hint,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'No live rooms right now',
                            textAlign: TextAlign.center,
                            style: AppText.heading(18),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            isCompanion
                                ? 'Start one with the + button.'
                                : 'Check back soon — companions start rooms most evenings.',
                            textAlign: TextAlign.center,
                            style: AppText.body(
                              14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ]
                      : [
                          for (final (i, r) in list.indexed)
                            _RoomCardView(
                              room: r,
                              featured: i == 0,
                              onJoin: () async {
                                await context.push('/room/${r.id}');
                                ref.invalidate(roomsProvider(_category));
                              },
                            ),
                        ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoomCardView extends StatelessWidget {
  const _RoomCardView({
    required this.room,
    required this.featured,
    required this.onJoin,
  });
  final RoomCard room;
  final bool featured;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: featured
            ? const LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFFC026D3),
                  Color(0xFFEA580C),
                ],
              )
            : null,
        color: featured ? null : AppColors.card,
        borderRadius: BorderRadius.circular(22),
        border: featured ? null : Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.danger,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'LIVE',
                  style: AppText.body(11, weight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${room.categoryName} · ${languageInfo(room.language).english}',
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(
                    12.5,
                    color: featured ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(room.title, style: AppText.heading(19)),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 28.0 + 20 * (room.faces.length - 1).clamp(0, 2),
                height: 32,
                child: Stack(
                  children: [
                    for (final (i, f) in room.faces.take(3).indexed)
                      Positioned(
                        left: i * 20.0,
                        child: Avatar(
                          name: f.displayName,
                          avatarId: f.avatarId,
                          size: 32,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hosted by ${room.host.displayName}',
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(13, weight: FontWeight.w600),
                    ),
                    Text(
                      '${room.listeners} listening',
                      style: AppText.body(
                        12.5,
                        color: featured
                            ? Colors.white70
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: featured ? Colors.white : AppColors.pink,
                  foregroundColor: featured
                      ? const Color(0xFFC026D3)
                      : Colors.white,
                ),
                onPressed: onJoin,
                child: const Text('Join'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StartRoomSheet extends ConsumerStatefulWidget {
  const _StartRoomSheet();

  @override
  ConsumerState<_StartRoomSheet> createState() => _StartRoomSheetState();
}

class _StartRoomSheetState extends ConsumerState<_StartRoomSheet> {
  final _title = TextEditingController();
  String? _category;
  bool _busy = false;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    final lang = ref.read(sessionProvider).profile?.primaryLanguage ?? 'ta';
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(
        () => api.rooms.startRoom(
          StartRoomRequest(
            title: _title.text.trim(),
            category: _category!,
            language: lang,
          ),
        ),
      );
      if (mounted) Navigator.pop(context, r);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        showError(context, friendlyError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(roomCategoriesProvider).valueOrNull ?? const [];
    final ok = _title.text.trim().length >= 3 && _category != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Start a voice room', style: AppText.heading(20)),
          const SizedBox(height: 12),
          TextField(
            controller: _title,
            maxLength: 60,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'What will you talk about?',
              hintText: 'e.g. Tamil movie talk',
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in cats)
                ChoiceChip(
                  label: Text(c.name),
                  selected: _category == c.code,
                  onSelected: (_) => setState(() => _category = c.code),
                ),
            ],
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Go live',
            icon: Icons.graphic_eq_rounded,
            loading: _busy,
            onPressed: ok ? _go : null,
          ),
        ],
      ),
    );
  }
}

/// Design: RoomLive.dc.html — stage grid, listeners, activity feed, action bar.
class RoomLiveScreen extends ConsumerStatefulWidget {
  const RoomLiveScreen({super.key, required this.roomId, this.joined});
  final String roomId;
  final RoomJoin? joined;

  @override
  ConsumerState<RoomLiveScreen> createState() => _RoomLiveScreenState();
}

class _FeedItem {
  _FeedItem(this.text, {this.gold = false});
  final String text;
  final bool gold;
}

class _RoomLiveScreenState extends ConsumerState<RoomLiveScreen> {
  final _room = Room(
    roomOptions: const RoomOptions(adaptiveStream: false, dynacast: false),
  );
  EventsListener<RoomEvent>? _roomEvents;
  StreamSubscription<Map<String, dynamic>>? _live;
  Timer? _heartbeat;
  RoomState? _state;
  final _feed = <_FeedItem>[];
  final _floating = <String>[];
  Set<String> _speaking = {};
  bool _muted = false, _handUp = false, _ended = false, _leaving = false;
  String? _error;
  final _chat = TextEditingController();

  String? get _me => ref.read(sessionProvider).profile?.id;
  RoomMemberRoleEnum? get _myRole =>
      _state?.members.where((m) => m.id == _me).firstOrNull?.role;
  bool get _isHost => _myRole == RoomMemberRoleEnum.host;

  @override
  void initState() {
    super.initState();
    _join();
  }

  Future<void> _join() async {
    final api = ref.read(apiProvider);
    try {
      final RoomJoin j =
          widget.joined ??
          await api.call<RoomJoin>(() => api.rooms.joinRoom(widget.roomId));
      if (!mounted) return;
      setState(() => _state = j.room);
      _live = ref
          .read(realtimeProvider)
          .events
          .where((e) => e['t'] == 'room_event' && e['roomId'] == widget.roomId)
          .listen((e) => _onEvent((e['event'] as Map).cast<String, dynamic>()));
      _heartbeat = Timer.periodic(const Duration(seconds: 30), (_) {
        _quietly(api.send(() => api.rooms.roomHeartbeat(widget.roomId)));
      });
      _roomEvents = _room.createListener()
        ..on<ActiveSpeakersChangedEvent>((e) {
          if (mounted)
            setState(
              () => _speaking = e.speakers.map((p) => p.identity).toSet(),
            );
        });
      await _room.connect(j.liveKitUrl, j.token);
      if (j.room.me != RoomStateMeEnum.listener)
        await _room.localParticipant?.setMicrophoneEnabled(true);
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    }
  }

  Future<void> _refresh() async {
    final api = ref.read(apiProvider);
    try {
      final s = await api.call(() => api.rooms.getRoom(widget.roomId));
      if (mounted) setState(() => _state = s);
    } catch (_) {}
  }

  Future<void> _onEvent(Map<String, dynamic> e) async {
    switch (e['kind']) {
      case 'join':
        setState(
          () => _feed.insert(0, _FeedItem('${e['displayName']} joined')),
        );
        await _refresh();
      case 'leave' || 'hand':
        await _refresh();
      case 'role':
        await _refresh();
        if (e['userId'] == _me) await _reconnectForRole();
      case 'chat':
        setState(
          () => _feed.insert(0, _FeedItem('${e['displayName']}  ${e['body']}')),
        );
      case 'gift':
        final g = (e['gift'] as Map?) ?? const {};
        setState(
          () => _feed.insert(
            0,
            _FeedItem(
              '${g['emoji'] ?? '🎁'} ${e['displayName']} sent ${e['toName']} a ${g['name']}',
              gold: true,
            ),
          ),
        );
      case 'reaction':
        final emoji = e['emoji'] as String? ?? '❤️';
        setState(() => _floating.add(emoji));
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && _floating.isNotEmpty)
            setState(() => _floating.removeAt(0));
        });
      case 'ended':
        if (!_ended && mounted) {
          setState(() => _ended = true);
          await _teardown();
          if (!mounted) return;
          if (!_leaving)
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('The room has ended')));
          context.pop();
        }
    }
    if (_feed.length > 60) _feed.removeRange(60, _feed.length);
  }

  /// Moved on or off stage: reconnect with a token that can (or can't) publish.
  Future<void> _reconnectForRole() async {
    final api = ref.read(apiProvider);
    try {
      final t = await api.call(() => api.rooms.roomToken(widget.roomId));
      await _room.disconnect();
      final url =
          widget.joined?.liveKitUrl ??
          (await api.call(() => api.rooms.joinRoom(widget.roomId))).liveKitUrl;
      await _room.connect(url, t.token);
      final onStage = t.role != RoomToken200ResponseRoleEnum.listener;
      await _room.localParticipant?.setMicrophoneEnabled(onStage && !_muted);
      if (mounted) {
        setState(() => _handUp = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              onStage
                  ? "You're on stage — your mic is on"
                  : "You're listening again",
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _teardown() async {
    _heartbeat?.cancel();
    await _live?.cancel();
    await _roomEvents?.dispose();
    await _room.disconnect();
  }

  Future<void> _leave() async {
    if (_isHost) {
      final end = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          backgroundColor: const Color(0xFF16142C),
          title: const Text('End this room for everyone?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text(
                'End room',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      );
      if (end != true) return;
    }
    _leaving = true;
    final api = ref.read(apiProvider);
    await _quietly(api.send(() => api.rooms.leaveRoom(widget.roomId)));
    await _teardown();
    if (mounted) context.pop();
  }

  @override
  void dispose() {
    _teardown();
    _room.dispose();
    _chat.dispose();
    super.dispose();
  }

  Future<void> _memberActions(RoomMember m) async {
    if (!_isHost || m.role == RoomMemberRoleEnum.host) return;
    final invite = m.role == RoomMemberRoleEnum.listener;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      builder: (c) => SafeArea(
        child: ListTile(
          leading: Icon(invite ? Icons.mic_rounded : Icons.mic_off_rounded),
          title: Text(
            invite
                ? 'Invite ${m.displayName} to speak'
                : 'Move ${m.displayName} to listeners',
          ),
          onTap: () => Navigator.pop(c, true),
        ),
      ),
    );
    if (ok != true) return;
    final api = ref.read(apiProvider);
    try {
      final s = await api.call(
        () => api.rooms.setRoomStage(
          widget.roomId,
          m.id,
          SetRoomStageRequest(
            action: invite
                ? SetRoomStageRequestActionEnum.invite
                : SetRoomStageRequestActionEnum.remove,
          ),
        ),
      );
      if (mounted) setState(() => _state = s);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _gift() async {
    final targets =
        _state?.members
            .where(
              (m) => m.role != RoomMemberRoleEnum.listener && m.isCompanion,
            )
            .toList() ??
        [];
    if (targets.isEmpty) return;
    final gifts = await ref.read(giftsProvider.future);
    if (!mounted) return;
    var to = targets.first;
    final picked = await showModalBottomSheet<Gift>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      builder: (c) => StatefulBuilder(
        builder: (c, set) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Send a gift', style: AppText.heading(18)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final t in targets)
                      ChoiceChip(
                        label: Text(t.displayName),
                        selected: t.id == to.id,
                        onSelected: (_) => set(() => to = t),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final g in gifts)
                      InkWell(
                        onTap: () => Navigator.pop(c, g),
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
                              Text(
                                g.emoji,
                                style: const TextStyle(fontSize: 26),
                              ),
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
      ),
    );
    if (picked == null) return;
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.rooms.sendRoomGift(
          widget.roomId,
          SendRoomGiftRequest(
            giftId: picked.id,
            toUserId: to.id,
            clientRef: uuidV4(),
          ),
        ),
      );
      ref.invalidate(walletProvider);
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _react() async {
    final emoji = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFF16142C),
      builder: (c) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final e in _reactions)
                InkWell(
                  onTap: () => Navigator.pop(c, e),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(e, style: const TextStyle(fontSize: 30)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (emoji == null) return;
    final api = ref.read(apiProvider);
    await _quietly(
      api.send(
        () => api.rooms.sendRoomReaction(
          widget.roomId,
          SendRoomReactionRequest(emoji: emoji),
        ),
      ),
    );
  }

  Future<void> _sendChat() async {
    final text = _chat.text.trim();
    if (text.isEmpty) return;
    final api = ref.read(apiProvider);
    try {
      await api.send(
        () => api.rooms.sendRoomMessage(
          widget.roomId,
          SendRoomMessageRequest(body: text),
        ),
      );
      _chat.clear();
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _state;
    final isCaller =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.caller;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        body: GlowBackground(
          child: SafeArea(
            child: _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: AppText.body(15),
                      ),
                    ),
                  )
                : s == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                            child: Row(
                              children: [
                                CircleIconButton(
                                  icon: Icons.keyboard_arrow_down_rounded,
                                  tooltip: 'Leave room',
                                  onPressed: _leave,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        s.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppText.heading(17),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.danger,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'LIVE',
                                              style: AppText.body(
                                                10,
                                                weight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '${s.members.length} listening',
                                            style: AppText.body(
                                              12.5,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.danger,
                                    side: const BorderSide(
                                      color: AppColors.danger,
                                    ),
                                  ),
                                  onPressed: _leave,
                                  child: Text(_isHost ? 'End' : 'Leave'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              children: [
                                GridView.count(
                                  crossAxisCount: 3,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 0.82,
                                  children: [
                                    for (final m in s.members.where(
                                      (m) =>
                                          m.role != RoomMemberRoleEnum.listener,
                                    ))
                                      _StageSeat(
                                        member: m,
                                        speaking: _speaking.contains(m.id),
                                        onTap: () => _memberActions(m),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Listening',
                                  style: AppText.body(
                                    13,
                                    color: AppColors.textSecondary,
                                    weight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final m
                                        in s.members
                                            .where(
                                              (m) =>
                                                  m.role ==
                                                  RoomMemberRoleEnum.listener,
                                            )
                                            .take(40))
                                      GestureDetector(
                                        onTap: () => _memberActions(m),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Avatar(
                                              name: m.displayName,
                                              avatarId: m.avatarId,
                                              size: 36,
                                            ),
                                            if (m.handRaised)
                                              const Positioned(
                                                right: -4,
                                                top: -6,
                                                child: Text(
                                                  '✋',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                for (final f in _feed.take(30))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 3,
                                    ),
                                    child: Text(
                                      f.text,
                                      style: AppText.body(
                                        13.5,
                                        color: f.gold
                                            ? const Color(0xFFFCD34D)
                                            : AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 12, 6),
                            child: TextField(
                              controller: _chat,
                              maxLength: 200,
                              style: AppText.body(14),
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: 'Say something…',
                                isDense: true,
                                filled: true,
                                fillColor: AppColors.card,
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    size: 20,
                                  ),
                                  onPressed: _sendChat,
                                  tooltip: 'Send',
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              onSubmitted: (_) => _sendChat(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: _myRole == RoomMemberRoleEnum.listener
                                      ? GradientButton(
                                          label: _handUp
                                              ? 'Hand raised'
                                              : 'Raise hand',
                                          icon: Icons.back_hand_rounded,
                                          onPressed: () async {
                                            final api = ref.read(apiProvider);
                                            final up = !_handUp;
                                            setState(() => _handUp = up);
                                            await _quietly(
                                              api.send(
                                                () => api.rooms.raiseHand(
                                                  widget.roomId,
                                                  RaiseHandRequest(raised: up),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : GradientButton(
                                          label: _muted ? 'Unmute' : 'Mute',
                                          icon: _muted
                                              ? Icons.mic_off_rounded
                                              : Icons.mic_rounded,
                                          onPressed: () async {
                                            setState(() => _muted = !_muted);
                                            await _room.localParticipant
                                                ?.setMicrophoneEnabled(!_muted);
                                          },
                                        ),
                                ),
                                const SizedBox(width: 8),
                                if (isCaller)
                                  _RoundAction(
                                    icon: Icons.card_giftcard_rounded,
                                    label: 'Gift',
                                    onTap: _gift,
                                  ),
                                _RoundAction(
                                  icon: Icons.emoji_emotions_outlined,
                                  label: 'React',
                                  onTap: _react,
                                ),
                                _RoundAction(
                                  icon: Icons.person_add_alt_1_rounded,
                                  label: 'Invite',
                                  onTap: () => SharePlus.instance.share(
                                    ShareParams(
                                      text:
                                          'Join "${s.title}" live on Hello Dude!',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Reactions float up over the stage.
                      for (final (i, e) in _floating.indexed)
                        Positioned(
                          right: 24.0 + (i % 3) * 22,
                          bottom: 140,
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey('$i$e${_floating.length}'),
                            tween: Tween(begin: 0, end: 1),
                            duration: const Duration(seconds: 2),
                            builder: (_, t, child) => Transform.translate(
                              offset: Offset(0, -160 * t),
                              child: Opacity(opacity: 1 - t, child: child),
                            ),
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 30),
                            ),
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

class _StageSeat extends StatelessWidget {
  const _StageSeat({
    required this.member,
    required this.speaking,
    required this.onTap,
  });
  final RoomMember member;
  final bool speaking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final host = member.role == RoomMemberRoleEnum.host;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: speaking ? AppColors.pink : Colors.transparent,
                width: 3,
              ),
            ),
            child: Avatar(
              name: member.displayName,
              avatarId: member.avatarId,
              size: 60,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            member.displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppText.body(13, weight: FontWeight.w600),
          ),
          Text(
            host ? 'Host' : 'Speaker',
            style: AppText.body(
              11.5,
              color: host ? AppColors.pinkSoft : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.card,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Icon(icon, size: 22),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            style: AppText.body(11, color: AppColors.textSecondary),
          ),
        ],
      ),
    ),
  );
}

/// Best-effort room calls (heartbeat, leave, reactions, hands): a failure is ignored.
/// `catchError((_) => null)` on a non-nullable future would throw a TypeError instead.
Future<void> _quietly(Future<Object?> f) async {
  try {
    await f;
  } catch (_) {}
}
