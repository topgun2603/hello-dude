import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesu_api/api.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/theme.dart';
import '../../data/errors.dart';
import '../../data/session.dart';
import '../../widgets/common.dart';
import '../companion/companion_data.dart' show rupees;

final referralProvider = FutureProvider.autoDispose<GetReferral200Response>((
  ref,
) {
  final api = ref.read(apiProvider);
  return api.call(() => api.growth.getReferral());
});

/// Design: Referral.dc.html — "Give 50 coins, get 50 coins", code, stats, 3 steps.
class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(referralProvider);
    final companion =
        ref.watch(sessionProvider).profile?.role == ProfileRoleEnum.companion;
    return Scaffold(
      body: GlowBackground(
        child: SafeArea(
          child: data.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(friendlyError(e), style: AppText.body(15))),
            data: (r) => FillScrollView(
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
                      child: Text(
                        'Invite friends',
                        style: AppText.heading(22),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 72,
                    child: Stack(
                      children: [
                        const Positioned(
                          left: 8,
                          child: Avatar(name: 'K', avatarId: 3, size: 64),
                        ),
                        const Positioned(
                          left: 50,
                          child: Avatar(name: 'A', avatarId: 7, size: 64),
                        ),
                        Positioned(
                          right: 0,
                          top: 8,
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.brand,
                            ),
                            child: const Icon(
                              Icons.card_giftcard_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text.rich(
                  TextSpan(
                    style: AppText.heading(26, spacing: -0.5),
                    children: [
                      TextSpan(text: 'Give ${r.refereeCoins} coins, '),
                      TextSpan(
                        // Companions earn rupees in their earnings; callers earn coins.
                        text: companion
                            ? 'earn ${rupees(r.referrerPaise)}'
                            : 'get ${r.referrerCoins} coins',
                        style: const TextStyle(color: AppColors.pinkSoft),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 14, 10, 14),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.pinkSoft.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your code',
                              style: AppText.body(
                                12.5,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              r.code,
                              key: const ValueKey('referral-code'),
                              style: AppText.heading(
                                24,
                              ).copyWith(letterSpacing: 2),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(text: r.code));
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Code copied')),
                            );
                          }
                        },
                        icon: const Icon(Icons.copy_rounded, size: 18),
                        label: const Text('Copy'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: '${r.joined}',
                        label: companion ? 'Callers joined' : 'Friends joined',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(
                        value: companion
                            ? rupees(r.paiseEarned)
                            : '${r.coinsEarned}',
                        label: companion ? 'Earned' : 'Coins earned',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                for (final (i, (t, s)) in [
                  ('Share your code', 'Send it on WhatsApp or anywhere'),
                  (
                    companion ? 'A caller joins' : 'Friend joins',
                    'They sign up with your code',
                  ),
                  if (companion)
                    (
                      'You earn ${rupees(r.referrerPaise)}',
                      'Added to your earnings after their first recharge. They get ${r.refereeCoins} coins.',
                    )
                  else
                    (
                      'You both get ${r.referrerCoins} coins',
                      'After their first recharge',
                    ),
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.pink.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: AppText.body(
                              14,
                              color: AppColors.pinkSoft,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t,
                                style: AppText.body(
                                  15,
                                  weight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                s,
                                style: AppText.body(
                                  13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                const SizedBox(height: 12),
                GradientButton(
                  label: 'Share with friends',
                  icon: Icons.share_rounded,
                  // The share card shows a caller's talk time; companions share the link.
                  onPressed: companion
                      ? () => SharePlus.instance.share(
                          ShareParams(
                            text:
                                'Join me on Hello Dude! Use my code ${r.code} and get ${r.refereeCoins} free coins: ${r.link}',
                          ),
                        )
                      : () => context.push('/share'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value, label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      children: [
        Text(value, style: AppText.heading(24)),
        Text(label, style: AppText.body(12.5, color: AppColors.textSecondary)),
      ],
    ),
  );
}
