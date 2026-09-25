import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/ids.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../call/start_call.dart';

final chatsProvider = FutureProvider.autoDispose<ListChats200Response>((ref) {
  final api = ref.read(apiProvider);
  return api.call(() => api.chat.listChats());
});

/// Companions: message requests waiting for an answer. Callers: the ones they sent.
final chatRequestsProvider = FutureProvider.autoDispose<List<ChatRequest>>((
  ref,
) async {
  final api = ref.read(apiProvider);
  return (await api.call(() => api.chat.listChatRequests())).items;
});

/// Unread messages across all chats, for the chat icon badge. Bumped live.
class ChatUnread extends Notifier<int> {
  StreamSubscription<Map<String, dynamic>>? _sub;

  @override
  int build() {
    final signedIn = ref.watch(
      sessionProvider.select((s) => s.status == SessionStatus.signedIn),
    );
    _sub?.cancel();
    if (!signedIn) return 0;
    _sub = ref
        .read(realtimeProvider)
        .events
        .where((e) => e['t'] == 'chat_message')
        .listen((_) => refresh());
    ref.onDispose(() => _sub?.cancel());
    Future.microtask(refresh);
    return 0;
  }

  Future<void> refresh() async {
    final api = ref.read(apiProvider);
    try {
      state = (await api.call(() => api.chat.listChats())).unread;
    } catch (_) {}
  }
}

final chatUnreadProvider = NotifierProvider<ChatUnread, int>(ChatUnread.new);

/// Opens (or starts) the chat with someone. A caller who hasn't called her yet
/// gets the message-request box instead; otherwise explains why not.
Future<void> openChatWith(
  BuildContext context,
  WidgetRef ref,
  String userId, {
  String? name,
}) async {
  final api = ref.read(apiProvider);
  try {
    final c = await api.call(() => api.chat.openChat(userId));
    if (context.mounted) await context.push('/chat/${c.id}', extra: c);
  } catch (e) {
    if (!context.mounted) return;
    if (errorCode(e) == 'CHAT_NEEDS_REQUEST') {
      await showChatRequestSheet(context, ref, userId, name ?? 'her');
      return;
    }
    showError(context, switch (errorCode(e)) {
      'CHAT_NEEDS_CALL' =>
        'You can message someone after your first call together.',
      'CHAT_BLOCKED' => "You can't message this person.",
      _ => friendlyError(e),
    });
  }
}

/// One message to a companion you haven't called yet; she accepts or declines.
Future<void> showChatRequestSheet(
  BuildContext context,
  WidgetRef ref,
  String companionId,
  String name,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  backgroundColor: const Color(0xFF16142C),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  ),
  builder: (_) => _RequestSheet(companionId: companionId, name: name),
);

class _RequestSheet extends ConsumerStatefulWidget {
  const _RequestSheet({required this.companionId, required this.name});
  final String companionId, name;

  @override
  ConsumerState<_RequestSheet> createState() => _RequestSheetState();
}

class _RequestSheetState extends ConsumerState<_RequestSheet> {
  final _text = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _busy = true);
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.chat.sendChatRequest(
          SendChatRequestRequest(
            companionId: widget.companionId,
            body: _text.text.trim(),
          ),
        ),
      );
      ref.invalidate(chatRequestsProvider);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Request sent. We'll tell you when ${widget.name} accepts.",
          ),
        ),
      );
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
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
          Text('Message ${widget.name}', style: AppText.heading(20)),
          const SizedBox(height: 6),
          Text(
            "You haven't talked yet, so this goes as a request. If ${widget.name} accepts, the chat opens. "
            'Keep it friendly — numbers, UPI and other apps are blocked.',
            style: AppText.body(
              13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _text,
            maxLength: 300,
            maxLines: 3,
            minLines: 2,
            autofocus: true,
            style: AppText.body(15),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Say hello and why you\'d like to talk…',
              filled: true,
              fillColor: AppColors.card,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 8),
          GradientButton(
            label: _busy ? 'Sending…' : 'Send request',
            loading: _busy,
            onPressed: _text.text.trim().isEmpty || _busy ? null : _send,
          ),
        ],
      ),
    ),
  );
}

/// Top of Messages: requests to answer (companions) or sent (callers).
class _RequestsSection extends ConsumerStatefulWidget {
  const _RequestsSection();

  @override
  ConsumerState<_RequestsSection> createState() => _RequestsSectionState();
}

class _RequestsSectionState extends ConsumerState<_RequestsSection> {
  bool _all = false;
  final _busy = <String>{};

