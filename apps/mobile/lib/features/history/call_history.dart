import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../companion/companion_data.dart' show rupees, talkTime;
import 'history_common.dart';

/// "45s", "3m 20s", "1h 5m" — a single call's length.
String callLength(int secs) {
  if (secs < 60) return '${secs}s';
  if (secs < 3600)
    return '${secs ~/ 60}m ${(secs % 60).toString().padLeft(2, '0')}s';
  return talkTime(secs);
}

enum CallTypeFilter { all, voice, video }

enum CallOutcomeFilter { all, connected, missed }

class CallFilters {
  const CallFilters({
    this.range = const RangeFilter(HistoryRange.all),
    this.type = CallTypeFilter.all,
    this.outcome = CallOutcomeFilter.all,
  });
  final RangeFilter range;
  final CallTypeFilter type;
  final CallOutcomeFilter outcome;

  bool get isFiltered =>
      range.range != HistoryRange.all ||
      type != CallTypeFilter.all ||
      outcome != CallOutcomeFilter.all;

  CallFilters copyWith({
    RangeFilter? range,
    CallTypeFilter? type,
    CallOutcomeFilter? outcome,
  }) => CallFilters(
    range: range ?? this.range,
    type: type ?? this.type,
    outcome: outcome ?? this.outcome,
  );
}

final callFiltersProvider = StateProvider<CallFilters>(
  (_) => const CallFilters(),
);

class CallHistoryState {
  const CallHistoryState({
    required this.calls,
    required this.summary,
    required this.nextBefore,
    this.loadingMore = false,
  });
  final List<CallSummary> calls;
  final CallHistorySummary summary;
  final DateTime? nextBefore;
  final bool loadingMore;
}

/// Call history for the current filters; `ref.invalidate(callHistoryProvider)`
/// reloads the first page (e.g. after a call ends).
final callHistoryProvider =
    AsyncNotifierProvider.autoDispose<CallHistory, CallHistoryState>(
      CallHistory.new,
    );

class CallHistory extends AutoDisposeAsyncNotifier<CallHistoryState> {
  Future<ListCalls200Response> _page(DateTime? before) {
    final f = ref.read(callFiltersProvider);
    final (from, to) = f.range.bounds();
    final api = ref.read(apiProvider);
    return api.call(
      () => api.calls.listCalls(
        before: before?.toUtc(),
        limit: 20,
        type: switch (f.type) {
          CallTypeFilter.voice => 'audio',
          CallTypeFilter.video => 'video',
          _ => null,
        },
        outcome: f.outcome == CallOutcomeFilter.all ? null : f.outcome.name,
        from: from?.toUtc(),
        to: to?.toUtc(),
      ),
    );
  }

  @override
  Future<CallHistoryState> build() async {
    ref.watch(callFiltersProvider);
    final r = await _page(null);
    return CallHistoryState(
      calls: r.calls,
      summary: r.summary,
      nextBefore: r.nextBefore,
    );
  }

  Future<void> loadMore() async {
    final s = state.valueOrNull;
    if (s == null || s.nextBefore == null || s.loadingMore) return;
    state = AsyncData(
      CallHistoryState(
        calls: s.calls,
        summary: s.summary,
        nextBefore: s.nextBefore,
        loadingMore: true,
      ),
    );
    try {
      final r = await _page(s.nextBefore);
      state = AsyncData(
        CallHistoryState(
          calls: [...s.calls, ...r.calls],
          summary: s.summary,
          nextBefore: r.nextBefore,
        ),
      );
    } catch (_) {
      state = AsyncData(
        CallHistoryState(
          calls: s.calls,
          summary: s.summary,
          nextBefore: s.nextBefore,
        ),
      );
    }
  }
}

