import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme.dart';
import 'buy_coins.dart';
import 'home_data.dart';
import 'home_screen.dart' show CoinIcon;

/// Design: FirstRecharge.dc.html — shown on Home while a new user's welcome offer lasts.
class OfferBanner extends ConsumerStatefulWidget {
  const OfferBanner({super.key});

  @override
  ConsumerState<OfferBanner> createState() => _OfferBannerState();
}

class _OfferBannerState extends ConsumerState<OfferBanner> {
  Timer? _tick;
  bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offer = ref
        .watch(coinPackagesProvider)
        .valueOrNull
        ?.where((p) => p.firstRecharge)
        .firstOrNull;
    final ends = offer?.offerEndsAt;
    if (offer == null || ends == null || _dismissed)
      return const SizedBox.shrink();
    final left = ends.difference(DateTime.now());
    if (left.isNegative) return const SizedBox.shrink();
    String two(int n) => n.toString().padLeft(2, '0');
    final countdown =
        '${two(left.inHours)}:${two(left.inMinutes % 60)}:${two(left.inSeconds % 60)}';
    final price =
        '₹${(offer.pricePaise / 100).toStringAsFixed(offer.pricePaise % 100 == 0 ? 0 : 2)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFFFDE68A), Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
        ),
        child: Row(
          children: [
            const CoinIcon(size: 36),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome offer · double coins',
                    style: AppText.body(
                      12.5,
                      color: const Color(0xFF78350F),
                      weight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${offer.coins} + ${offer.bonusCoins} free for $price',
                    style: AppText.heading(18, color: const Color(0xFF1C1917)),
                  ),
                  Text(
                    'Ends in $countdown',
                    style:
                        AppText.body(
                          12.5,
                          color: const Color(0xFF78350F),
                          weight: FontWeight.w600,
                        ).copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                ],
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF1C1917),
                foregroundColor: Colors.white,
              ),
              onPressed: () => buyCoins(context, ref, offer),
              child: const Text('Claim'),
            ),
            IconButton(
              tooltip: 'Hide offer',
              onPressed: () => setState(() => _dismissed = true),
              icon: const Icon(
                Icons.close_rounded,
                color: Color(0xFF78350F),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
