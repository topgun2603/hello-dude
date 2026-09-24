import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/realtime.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

/// Bell badge number. Refetched on open, and bumped live by the server's
/// `notification` WebSocket event (see notifications.ts on the API).
class UnreadCount extends Notifier<int> {
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
        .where((e) => e['t'] == 'notification')
        .listen((_) => state = state + 1);
    ref.onDispose(() => _sub?.cancel());
    Future.microtask(refresh);
    return 0;
  }

  Future<void> refresh() async {
    final api = ref.read(apiProvider);
    try {
      state = (await api.call(
        () => api.notifications.unreadNotificationCount(),
      )).unread;
    } catch (_) {
      /* keep the last number */
    }
  }

  void set(int n) => state = n;
}

final unreadCountProvider = NotifierProvider<UnreadCount, int>(UnreadCount.new);

final notificationsProvider =
    FutureProvider.autoDispose<ListNotifications200Response>((ref) {
      final api = ref.read(apiProvider);
      return api.call(() => api.notifications.listNotifications(limit: 100));
    });

/// Bell with a pink unread badge, for the home headers.
class NotificationBell extends ConsumerWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadCountProvider);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleIconButton(
          icon: Icons.notifications_none_rounded,
          tooltip: unread > 0 ? 'Notifications, $unread new' : 'Notifications',
          onPressed: () => context.push('/notifications'),
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

/// Design: Notifications.dc.html — Today / Yesterday / Earlier, unread dots, "Read all".
class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  Future<void> _markRead(WidgetRef ref, List<int>? ids) async {
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(
        () => api.notifications.markNotificationsRead(
          MarkNotificationsReadRequest(ids: ids ?? [], all: ids == null),
        ),
      );
      ref.read(unreadCountProvider.notifier).set(r.unread);
      ref.invalidate(notificationsProvider);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(notificationsProvider);
    final hasUnread = (list.valueOrNull?.unread ?? 0) > 0;
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
                      child: Text('Notifications', style: AppText.heading(22)),
                    ),
                    if (hasUnread)
                      TextButton(
                        onPressed: () => _markRead(ref, null),
                        child: Text(
                          'Read all',
                          style: AppText.body(
                            14,
                            color: AppColors.pinkSoft,
                            weight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(notificationsProvider);
                    await ref.read(unreadCountProvider.notifier).refresh();
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
                    data: (data) => data.items.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 90),
                              const Icon(
                                Icons.notifications_none_rounded,
                                size: 56,
                                color: AppColors.hint,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'No notifications yet',
                                textAlign: TextAlign.center,
                                style: AppText.heading(18),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "We'll let you know when favourites come online,\nrefunds are decided and more.",
                                textAlign: TextAlign.center,
                                style: AppText.body(
                                  14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
                        : ListView(
                            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                            children: [
                              for (final (label, items) in groupByDay(
                                data.items,
                                DateTime.now(),
                              )) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 14,
                                    bottom: 6,
                                  ),
                                  child: Text(
                                    label.toUpperCase(),
                                    style: AppText.body(
                                      12,
                                      color: AppColors.hint,
                                      weight: FontWeight.w700,
                                    ).copyWith(letterSpacing: 1.2),
                                  ),
                                ),
                                for (final n in items)
                                  _Row(
                                    item: n,
                                    onTap: () {
                                      if (!n.read) _markRead(ref, [n.id]);
                                      openNotification(context, n);
                                    },
                                  ),
                              ],
                            ],
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

/// Where a tap goes. Types without a screen just mark the item read.
void openNotification(BuildContext context, NotificationItem n) {
  switch (n.type) {
    case NotificationItemTypeEnum.favouriteOnline:
      context.push('/favourites');
    case NotificationItemTypeEnum.bookingRequested:
    case NotificationItemTypeEnum.bookingConfirmed:
    case NotificationItemTypeEnum.bookingCancelled:
    case NotificationItemTypeEnum.bookingReminder:
      context.push('/bookings');
    case NotificationItemTypeEnum.roomLive:
      final roomId = n.data['roomId'];
      context.push(roomId != null ? '/room/$roomId' : '/rooms');
    case NotificationItemTypeEnum.liveStarted:
      context.push('/live', extra: n.data['liveId']);
    case NotificationItemTypeEnum.groupOpen:
    case NotificationItemTypeEnum.groupReminder:
    case NotificationItemTypeEnum.groupCancelled:
      // Companions manage their groups from their home; callers see the list.
      final companion = ProviderScope.containerOf(context).read(sessionProvider).profile?.role == ProfileRoleEnum.companion;
      context.push(companion ? '/companion' : '/groups');
    case NotificationItemTypeEnum.bonusEarned:
      context.push('/rewards');
    case NotificationItemTypeEnum.vip:
      context.push('/vip');
    case NotificationItemTypeEnum.dailyBonus:
      context.push('/checkin');
    case NotificationItemTypeEnum.referralJoined:
    case NotificationItemTypeEnum.referralRewarded:
      context.push('/referral');
    case NotificationItemTypeEnum.refundDecided:
    case NotificationItemTypeEnum.rateCall:
      final callId = n.data['callId'];
      if (callId != null) context.push('/call-details', extra: callId);
    default:
      break;
  }
}

/// "Today" / "Yesterday" / "Earlier" groups, keeping the server's newest-first order.
List<(String, List<NotificationItem>)> groupByDay(
  List<NotificationItem> items,
  DateTime now,
) {
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final groups = <String, List<NotificationItem>>{};
  for (final n in items) {
    final t = n.createdAt.toLocal();
    final label = !t.isBefore(today)
        ? 'Today'
        : !t.isBefore(yesterday)
        ? 'Yesterday'
        : 'Earlier';
    groups.putIfAbsent(label, () => []).add(n);
  }
  return [for (final e in groups.entries) (e.key, e.value)];
}

/// "2 min", "3 h" today; "9:40 PM" yesterday; "12 Sep" before that.
String timeLabel(DateTime created, DateTime now) {
  final t = created.toLocal();
  final d = now.difference(t);
  final today = DateTime(now.year, now.month, now.day);
  if (!t.isBefore(today)) {
    if (d.inMinutes < 1) return 'now';
    if (d.inMinutes < 60) return '${d.inMinutes} min';
    return '${d.inHours} h';
  }
  final h = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final clock =
      '$h:${t.minute.toString().padLeft(2, '0')} ${t.hour < 12 ? 'AM' : 'PM'}';
  if (!t.isBefore(today.subtract(const Duration(days: 1)))) return clock;
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${t.day} ${months[t.month - 1]}';
}

(IconData, Color) _iconFor(NotificationItemTypeEnum type) => switch (type) {
  NotificationItemTypeEnum.favouriteOnline => (
    Icons.favorite_rounded,
    AppColors.pink,
  ),
  NotificationItemTypeEnum.bookingRequested ||
  NotificationItemTypeEnum.bookingConfirmed ||
  NotificationItemTypeEnum.bookingCancelled ||
  NotificationItemTypeEnum.bookingReminder => (
    Icons.event_available_rounded,
    AppColors.lilac,
  ),
  NotificationItemTypeEnum.refundDecided => (
    Icons.undo_rounded,
    AppColors.success,
  ),
  NotificationItemTypeEnum.dailyBonus => (
    Icons.local_fire_department_rounded,
    AppColors.warning,
  ),
  NotificationItemTypeEnum.rateCall => (Icons.star_rounded, Color(0xFFFACC15)),
  NotificationItemTypeEnum.referralJoined ||
  NotificationItemTypeEnum.referralRewarded => (
    Icons.card_giftcard_rounded,
    Color(0xFF60A5FA),
  ),
  NotificationItemTypeEnum.reportActioned => (
    Icons.shield_outlined,
    Color(0xFF7DD3FC),
  ),
  NotificationItemTypeEnum.supportCoins ||
  NotificationItemTypeEnum.bonusEarned => (
    Icons.toll_rounded,
    AppColors.warning,
  ),
  NotificationItemTypeEnum.payoutPaid => (
    Icons.account_balance_wallet_rounded,
    AppColors.success,
  ),
  NotificationItemTypeEnum.payoutFailed => (
    Icons.error_outline_rounded,
    AppColors.danger,
  ),
  NotificationItemTypeEnum.kycDecided => (
    Icons.verified_user_outlined,
    AppColors.success,
  ),
  NotificationItemTypeEnum.vip => (
    Icons.workspace_premium_rounded,
    Color(0xFFFDE68A),
  ),
  NotificationItemTypeEnum.chatMessage => (
    Icons.chat_bubble_outline_rounded,
    AppColors.lilac,
  ),
  NotificationItemTypeEnum.roomLive => (
    Icons.graphic_eq_rounded,
    AppColors.pink,
  ),
  NotificationItemTypeEnum.groupOpen ||
  NotificationItemTypeEnum.groupReminder ||
  NotificationItemTypeEnum.groupCancelled => (
    Icons.groups_rounded,
    AppColors.success,
  ),
  NotificationItemTypeEnum.liveStarted => (
    Icons.live_tv_rounded,
    AppColors.danger,
  ),
  _ => (Icons.campaign_outlined, AppColors.pinkSoft),
};

class _Row extends StatelessWidget {
  const _Row({required this.item, required this.onTap});
  final NotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _iconFor(item.type);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(
                      15,
                      weight: item.read ? FontWeight.w500 : FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.body} · ${timeLabel(item.createdAt, DateTime.now())}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body(13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (item.type == NotificationItemTypeEnum.favouriteOnline) ...[
              const SizedBox(width: 8),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: AppColors.brand,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Text(
                    'Call',
                    style: AppText.body(13, weight: FontWeight.w700),
                  ),
                ),
              ),
            ],
            if (!item.read) ...[
              const SizedBox(width: 10),
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.pink,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