/// Filters, totals and the day-grouped list. Used by the caller Calls tab and
/// the companion's "All calls" screen.
class CallHistoryBody extends ConsumerWidget {
  const CallHistoryBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final f = ref.watch(callFiltersProvider);
    final history = ref.watch(callHistoryProvider);
    final isCompanion =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.companion;
    void set(CallFilters v) => ref.read(callFiltersProvider.notifier).state = v;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              FilterPill(
                icon: Icons.calendar_today_rounded,
                label: f.range.label,
                active: f.range.range != HistoryRange.all,
                onTap: () async {
                  final r = await pickRange(context, f.range);
                  if (r != null) set(f.copyWith(range: r));
                },
              ),
              FilterPill(
                icon: switch (f.type) {
                  CallTypeFilter.video => Icons.videocam_rounded,
                  CallTypeFilter.voice => Icons.call_rounded,
                  _ => Icons.tune_rounded,
                },
                label: switch (f.type) {
                  CallTypeFilter.all => 'Voice & video',
                  CallTypeFilter.voice => 'Voice',
                  CallTypeFilter.video => 'Video',
                },
                active: f.type != CallTypeFilter.all,
                onTap: () async {
                  final t = await pickOne(
                    context,
                    title: 'Call type',
                    current: f.type,
                    options: const [
                      (CallTypeFilter.all, 'Voice & video', Icons.tune_rounded),
                      (CallTypeFilter.voice, 'Voice calls', Icons.call_rounded),
                      (
                        CallTypeFilter.video,
                        'Video calls',
                        Icons.videocam_rounded,
                      ),
                    ],
                  );
                  if (t != null) set(f.copyWith(type: t));
                },
              ),
              FilterPill(
                icon: f.outcome == CallOutcomeFilter.missed
                    ? Icons.call_missed_rounded
                    : Icons.call_made_rounded,
                label: switch (f.outcome) {
                  CallOutcomeFilter.all => 'All calls',
                  CallOutcomeFilter.connected => 'Connected',
                  CallOutcomeFilter.missed => 'Missed',
                },
                active: f.outcome != CallOutcomeFilter.all,
                onTap: () async {
                  final o = await pickOne(
                    context,
                    title: 'Show',
                    current: f.outcome,
                    options: const [
                      (CallOutcomeFilter.all, 'All calls', Icons.list_rounded),
                      (
                        CallOutcomeFilter.connected,
                        'Connected',
                        Icons.call_made_rounded,
                      ),
                      (
                        CallOutcomeFilter.missed,
                        'Missed or declined',
                        Icons.call_missed_rounded,
                      ),
                    ],
                  );
                  if (o != null) set(f.copyWith(outcome: o));
                },
              ),
            ],
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
            onAction: () => ref.invalidate(callHistoryProvider),
          ),
          data: (s) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CallSummaryCard(s.summary, companion: isCompanion),
              if (s.calls.isEmpty) ...[
                const SizedBox(height: 14),
                f.isFiltered
                    ? HistoryMessage(
                        icon: Icons.search_off_rounded,
                        title: 'No calls match these filters',
                        action: 'Clear filters',
                        onAction: () => set(const CallFilters()),
                      )
                    : const HistoryMessage(
                        icon: Icons.history_rounded,
                        title: 'No calls yet',
                        body:
                            'Every call and every coin it used will show up here, minute by minute.',
                      ),
              ],
              for (final (day, calls) in groupByDay(
                s.calls,
                (c) => c.createdAt,
              )) ...[
                DayHeader(
                  day,
                  trailing: calls.length == 1
                      ? '1 call'
                      : '${calls.length} calls',
                ),
                for (final c in calls)
                  CallHistoryRow(c, companion: isCompanion),
              ],
              if (s.nextBefore != null)
                ShowMore(
                  loading: s.loadingMore,
                  onTap: () =>
                      ref.read(callHistoryProvider.notifier).loadMore(),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CallSummaryCard extends StatelessWidget {
  const _CallSummaryCard(this.s, {required this.companion});
  final CallHistorySummary s;
  final bool companion;

  @override
  Widget build(BuildContext context) {
    Widget stat(String label, String value, {Color? color}) => Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppText.heading(20, color: color ?? Colors.white),
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppText.body(12, color: AppColors.textSecondary)),
        ],
      ),
    );
    Widget divider() =>
        Container(width: 1, height: 34, color: AppColors.cardBorder);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF7C3AED).withValues(alpha: 0.22),
            const Color(0xFFDB2777).withValues(alpha: 0.14),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          stat('Calls', '${s.connected}/${s.calls}'),
          divider(),
          stat('Talk time', talkTime(s.talkSeconds)),
          divider(),
          companion
              ? stat(
                  'Earned',
                  rupees(s.paiseEarned),
                  color: const Color(0xFF6EE7B7),
                )
              : stat(
                  'Coins spent',
                  '${s.coinsSpent}',
                  color: const Color(0xFFFCD34D),
                ),
          if (s.missed > 0) ...[
            divider(),
            stat('Missed', '${s.missed}', color: const Color(0xFFFDA4AF)),
          ],
        ],
      ),
    );
  }
}

