import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../home/home_data.dart';

final checkInProvider = FutureProvider.autoDispose<CheckIn>((ref) {
  final api = ref.read(apiProvider);
  return api.call(() => api.growth.getCheckIn());
});

/// Shown once per app session when today's bonus hasn't been claimed.
bool _offeredThisSession = false;

/// Opens the daily bonus sheet if it's waiting (called from the caller home).
Future<void> offerDailyBonus(BuildContext context, WidgetRef ref) async {
  if (_offeredThisSession) return;
  _offeredThisSession = true;
  try {
    final api = ref.read(apiProvider);
    final c = await api.call(() => api.growth.getCheckIn());
    if (!c.claimedToday && context.mounted) await context.push('/checkin');
  } catch (_) {
    /* no bonus popup is fine */
  }
}

const _amber = Color(0xFFF59E0B);
const _orange = Color(0xFFEA580C);

/// Design: CheckIn.dc.html — 7-day ladder, today highlighted, "Claim N coins".
class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  bool _claiming = false;

  Future<void> _claim() async {
    setState(() => _claiming = true);
    final api = ref.read(apiProvider);
    try {
      final r = await api.call(() => api.growth.claimCheckIn());
      ref.invalidate(walletProvider);
      ref.invalidate(checkInProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            r.credited > 0
                ? '+${r.credited} coins added to your wallet'
                : 'Already claimed today. See you tomorrow!',
          ),
        ),
      );
      context.pop();
    } catch (e) {
      if (mounted) {
        setState(() => _claiming = false);
        showError(context, friendlyError(e));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(checkInProvider);
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(friendlyError(e), style: AppText.body(15))),
            data: (c) => FillScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: CircleIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Close',
                    onPressed: () => context.pop(),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFBBF24), _orange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66EA580C),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.local_fire_department_rounded,
                      size: 46,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  c.streak > 1 ? '${c.streak}-day streak!' : 'Daily bonus',
                  textAlign: TextAlign.center,
                  style: AppText.heading(28, spacing: -0.5),
                ),
                const SizedBox(height: 6),
                Text(
                  'Open Hello Dude! every day to collect free coins. Day 7 is the big one.',
                  textAlign: TextAlign.center,
                  style: AppText.body(15, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 22),
                _Ladder(days: c.days),
                const Spacer(),
                const SizedBox(height: 20),
                GradientButton(
                  label: c.claimedToday
                      ? 'Claimed today ✓'
                      : 'Claim ${c.todayCoins} coins',
                  icon: c.claimedToday ? null : Icons.toll_rounded,
                  loading: _claiming,
                  onPressed: c.claimedToday ? null : _claim,
                ),
                const SizedBox(height: 12),
                Text(
                  'Miss a day and your streak starts again from Day 1.',
                  textAlign: TextAlign.center,
                  style: AppText.body(12.5, color: AppColors.hint),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Ladder extends StatelessWidget {
  const _Ladder({required this.days});
  final List<CheckInDaysInner> days;

  @override
  Widget build(BuildContext context) {
    Widget tile(CheckInDaysInner d, {bool big = false}) {
      final claimed = d.state == CheckInDaysInnerStateEnum.claimed;
      final today = d.state == CheckInDaysInnerStateEnum.today;
      return Opacity(
        opacity: claimed ? 0.6 : 1,
        child: Container(
          height: 92,
          decoration: BoxDecoration(
            color: today ? _amber.withValues(alpha: 0.14) : AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: today ? _amber : AppColors.cardBorder,
              width: today ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Day ${d.day}',
                style: AppText.body(
                  12,
                  color: AppColors.textSecondary,
                  weight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Icon(
                claimed ? Icons.check_circle_rounded : Icons.toll_rounded,
                size: big ? 34 : 26,
                color: claimed ? AppColors.success : _amber,
              ),
              const SizedBox(height: 4),
              Text('+${d.coins}', style: AppText.heading(big ? 18 : 15)),
            ],
          ),
        ),
      );
    }

    final first = days.take(4).toList();
    final rest = days.skip(4).toList();
    return Column(
      children: [
        Row(
          children: [
            for (final (i, d) in first.indexed) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(child: tile(d)),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (final (i, d) in rest.indexed) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                flex: i == rest.length - 1 ? 2 : 1,
                child: tile(d, big: i == rest.length - 1),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
