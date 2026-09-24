import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';

final vipProvider = FutureProvider.autoDispose<GetVip200Response>((ref) {
  final api = ref.read(apiProvider);
  return api.call(() => api.vip.getVip());
});

const vipGold = LinearGradient(
  colors: [Color(0xFFFDE68A), Color(0xFFF59E0B), Color(0xFFD97706)],
);
const _goldText = Color(0xFFFDE68A);

String _rupees(int paise) =>
    '₹${(paise / 100).toStringAsFixed(paise % 100 == 0 ? 0 : 2)}';
String _date(DateTime d) {
  const m = [
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
  final l = d.toLocal();
  return '${l.day} ${m[l.month - 1]} ${l.year}';
}

/// Small gold "VIP" badge.
class VipBadge extends StatelessWidget {
  const VipBadge({super.key, this.size = 11});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.symmetric(horizontal: size * 0.6, vertical: size * 0.2),
    decoration: BoxDecoration(
      gradient: vipGold,
      borderRadius: BorderRadius.circular(size),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          size: size + 3,
          color: const Color(0xFF451A03),
        ),
        const SizedBox(width: 3),
        Text(
          'VIP',
          style: AppText.body(
            size,
            color: const Color(0xFF451A03),
            weight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

/// Design: Vip.dc.html — gold hero, perks, plan picker, "Continue with Google Play".
class VipScreen extends ConsumerStatefulWidget {
  const VipScreen({super.key});

  @override
  ConsumerState<VipScreen> createState() => _VipScreenState();
}

class _VipScreenState extends ConsumerState<VipScreen> {
  int? _plan;

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(vipProvider);
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: GlowBackground(child: SizedBox.expand()),
          ),
          // Gold glow at the top.
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                height: 320,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0x55F59E0B), Colors.transparent],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: data.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFFF59E0B)),
              ),
              error: (e, _) => Center(
                child: Text(friendlyError(e), style: AppText.body(15)),
              ),
              data: (v) {
                final plans = v.plans;
                final selected = plans.isEmpty
                    ? null
                    : plans.firstWhere(
                        (p) =>
                            p.id ==
                            (_plan ??
                                plans
                                    .lastWhere(
                                      (x) => x.label != null,
                                      orElse: () => plans.last,
                                    )
                                    .id),
                        orElse: () => plans.last,
                      );
                return FillScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CircleIconButton(
                        icon: Icons.arrow_back_rounded,
                        tooltip: 'Back',
                        onPressed: () => context.pop(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: vipGold,
                          boxShadow: [
                            BoxShadow(color: Color(0x66F59E0B), blurRadius: 30),
                          ],
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          size: 46,
                          color: Color(0xFF451A03),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hello Dude! ',
                            style: AppText.heading(28, spacing: -0.5),
                          ),
                          ShaderMask(
                            shaderCallback: (r) => vipGold.createShader(r),
                            child: Text(
                              'VIP',
                              style: AppText.heading(28, spacing: -0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      v.active
                          ? "You're VIP until ${_date(v.expiresAt!)}"
                          : 'Talk more, pay less, get matched first.',
                      textAlign: TextAlign.center,
                      style: AppText.body(
                        15,
                        color: v.active ? _goldText : AppColors.textSecondary,
                        weight: v.active ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x33F59E0B)),
                      ),
                      child: Column(
                        children: [
                          for (final (icon, text) in [
                            (
                              Icons.percent_rounded,
                              '${v.discountPct}% off every call minute',
                            ),
                            (
                              Icons.bolt_rounded,
                              'Priority matching at busy hours',
                            ),
                            (
                              Icons.workspace_premium_rounded,
                              'Gold VIP badge on your profile',
                            ),
                            (
                              Icons.local_florist_rounded,
                              v.weeklyGift == null
                                  ? 'One free Rose every week'
                                  : v.weeklyGift!.used
                                  ? 'Free Rose used this week — next one Monday'
                                  : 'Your free ${v.weeklyGift!.name} ${v.weeklyGift!.emoji} is ready this week',
                            ),
                          ])
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 7),
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    color: const Color(0xFFF59E0B),
                                    size: 22,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(text, style: AppText.body(15)),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (!v.active && plans.isNotEmpty)
                      Semantics(
                        container: true,
                        label: 'Plan',
                        child: Row(
                          children: [
                            for (final (i, p) in plans.indexed) ...[
                              if (i > 0) const SizedBox(width: 12),
                              Expanded(
                                child: _PlanCard(
                                  plan: p,
                                  selected: p.id == selected?.id,
                                  onTap: () => setState(() => _plan = p.id),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    const Spacer(),
                    const SizedBox(height: 18),
                    if (!v.active) ...[
                      Opacity(
                        opacity: v.purchasable ? 1 : 0.55,
                        child: Container(
                          height: 56,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            gradient: vipGold,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Text(
                            'Continue with Google Play',
                            style: AppText.body(
                              17,
                              color: const Color(0xFF451A03),
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        v.purchasable
                            ? 'Renews automatically. Cancel anytime in the Play Store.'
                            : 'VIP purchases open soon.',
                        textAlign: TextAlign.center,
                        style: AppText.body(12.5, color: AppColors.hint),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });
  final VipPlan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? const Color(0xFFF59E0B) : AppColors.cardBorder,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (plan.label != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    gradient: vipGold,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    plan.label!,
                    style: AppText.body(
                      11,
                      color: const Color(0xFF451A03),
                      weight: FontWeight.w800,
                    ),
                  ),
                )
              else
                const SizedBox(height: 23),
              Text(
                plan.months == 1 ? 'Monthly' : '${plan.months} months',
                style: AppText.body(14, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Text(_rupees(plan.pricePaise), style: AppText.heading(22)),
              Text(
                plan.months == 1
                    ? 'per month'
                    : '${_rupees((plan.pricePaise / plan.months).round())}/month',
                style: AppText.body(12.5, color: AppColors.hint),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
