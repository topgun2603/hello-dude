import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/home_data.dart' show walletProvider;
import 'history_common.dart';

enum CoinFlow { all, spent, added }

class CoinFilters {
  const CoinFilters({
    this.range = const RangeFilter(HistoryRange.month),
    this.flow = CoinFlow.all,
  });
  final RangeFilter range;
  final CoinFlow flow;
  CoinFilters copyWith({RangeFilter? range, CoinFlow? flow}) =>
      CoinFilters(range: range ?? this.range, flow: flow ?? this.flow);
}

final coinFiltersProvider = StateProvider<CoinFilters>(
  (_) => const CoinFilters(),
);

class CoinHistoryState {
  const CoinHistoryState({
    required this.items,
    required this.summary,
    required this.next,
    this.loadingMore = false,
  });
  final List<CoinHistoryItem> items;
  final CoinHistorySummary summary;
  final String? next;
  final bool loadingMore;
}

Future<GetCoinHistory200Response> _fetch(
  Ref ref,
  CoinFilters f, {
  String? cursor,
  int limit = 20,
}) {
  final (from, to) = f.range.bounds();
  final api = ref.read(apiProvider);
  return api.call(
    () => api.wallet.getCoinHistory(
      filter: f.flow == CoinFlow.all ? null : f.flow.name,
      from: from?.toUtc(),
      to: to?.toUtc(),
      cursor: cursor,
      limit: limit,
    ),
  );
}

/// The Coin history screen (filters + paging).
final coinHistoryProvider =
    AsyncNotifierProvider.autoDispose<CoinHistory, CoinHistoryState>(
      CoinHistory.new,
    );

class CoinHistory extends AutoDisposeAsyncNotifier<CoinHistoryState> {
  @override
  Future<CoinHistoryState> build() async {
    final r = await _fetch(ref, ref.watch(coinFiltersProvider));
    return CoinHistoryState(
      items: r.items,
      summary: r.summary,
      next: r.nextCursor,
    );
  }

  Future<void> loadMore() async {
    final s = state.valueOrNull;
    if (s == null || s.next == null || s.loadingMore) return;
    state = AsyncData(
      CoinHistoryState(
        items: s.items,
        summary: s.summary,
        next: s.next,
        loadingMore: true,
      ),
    );
    try {
      final r = await _fetch(
        ref,
        ref.read(coinFiltersProvider),
        cursor: s.next,
      );
      state = AsyncData(
        CoinHistoryState(
          items: [...s.items, ...r.items],
          summary: s.summary,
          next: r.nextCursor,
        ),
      );
    } catch (_) {
      state = AsyncData(
        CoinHistoryState(items: s.items, summary: s.summary, next: s.next),
      );
    }
  }
}

/// Wallet tab: the last 30 days in short.
final coinHistoryPreviewProvider =
    FutureProvider.autoDispose<GetCoinHistory200Response>((ref) {
      ref.watch(walletProvider.select((w) => w.valueOrNull?.coins));
      return _fetch(ref, const CoinFilters(), limit: 5);
    });

// ---------------------------------------------------------------------------