/// One call: who, type, outcome, length, time; coins (caller) or earnings (companion).
class CallHistoryRow extends StatelessWidget {
  const CallHistoryRow(this.c, {super.key, required this.companion});
  final CallSummary c;
  final bool companion;

  @override
  Widget build(BuildContext context) {
    final connected = c.startedAt != null;
    final video = c.type == CallSummaryTypeEnum.video;
    final status = connected
        ? (c.durationSeconds == null ? '' : callLength(c.durationSeconds!))
        : switch (c.status) {
            CallSummaryStatusEnum.missed => 'Missed',
            CallSummaryStatusEnum.rejected => 'Declined',
            CallSummaryStatusEnum.failed => 'Failed',
            CallSummaryStatusEnum.ringing => 'Ringing',
            _ => 'Not connected',
          };
    final coins = c.coinsCharged - c.coinsRefunded;
    final amount = companion
        ? (c.paiseEarned > 0 ? '+${rupees(c.paiseEarned)}' : null)
        : (coins > 0 ? '−$coins' : null);
    final outgoing = c.direction == CallSummaryDirectionEnum.outgoing;

    return Semantics(
      button: true,
      label:
          '${video ? 'Video' : 'Voice'} call with ${c.other.displayName}, ${clock(c.createdAt.toLocal())}, $status',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push('/call-details', extra: c.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Avatar(
                    name: c.other.displayName,
                    avatarId: c.other.avatarId,
                    size: 44,
                  ),
                  Positioned(
                    right: -3,
                    bottom: -3,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: connected
                            ? const Color(0xFF7C3AED)
                            : const Color(0xFF9F1239),
                        border: Border.all(
                          color: const Color(0xFF16142C),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        video ? Icons.videocam_rounded : Icons.call_rounded,
                        size: 11,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      c.other.displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(15, weight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          connected
                              ? (outgoing
                                    ? Icons.call_made_rounded
                                    : Icons.call_received_rounded)
                              : Icons.call_missed_rounded,
                          size: 14,
                          color: connected
                              ? AppColors.textSecondary
                              : const Color(0xFFFDA4AF),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${video ? 'Video' : 'Voice'} · ${status.isEmpty ? 'Ended' : status} · ${clock(c.createdAt.toLocal())}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppText.body(
                              12.5,
                              color: connected
                                  ? AppColors.textSecondary
                                  : const Color(0xFFFDA4AF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (amount != null) ...[
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      amount,
                      style: AppText.body(
                        15,
                        weight: FontWeight.w800,
                        color: companion
                            ? const Color(0xFF6EE7B7)
                            : Colors.white,
                      ),
                    ),
                    if (!companion && c.coinsRefunded > 0)
                      Text(
                        '${c.coinsRefunded} refunded',
                        style: AppText.body(11, color: AppColors.success),
                      ),
                    if (!companion && c.coinsRefunded == 0)
                      Text(
                        'coins',
                        style: AppText.body(11, color: AppColors.hint),
                      ),
                  ],
                ),
              ],
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.hint,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Companion: all calls with filters (Home → Recent calls → See all).
class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    body: GlowBackground(
      child: SafeArea(
        child: RefreshIndicator(
          color: AppColors.pink,
          onRefresh: () async => ref.invalidate(callHistoryProvider),
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
                    child: Text('Call history', style: AppText.heading(24)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const CallHistoryBody(),
            ],
          ),
        ),
      ),
    ),
  );
}