  Future<void> _answer(ChatRequest r, bool accept) async {
    setState(() => _busy.add(r.id));
    final api = ref.read(apiProvider);
    try {
      if (accept) {
        final c = await api.call(() => api.chat.acceptChatRequest(r.id));
        ref.invalidate(chatRequestsProvider);
        ref.invalidate(chatsProvider);
        if (mounted) await context.push('/chat/${c.id}', extra: c);
      } else {
        await api.send(() => api.chat.declineChatRequest(r.id));
        ref.invalidate(chatRequestsProvider);
      }
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy.remove(r.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final companion =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.companion;
    final all = ref.watch(chatRequestsProvider).valueOrNull ?? const [];
    // Callers only need to see what's still waiting or was just answered.
    final items = companion
        ? all
        : all.where((r) => r.status != ChatRequestStatusEnum.accepted).toList();
    if (items.isEmpty) return const SizedBox.shrink();
    final shown = _all ? items : items.take(3).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            companion ? 'Message requests · ${items.length}' : 'Your requests',
            style: AppText.heading(15),
          ),
          const SizedBox(height: 8),
          for (final r in shown)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Avatar(
                        name: r.other.displayName,
                        avatarId: r.other.avatarId,
                        size: 34,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          r.other.displayName,
                          style: AppText.body(15, weight: FontWeight.w700),
                        ),
                      ),
                      if (!companion)
                        Text(
                          r.status == ChatRequestStatusEnum.pending
                              ? 'Waiting'
                              : 'Not accepted',
                          style: AppText.body(
                            12.5,
                            color: r.status == ChatRequestStatusEnum.pending
                                ? AppColors.warning
                                : AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r.body,
                    style: AppText.body(
                      14,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  if (companion) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _busy.contains(r.id)
                                ? null
                                : () => _answer(r, false),
                            child: const Text('Decline'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                            ),
                            onPressed: _busy.contains(r.id)
                                ? null
                                : () => _answer(r, true),
                            child: const Text('Accept'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          if (items.length > 3 && !_all)
            TextButton(
              onPressed: () => setState(() => _all = true),
              child: Text('Show all ${items.length}'),
            ),
        ],
      ),
    );
  }
}

/// Chat icon with an unread badge, for headers.
class ChatButton extends ConsumerWidget {
  const ChatButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(chatUnreadProvider);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleIconButton(
          icon: Icons.chat_bubble_outline_rounded,
          tooltip: unread > 0 ? 'Messages, $unread unread' : 'Messages',
          onPressed: () => context.push('/chats'),
        ),
        if (unread > 0)
          Positioned(
            right: -2,
            top: -2,
            child: IgnorePointer(
              child: Container(
                constraints: const BoxConstraints(minWidth: 18),
                height: 18,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.pink,
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: Text(
                  unread > 9 ? '9+' : '$unread',
                  style: AppText.body(10, weight: FontWeight.w800),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Messages: everyone you've chatted with.
class ChatsScreen extends ConsumerWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(chatsProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Messages', style: AppText.heading(22)),
                    ),
                  ],
                ),
              ),
              const _RequestsSection(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(chatsProvider);
                    ref.invalidate(chatRequestsProvider);
                  },
                  child: list.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => ListView(
                      children: [
                        const SizedBox(height: 80),
                        Text(
                          friendlyError(e),
                          textAlign: TextAlign.center,
                          style: AppText.body(15),
                        ),
                      ],
                    ),
                    data: (d) => d.items.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 90),
                              const Icon(
                                Icons.chat_bubble_outline_rounded,
                                size: 52,
                                color: AppColors.hint,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No messages yet',
                                textAlign: TextAlign.center,
                                style: AppText.heading(18),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'After a call — or when she accepts your message request — you can talk here.',
                                textAlign: TextAlign.center,
                                style: AppText.body(
                                  14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                            itemCount: d.items.length,
                            separatorBuilder: (_, _) => const Divider(
                              height: 1,
                              color: AppColors.cardBorder,
                            ),
                            itemBuilder: (context, i) {
                              final c = d.items[i];
                              return ListTile(
                                onTap: () async {
                                  await context.push('/chat/${c.id}', extra: c);
                                  ref.invalidate(chatsProvider);
                                  ref
                                      .read(chatUnreadProvider.notifier)
                                      .refresh();
                                },
                                leading: Avatar(
                                  name: c.other.displayName,
                                  avatarId: c.other.avatarId,
                                  statusColor: c.other.online
                                      ? AppColors.success
                                      : null,
                                ),
                                title: Text(
                                  c.other.displayName,
                                  style: AppText.body(
                                    16,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  c.lastMessage ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppText.body(
                                    13.5,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                trailing: c.unread > 0
                                    ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.pink,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${c.unread}',
                                          style: AppText.body(
                                            12,
                                            weight: FontWeight.w800,
                                          ),
                                        ),
                                      )
                                    : null,
                              );
                            },
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Design: Chat.dc.html — safety banner, day dividers, bubbles, call entries, composer.
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    this.conversation,
  });
  final String conversationId;
  final Conversation? conversation;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _input = TextEditingController();
  final _items = <ChatItem>[];
  Conversation? _conv;
  bool _loading = true, _sending = false, _canMessage = true;
  String? _error;
  StreamSubscription<Map<String, dynamic>>? _live;

  @override
  void initState() {
    super.initState();
    _conv = widget.conversation;
    _load();
    _live = ref
        .read(realtimeProvider)
        .events
        .where(
          (e) =>
              e['t'] == 'chat_message' &&
              e['conversationId'] == widget.conversationId,
        )
        .listen((e) {
          final m = (e['message'] as Map).cast<String, dynamic>();
          final id = '${m['id']}';
          if (_items.any(
            (i) => i.kind == ChatItemKindEnum.message && i.id == id,
          ))
            return;
          setState(
            () => _items.insert(
              0,
              ChatItem(
                kind: ChatItemKindEnum.message,
                id: id,
                senderId: m['senderId'] as String?,
                body: m['body'] as String?,
                callType: null,
                callMinutes: null,
                at: DateTime.parse(m['createdAt'] as String),
              ),
            ),
          );
          _markRead();
        });
  }

  @override
  void dispose() {
    _live?.cancel();
    _input.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final api = ref.read(apiProvider);
    try {
      if (_conv == null) {
        final all = await api.call(() => api.chat.listChats());
        _conv = all.items
            .where((c) => c.id == widget.conversationId)
            .firstOrNull;
      }
      final r = await api.call(
        () => api.chat.getChatMessages(widget.conversationId, limit: 100),
      );
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(r.items);
        _canMessage = r.canMessage;
        _loading = false;
      });
      _markRead();
    } catch (e) {
      if (mounted)
        setState(() {
          _loading = false;
          _error = friendlyError(e);
        });
    }
  }