/// Wallet tab section: 30-day totals, the last few lines, and "See all".
class CoinHistoryPreview extends ConsumerWidget {
  const CoinHistoryPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(coinHistoryPreviewProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Coin history',
                style: AppText.heading(19, weight: FontWeight.w800),
              ),
            ),
            TextButton(
              onPressed: () => context.push('/coin-history'),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        data.when(
          skipLoadingOnRefresh: true,
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.pink),
            ),
          ),
          error: (e, _) => HistoryMessage(
            icon: Icons.wifi_off_rounded,
            title: friendlyError(e),
            action: 'Try again',
            onAction: () => ref.invalidate(coinHistoryPreviewProvider),
          ),
          data: (r) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SpendSummaryCard(r.summary, caption: 'Last 30 days'),
              const SizedBox(height: 10),
              if (r.items.isEmpty)
                const HistoryMessage(
                  icon: Icons.receipt_long_outlined,
                  title: 'Nothing yet',
                  body: 'Every coin you add or spend shows up here.',
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.cardBorder),
                  ),
                  child: Column(
                    children: [
                      for (var i = 0; i < r.items.length; i++)
                        CoinHistoryRow(
                          r.items[i],
                          showDate: true,
                          divider: i < r.items.length - 1,
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
}

/// Spent vs added, with a bar splitting what the coins were spent on.
class SpendSummaryCard extends StatelessWidget {
  const SpendSummaryCard(this.s, {super.key, required this.caption});
  final CoinHistorySummary s;
  final String caption;

  static const _calls = Color(0xFFDB2777),
      _gifts = Color(0xFFF59E0B),
      _bookings = Color(0xFF7C3AED),
      _lives = Color(0xFF0EA5E9),
      _groups = Color(0xFF10B981);

  @override
  Widget build(BuildContext context) {
    final parts = [
      (s.calls, _calls, 'Calls'),
      (s.gifts, _gifts, 'Gifts'),
      (s.lives, _lives, 'Lives'),
      (s.groups, _groups, 'Group video'),
      (s.bookings, _bookings, 'Booked calls'),
    ].where((p) => p.$1 > 0).toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withValues(alpha: 0.22),
            const Color(0xFFDB2777).withValues(alpha: 0.12),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            caption.toUpperCase(),
            style: AppText.body(
              11,
              weight: FontWeight.w800,
              color: AppColors.textSecondary,
            ).copyWith(letterSpacing: 0.8),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _Total(
                  label: 'Spent',
                  value: '−${s.spent}',
                  color: const Color(0xFFFDA4AF),
                  icon: Icons.south_east_rounded,
                ),
              ),
              Container(width: 1, height: 38, color: AppColors.cardBorder),
              const SizedBox(width: 14),
              Expanded(
                child: _Total(
                  label: 'Added',
                  value: '+${s.added}',
                  color: AppColors.success,
                  icon: Icons.north_east_rounded,
                ),
              ),
            ],
          ),
          if (parts.isNotEmpty) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: SizedBox(
                height: 8,
                child: Row(
                  children: [
                    for (final p in parts)
                      Expanded(
                        flex: p.$1,
                        child: Container(color: p.$2),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 14,
              runSpacing: 6,
              children: [
                for (final p in parts)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: p.$2,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${p.$3} ${p.$1}',
                        style: AppText.body(
                          12.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });
  final String label, value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppText.body(12.5, color: AppColors.textSecondary),
          ),
        ],
      ),
      const SizedBox(height: 2),
      FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Text('$value coins', style: AppText.heading(20, color: color)),
      ),
    ],
  );
}

/// One line: what, when, how many coins. Call lines open the call details.
class CoinHistoryRow extends StatelessWidget {
  const CoinHistoryRow(
    this.item, {
    super.key,
    this.showDate = false,
    this.divider = true,
  });
  final CoinHistoryItem item;
  final bool showDate, divider;

