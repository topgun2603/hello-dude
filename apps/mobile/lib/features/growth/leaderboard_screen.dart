// Weekly leaderboards (top companions / top fans by gift coins), festival events
// and caller levels. Prizes are badges only (owner, 2026-09-25).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

typedef BoardKey = ({String board, String period, String? eventId});

final leaderboardProvider = FutureProvider.autoDispose.family<GetLeaderboard200Response, BoardKey>((ref, k) {
  final api = ref.read(apiProvider);
  return api.call(() => api.growth.getLeaderboard(k.board, period: k.period, eventId: k.eventId));
});

final currentEventProvider = FutureProvider.autoDispose<AppEvent?>((ref) async {
  final api = ref.read(apiProvider);
  return (await api.call(() => api.growth.getCurrentEvent())).event;
});

final myLevelProvider = FutureProvider.autoDispose<GetMyLevel200Response>((ref) {
  final api = ref.read(apiProvider);
  return api.call(() => api.growth.getMyLevel());
});

/// Emoji + colours per festival theme.
({String emoji, List<Color> colors}) eventTheme(String theme) => switch (theme) {
  'pongal' => (emoji: '🌾', colors: const [Color(0xFFF59E0B), Color(0xFFB45309)]),
  'diwali' => (emoji: '🪔', colors: const [Color(0xFFF97316), Color(0xFF9D174D)]),
  'onam' => (emoji: '🌼', colors: const [Color(0xFFFBBF24), Color(0xFF15803D)]),
  'holi' => (emoji: '🎨', colors: const [Color(0xFFEC4899), Color(0xFF7C3AED)]),
  'love' => (emoji: '💘', colors: const [Color(0xFFF43F5E), Color(0xFF9D174D)]),
  'cricket' => (emoji: '🏏', colors: const [Color(0xFF0EA5E9), Color(0xFF1E3A8A)]),
  _ => (emoji: '🎉', colors: const [Color(0xFF7C3AED), Color(0xFFDB2777)]),
};

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key, this.eventId});
  final String? eventId;

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _board = 'companions';
  late String _period = widget.eventId != null ? 'event' : 'this_week';

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(currentEventProvider).value;
    final eventId = widget.eventId ?? event?.id;
    final key = (board: _board, period: _period, eventId: _period == 'event' ? eventId : null);
    final data = ref.watch(leaderboardProvider(key));
    Widget chip(String label, bool on, VoidCallback onTap) => Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(label: Text(label), selected: on, onSelected: (_) => onTap()),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboards')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event != null) Padding(padding: const EdgeInsets.fromLTRB(16, 4, 16, 8), child: EventBanner(event: event, compact: true)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'companions', label: Text('Top companions')),
                ButtonSegment(value: 'fans', label: Text('Top fans')),
              ],
              selected: {_board},
              onSelectionChanged: (s) => setState(() => _board = s.first),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                chip('This week', _period == 'this_week', () => setState(() => _period = 'this_week')),
                chip('Last week', _period == 'last_week', () => setState(() => _period = 'last_week')),
                if (eventId != null) chip(event?.name ?? 'Event', _period == 'event', () => setState(() => _period = 'event')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 2, 16, 6),
            child: Text(
              _board == 'companions'
                  ? 'Ranked by gift coins received. The top 10 each week get a badge on their card.'
                  : 'Ranked by gift coins sent. The top 10 fans each week get a badge.',
              style: AppText.body(12.5, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: data.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Couldn't load the leaderboard", style: AppText.body(14))),
              data: (d) => d.items.isEmpty
                  ? Center(child: Text('No gifts yet — be the first!', style: AppText.body(14, color: AppColors.textSecondary)))
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                      children: [
                        for (final e in d.items) LeaderboardRow(entry: e),
                        if (d.me != null && d.items.every((i) => i.user.id != d.me!.user.id)) ...[
                          const Divider(color: AppColors.cardBorder),
                          LeaderboardRow(entry: d.me!, me: true),
                        ],
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardRow extends StatelessWidget {
  const LeaderboardRow({super.key, required this.entry, this.me = false});
  final LeaderboardEntry entry;
  final bool me;

  @override
  Widget build(BuildContext context) {
    final medal = switch (entry.rank) { 1 => '🥇', 2 => '🥈', 3 => '🥉', _ => null };
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: me ? const Color(0x337C3AED) : AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 34,
            child: medal != null
                ? Text(medal, style: const TextStyle(fontSize: 22))
                : Text('#${entry.rank}', style: AppText.body(14, weight: FontWeight.w800, color: AppColors.textSecondary)),
          ),
          Avatar(name: entry.user.displayName, avatarId: entry.user.avatarId, photoUrl: entry.user.photoUrl, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Text(me ? '${entry.user.displayName} (you)' : entry.user.displayName,
                style: AppText.body(15, weight: FontWeight.w700), overflow: TextOverflow.ellipsis),
          ),
          Text('🪙 ${entry.score}', style: AppText.body(14, weight: FontWeight.w800, color: AppColors.warning)),
        ],
      ),
    );
  }
}

