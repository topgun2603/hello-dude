import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

final rewardsProvider =
    FutureProvider.autoDispose<GetCompanionRewards200Response>((ref) {
      final api = ref.read(apiProvider);
      return api.call(() => api.companion.getCompanionRewards());
    });

const _amber = Color(0xFFF59E0B);
const _green = Color(0xFF10B981);

String _rupees(int paise) =>
    '₹${(paise / 100).toStringAsFixed(paise % 100 == 0 ? 0 : 2)}';
String _hm(int minutes) => minutes < 60
    ? '$minutes m'
    : '${minutes ~/ 60} h${minutes % 60 == 0 ? '' : ' ${minutes % 60} m'}';
String _clock(int minuteOfDay) {
  final h = (minuteOfDay ~/ 60) % 24, m = minuteOfDay % 60;
  final h12 = h % 12 == 0 ? 12 : h % 12;
  return m == 0
      ? '$h12 ${h < 12 ? 'AM' : 'PM'}'
      : '$h12:${m.toString().padLeft(2, '0')} ${h < 12 ? 'AM' : 'PM'}';
}

/// Design: Rewards.dc.html — level card, today's goal ring, online streak, time-window bonuses.
class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(rewardsProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: RefreshIndicator(
            color: _green,
            onRefresh: () async => ref.invalidate(rewardsProvider),
            child: data.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator(color: _green)),
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
              data: (r) => ListView(
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
                        child: Text('Rewards', style: AppText.heading(22)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _LevelCard(r: r),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: _GoalTile(
                          earned: r.todayEarnedPaise,
                          goal: r.dailyGoalPaise,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _StreakTile(days: r.streakDays)),
                    ],
                  ),
                  for (final b in r.bonuses) ...[
                    const SizedBox(height: 14),
                    _BonusCard(b: b),
                  ],
                  if (!r.videoEnabled) ...[
                    const SizedBox(height: 14),
                    Material(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(18),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        leading: const Icon(
                          Icons.school_rounded,
                          color: _green,
                        ),
                        title: const Text(
                          'Finish training to unlock video calls',
                        ),
                        subtitle: Text(
                          '${r.academy.passed}/${r.academy.total} lessons done',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.push('/academy'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.r});
  final GetCompanionRewards200Response r;

  @override
  Widget build(BuildContext context) {
    final next = r.next;
    final target = next?.minHours ?? r.level.minHours;
    final progress = target == 0
        ? 1.0
        : (r.monthHours / target).clamp(0.0, 1.0).toDouble();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF0E7490), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your level', style: AppText.body(13, color: Colors.white70)),
          const SizedBox(height: 2),
          Text(
            'Level ${r.level.level} · ${r.level.name}',
            style: AppText.heading(22),
          ),
          if (r.level.boostPct > 0)
            Text(
              '+${r.level.boostPct}% on every minute',
              style: AppText.body(
                13,
                color: Colors.white,
                weight: FontWeight.w600,
              ),
            ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Talk time this month',
                  style: AppText.body(13.5, color: Colors.white70),
                ),
              ),
              Text(
                '${r.monthHours.toStringAsFixed(r.monthHours % 1 == 0 ? 0 : 1)} / $target h',
                style: AppText.body(14, weight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: Colors.white,
              backgroundColor: Colors.white24,
            ),
          ),
          if (next != null && next.minRating > 0) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rating (${next.minRating.toStringAsFixed(1)} needed)',
                    style: AppText.body(13.5, color: Colors.white70),
                  ),
                ),
                Text(
                  r.rating == null
                      ? 'No ratings yet'
                      : '${r.rating!.toStringAsFixed(1)} ★',
                  style: AppText.body(14, weight: FontWeight.w700),
                ),
              ],
            ),
          ],
          if (next != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text.rich(
                TextSpan(
                  style: AppText.body(13.5),
                  children: [
                    TextSpan(text: 'Reach Level ${next.level} to earn '),
                    TextSpan(
                      text: '${next.boostPct}% more',
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(text: ' on every minute.'),
                  ],
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 12),
            Text(
              "You're at the top level. Amazing work!",
              style: AppText.body(13.5, weight: FontWeight.w600),
            ),
          ],
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  const _GoalTile({required this.earned, required this.goal});
  final int earned, goal;

  @override
  Widget build(BuildContext context) {
    final p = goal == 0 ? 1.0 : math.min(1.0, earned / goal);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: p,
                    strokeWidth: 8,
                    color: _green,
                    backgroundColor: Colors.white12,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      child: Text(_rupees(earned), style: AppText.heading(17)),
                    ),
                    Text(
                      'of ${_rupees(goal)}',
                      style: AppText.body(11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Today's goal",
            style: AppText.body(13, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StreakTile extends StatelessWidget {
  const _StreakTile({required this.days});
  final int days;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    height: 146,
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.local_fire_department_rounded,
          size: 40,
          color: _amber,
        ),
        const SizedBox(height: 6),
        Text('$days day${days == 1 ? '' : 's'}', style: AppText.heading(20)),
        Text(
          'Online streak',
          style: AppText.body(13, color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class _BonusCard extends StatelessWidget {
  const _BonusCard({required this.b});
  final CompanionBonus b;

  @override
  Widget build(BuildContext context) {
    final p = (b.doneMinutes / b.requiredMinutes).clamp(0.0, 1.0).toDouble();
    final (statusText, statusColor) = switch (b.status) {
      CompanionBonusStatusEnum.paid => (
        'Paid to your earnings ✓',
        AppColors.success,
      ),
      CompanionBonusStatusEnum.earned => (
        'Done! Paying out shortly',
        AppColors.success,
      ),
      CompanionBonusStatusEnum.missed => ('Missed today', AppColors.hint),
      CompanionBonusStatusEnum.upcoming => (
        'Starts ${_clock(b.windowStart)}',
        AppColors.textSecondary,
      ),
      _ => ('Ends ${_clock(b.windowEnd)}', AppColors.textSecondary),
    };
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _amber.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _amber.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(b.title, style: AppText.heading(17))),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: _amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${_rupees(b.rewardPaise)}',
                  style: AppText.body(
                    13,
                    color: const Color(0xFF451A03),
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Stay online ${_hm(b.requiredMinutes)} between ${_clock(b.windowStart)} and ${_clock(b.windowEnd)} today.',
            style: AppText.body(14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_hm(b.doneMinutes)} done',
                  style: AppText.body(13, weight: FontWeight.w600),
                ),
              ),
              Text(
                statusText,
                style: AppText.body(
                  13,
                  color: statusColor,
                  weight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: p,
              minHeight: 8,
              color: _amber,
              backgroundColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }
}