  static (IconData, Color) _look(CoinHistoryItem i) => switch (i.kind) {
    CoinHistoryItemKindEnum.call => (
      i.callType == CoinHistoryItemCallTypeEnum.video
          ? Icons.videocam_rounded
          : Icons.call_rounded,
      const Color(0xFFF9A8D4),
    ),
    CoinHistoryItemKindEnum.gift => (
      Icons.card_giftcard_rounded,
      const Color(0xFFFCD34D),
    ),
    CoinHistoryItemKindEnum.purchase => (
      Icons.add_rounded,
      const Color(0xFF6EE7B7),
    ),
    CoinHistoryItemKindEnum.refund => (
      Icons.undo_rounded,
      const Color(0xFF6EE7B7),
    ),
    CoinHistoryItemKindEnum.booking => (
      Icons.event_rounded,
      const Color(0xFFC4B5FD),
    ),
    CoinHistoryItemKindEnum.live => (
      Icons.live_tv_rounded,
      const Color(0xFFFDA4AF),
    ),
    CoinHistoryItemKindEnum.group => (
      Icons.groups_rounded,
      const Color(0xFF6EE7B7),
    ),
    CoinHistoryItemKindEnum.adjustment => (
      Icons.support_agent_rounded,
      const Color(0xFF93C5FD),
    ),
    _ => (Icons.redeem_rounded, const Color(0xFF93C5FD)),
  };

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _look(item);
    final at = item.at.toLocal();
    final when = showDate ? '${dayHeader(at)}, ${clock(at)}' : clock(at);
    final sub = [if (item.subtitle != null) item.subtitle!, when].join(' · ');
    final spent = item.amount < 0;
    final row = Container(
      height: 62,
      decoration: BoxDecoration(
        border: divider
            ? const Border(bottom: BorderSide(color: AppColors.cardBorder))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.16),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(14.5, weight: FontWeight.w600),
                ),
                Text(
                  sub,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body(12.5, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            spent ? '−${-item.amount}' : '+${item.amount}',
            style: AppText.heading(
              15.5,
              weight: FontWeight.w700,
              color: spent ? const Color(0xFFFDA4AF) : const Color(0xFF6EE7B7),
            ),
          ),
        ],
      ),
    );
    return Semantics(
      label:
          '${item.title}, ${spent ? 'spent' : 'added'} ${item.amount.abs()} coins, $when',
      excludeSemantics: true,
      button: item.callId != null,
      child: item.callId == null
          ? row
          : InkWell(
              onTap: () => context.push('/call-details', extra: item.callId),
              child: row,
            ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Full coin history with filters (Wallet → See all).
class CoinHistoryScreen extends ConsumerWidget {
  const CoinHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(coinFiltersProvider);
    final history = ref.watch(coinHistoryProvider);
    void set(CoinFilters v) => ref.read(coinFiltersProvider.notifier).state = v;

    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.pink,
            onRefresh: () async => ref.invalidate(coinHistoryProvider),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
                      child: Text('Coin history', style: AppText.heading(24)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SegmentedButton<CoinFlow>(
                  showSelectedIcon: false,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith(
                      (s) => s.contains(WidgetState.selected)
                          ? AppColors.pink.withValues(alpha: 0.25)
                          : AppColors.card,
                    ),
                    foregroundColor: const WidgetStatePropertyAll(Colors.white),
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColors.cardBorder),
                    ),
                  ),
                  segments: const [
                    ButtonSegment(value: CoinFlow.all, label: Text('All')),
                    ButtonSegment(value: CoinFlow.spent, label: Text('Spent')),
                    ButtonSegment(value: CoinFlow.added, label: Text('Added')),
                  ],
                  selected: {f.flow},
                  onSelectionChanged: (v) => set(f.copyWith(flow: v.first)),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilterPill(
                    icon: Icons.calendar_today_rounded,
                    label: f.range.label,
                    active: f.range.range != HistoryRange.month,
                    onTap: () async {
                      final r = await pickRange(context, f.range);
                      if (r != null) set(f.copyWith(range: r));
                    },
                  ),
                ),
                const SizedBox(height: 14),
                history.when(
                  skipLoadingOnRefresh: true,
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.pink),
                    ),
                  ),
                  error: (e, _) => HistoryMessage(
                    icon: Icons.wifi_off_rounded,
                    title: friendlyError(e),
                    action: 'Try again',
                    onAction: () => ref.invalidate(coinHistoryProvider),
                  ),
                  data: (s) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SpendSummaryCard(s.summary, caption: f.range.label),
                      if (s.items.isEmpty) ...[
                        const SizedBox(height: 14),
                        HistoryMessage(
                          icon: Icons.receipt_long_outlined,
                          title: 'Nothing in this period',
                          action: f.range.range == HistoryRange.all
                              ? null
                              : 'Show any time',
                          onAction: () => set(
                            f.copyWith(
                              range: const RangeFilter(HistoryRange.all),
                            ),
                          ),
                        ),
                      ],
                      for (final (day, items) in groupByDay(
                        s.items,
                        (i) => i.at,
                      )) ...[
                        DayHeader(day),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.cardBorder),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0; i < items.length; i++)
                                CoinHistoryRow(
                                  items[i],
                                  divider: i < items.length - 1,
                                ),
                            ],
                          ),
                        ),
                      ],
                      if (s.next != null)
                        ShowMore(
                          loading: s.loadingMore,
                          onTap: () =>
                              ref.read(coinHistoryProvider.notifier).loadMore(),
                        ),
                    ],
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