/// Festival event banner (Home and the leaderboard).
class EventBanner extends StatelessWidget {
  const EventBanner({super.key, required this.event, this.compact = false});
  final AppEvent event;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = eventTheme(event.theme);
    final left = event.endsAt.difference(DateTime.now());
    final ends = left.inDays >= 1 ? '${left.inDays}d left' : '${left.inHours.clamp(0, 23)}h left';
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: compact ? null : () => context.push('/leaderboards?event=${event.id}'),
      child: Container(
        padding: EdgeInsets.all(compact ? 12 : 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: t.colors),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(t.emoji, style: TextStyle(fontSize: compact ? 28 : 36)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.name, style: AppText.heading(compact ? 15 : 17)),
                  if (event.tagline != null && event.tagline!.isNotEmpty)
                    Text(event.tagline!, style: AppText.body(12.5), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(compact ? ends : '$ends · see the leaderboard', style: AppText.body(12, weight: FontWeight.w700)),
                ],
              ),
            ),
            if (!compact) const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Home: the current festival event, if any.
class CurrentEventBanner extends ConsumerWidget {
  const CurrentEventBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = ref.watch(currentEventProvider).value;
    if (e == null) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: EventBanner(event: e));
  }
}

/// Small badge chip ("#1 companion this week", "PK winner").
class BadgeChip extends StatelessWidget {
  const BadgeChip({super.key, required this.badge});
  final UserBadge badge;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      gradient: const LinearGradient(colors: [Color(0xFFFDE68A), Color(0xFFD97706)]),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      '${badge.kind == 'pk_win' ? '⚡' : '🏆'} ${badge.label}',
      style: AppText.body(11, weight: FontWeight.w800, color: const Color(0xFF3B2300)),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

/// Profile (callers): level, progress to the next one.
class CallerLevelCard extends ConsumerWidget {
  const CallerLevelCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = ref.watch(myLevelProvider).value;
    if (l == null) return const SizedBox.shrink();
    final next = l.next;
    final progress = next == null ? 1.0 : (l.coinsSpent / next.minCoins).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(gradient: AppColors.brand, borderRadius: BorderRadius.circular(999)),
                child: Text('Lv ${l.level}', style: AppText.body(13, weight: FontWeight.w800)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(l.name, style: AppText.heading(17))),
              TextButton(onPressed: () => context.push('/leaderboards'), child: const Text('Leaderboards')),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: Colors.white12),
          ),
          const SizedBox(height: 6),
          Text(
            next == null
                ? 'Top level — ${l.coinsSpent} coins spent'
                : '${next.minCoins - l.coinsSpent} more coins to ${next.name} (Lv ${next.level})',
            style: AppText.body(12.5, color: AppColors.textSecondary),
          ),
          if (l.perk != null) Text(l.perk!, style: AppText.body(12.5, color: AppColors.lilac)),
        ],
      ),
    );
  }
}