  Future<void> _markRead() async {
    final api = ref.read(apiProvider);
    try {
      await api.send(() => api.chat.markChatRead(widget.conversationId));
      ref.read(chatUnreadProvider.notifier).refresh();
    } catch (_) {}
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    final api = ref.read(apiProvider);
    try {
      final item = await api.call(
        () => api.chat.sendChatMessage(
          widget.conversationId,
          SendChatMessageRequest(body: text, clientRef: uuidV4()),
        ),
      );
      if (!mounted) return;
      _input.clear();
      setState(() => _items.insert(0, item));
    } catch (e) {
      if (mounted) {
        showError(
          context,
          friendlyError(e),
        ); // MESSAGE_BLOCKED carries a friendly reason
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _report() async {
    final other = _conv?.other;
    if (other == null) return;
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
                'Report ${other.displayName}',
                style: AppText.heading(18),
              ),
            ),
            for (final (r, label) in const [
              (
                ReportUserRequestReasonEnum.offPlatform,
                'Asked for my number / to pay outside the app',
              ),
              (ReportUserRequestReasonEnum.abuse, 'Abusive or rude'),
              (ReportUserRequestReasonEnum.sexualContent, 'Sexual messages'),
              (ReportUserRequestReasonEnum.fraud, 'Asking for money'),
              (ReportUserRequestReasonEnum.spam, 'Spam or selling'),
              (ReportUserRequestReasonEnum.other, 'Something else'),
            ])
              ListTile(title: Text(label), onTap: () => Navigator.pop(ctx, r)),
          ],
        ),
      ),
    );
    if (reason == null || !mounted) return;
    final api = ref.read(apiProvider);
    try {
      await api.call(
        () => api.safety.reportUser(
          ReportUserRequest(userId: other.id, reason: reason, alsoBlock: true),
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Thanks — we'll review it. They can't message you now.",
          ),
        ),
      );
      ref.invalidate(chatsProvider);
      context.pop();
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _block() async {
    final other = _conv?.other;
    if (other == null) return;
    final api = ref.read(apiProvider);
    try {
      await api.send(
        () => api.safety.blockUser(BlockUserRequest(userId: other.id)),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Blocked ${other.displayName}')));
      ref.invalidate(chatsProvider);
      context.pop();
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  Future<void> _call(bool video) async {
    final other = _conv?.other;
    if (other == null) return;
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(() => api.companions.getCompanion(other.id));
      if (!mounted) return;
      if (!r.online || r.companion.busy) {
        showError(
          context,
          r.online
              ? '${other.displayName} is on another call.'
              : '${other.displayName} is offline right now.',
        );
        return;
      }
      await startCallFlow(
        context,
        ref,
        companion: r.companion,
        language: r.companion.primaryLanguage,
        video: video,
      );
    } catch (e) {
      if (mounted) showError(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(sessionProvider).profile?.id;
    final other = _conv?.other;
    final canCall = other?.role == ConversationOtherRoleEnum.companion;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Row(
                  children: [
                    CircleIconButton(
                      icon: Icons.arrow_back_rounded,
                      tooltip: 'Back',
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(width: 10),
                    if (other != null)
                      Avatar(
                        name: other.displayName,
                        avatarId: other.avatarId,
                        size: 40,
                      ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            other?.displayName ?? 'Chat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.heading(18),
                          ),
                          if (other != null)
                            Text(
                              other.online ? 'Online' : 'Offline',
                              style: AppText.body(
                                12.5,
                                color: other.online
                                    ? const Color(0xFF6EE7B7)
                                    : AppColors.hint,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (other != null)
                      PopupMenuButton<String>(
                        tooltip: 'More',
                        icon: const Icon(Icons.more_vert_rounded),
                        onSelected: (v) => v == 'report' ? _report() : _block(),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'report', child: Text('Report')),
                          PopupMenuItem(value: 'block', child: Text('Block')),
                        ],
                      ),
                    if (canCall && other != null) ...[
                      CircleIconButton(
                        icon: Icons.call_rounded,
                        tooltip: 'Voice call ${other.displayName}',
                        onPressed: () => _call(false),
                      ),
                      const SizedBox(width: 8),
                      CircleIconButton(
                        icon: Icons.videocam_rounded,
                        tooltip: 'Video call ${other.displayName}',
                        onPressed: () => _call(true),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x1F3B82F6),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0x403B82F6)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.shield_outlined,
                      size: 18,
                      color: Color(0xFF93C5FD),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Never share phone numbers or payment details. Messages are checked for safety.',
                        style: AppText.body(
                          12.5,
                          color: const Color(0xFFBFDBFE),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!, style: AppText.body(15)))
                    : ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        itemCount: _items.length,
                        itemBuilder: (context, i) {
                          final item = _items[i];
                          final older = i + 1 < _items.length
                              ? _items[i + 1]
                              : null;
                          final newDay =
                              older == null || !_sameDay(older.at, item.at);
                          return Column(
                            children: [
                              if (newDay) _DayDivider(at: item.at),
                              item.kind == ChatItemKindEnum.call
                                  ? _CallEntry(item: item)
                                  : _Bubble(
                                      item: item,
                                      mine: item.senderId == me,
                                    ),
                            ],
                          );
                        },
                      ),
              ),
              if (_canMessage)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _input,
                          minLines: 1,
                          maxLines: 4,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.sentences,
                          style: AppText.body(15),
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: 'Message',
                            filled: true,
                            fillColor: AppColors.card,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSubmitted: (_) => _send(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Semantics(
                        button: true,
                        label: 'Send',
                        child: GestureDetector(
                          onTap: _send,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.brand,
                            ),
                            child: _sending
                                ? const Padding(
                                    padding: EdgeInsets.all(14),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "You can't message this person any more.",
                    textAlign: TextAlign.center,
                    style: AppText.body(13.5, color: AppColors.hint),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

bool _sameDay(DateTime a, DateTime b) {
  final x = a.toLocal(), y = b.toLocal();
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

String _clock(DateTime t) {
  final l = t.toLocal();
  final h = l.hour % 12 == 0 ? 12 : l.hour % 12;
  return '$h:${l.minute.toString().padLeft(2, '0')} ${l.hour < 12 ? 'AM' : 'PM'}';
}

class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.at});
  final DateTime at;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final l = at.toLocal();
    final label = _sameDay(l, now)
        ? 'Today'
        : _sameDay(l, now.subtract(const Duration(days: 1)))
        ? 'Yesterday'
        : '${l.day}/${l.month}/${l.year}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        label,
        style: AppText.body(12, color: AppColors.hint, weight: FontWeight.w600),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.item, required this.mine});
  final ChatItem item;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
          decoration: BoxDecoration(
            gradient: mine ? AppColors.brand : null,
            color: mine ? null : const Color(0xFF282448),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(mine ? 18 : 4),
              bottomRight: Radius.circular(mine ? 4 : 18),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(item.body ?? '', style: AppText.body(15)),
              const SizedBox(height: 2),
              Text(
                _clock(item.at),
                style: AppText.body(10.5, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CallEntry extends StatelessWidget {
  const _CallEntry({required this.item});
  final ChatItem item;

  @override
  Widget build(BuildContext context) {
    final video = item.callType == ChatItemCallTypeEnum.video;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                video ? Icons.videocam_rounded : Icons.call_rounded,
                size: 15,
                color: AppColors.success,
              ),
              const SizedBox(width: 6),
              Text(
                '${video ? 'Video' : 'Voice'} call · ${item.callMinutes ?? 0} min · ${_clock(item.at)}',
                style: AppText.body(12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
