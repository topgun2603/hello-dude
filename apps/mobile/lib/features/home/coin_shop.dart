import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import 'home_screen.dart' show CoinIcon;

typedef CoinPack = ListCoinPackages200ResponseInner;

/// "₹1,999" / "₹49.50" (Indian digit grouping).
String rupeesLabel(int paise) {
  final whole = paise ~/ 100;
  final s = whole.toString();
  final grouped = s.length <= 3
      ? s
      : '${s.substring(0, s.length - 3).replaceAllMapped(RegExp(r'\B(?=(\d{2})+$)'), (_) => ',')},${s.substring(s.length - 3)}';
  return paise % 100 == 0
      ? '₹$grouped'
      : '₹$grouped.${(paise % 100).toString().padLeft(2, '0')}';
}

/// % cheaper per coin than the priciest regular pack (0 if not worth saying).
int savingsPct(CoinPack p, List<CoinPack> all) {
  final regular = all.where((x) => !x.firstRecharge).toList();
  if (regular.isEmpty || p.firstRecharge) return 0;
  double perCoin(CoinPack x) => x.pricePaise / (x.coins + x.bonusCoins);
  final worst = regular.map(perCoin).reduce((a, b) => a > b ? a : b);
  final pct = ((1 - perCoin(p) / worst) * 100).round();
  return pct >= 5 ? pct : 0;
}

/// Design: Wallet.dc.html "Add coins" — pick a pack, then one big buy button.
/// The welcome offer (new users) is a wide featured card above the grid.
class CoinShop extends StatefulWidget {
  const CoinShop({super.key, required this.packs, required this.onBuy});
  final List<CoinPack> packs;
  final void Function(CoinPack pack) onBuy;

  @override
  State<CoinShop> createState() => _CoinShopState();
}

class _CoinShopState extends State<CoinShop> {
  String? _sku;

  CoinPack? get _selected {
    final packs = widget.packs;
    if (packs.isEmpty) return null;
    return packs.where((p) => p.sku == _sku).firstOrNull ??
        // Default: the welcome offer, else the "Popular" pack, else the middle one.
        packs.where((p) => p.firstRecharge).firstOrNull ??
        packs
            .where((p) => (p.label ?? '').toLowerCase() == 'popular')
            .firstOrNull ??
        packs
            .where((p) => !p.firstRecharge)
            .elementAt(packs.where((p) => !p.firstRecharge).length ~/ 2);
  }

  @override
  Widget build(BuildContext context) {
    final welcome = widget.packs.where((p) => p.firstRecharge).firstOrNull;
    final regular = widget.packs.where((p) => !p.firstRecharge).toList();
    final selected = _selected;
    void pick(CoinPack p) => setState(() => _sku = p.sku);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Add coins',
                style: AppText.heading(19, weight: FontWeight.w800),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.lock_rounded,
                    size: 13,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Google Play',
                    style: AppText.body(
                      12,
                      weight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Bigger packs cost less per coin. Coins never expire.',
          style: AppText.body(13, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        if (welcome != null) ...[
          _WelcomePack(
            pack: welcome,
            selected: selected?.sku == welcome.sku,
            onTap: () => pick(welcome),
          ),
          const SizedBox(height: 18),
        ],
        Semantics(
          label: 'Coin packs',
          child: LayoutBuilder(
            builder: (context, box) {
              const gap = 10.0;
              final cols = box.maxWidth < 300 ? 2 : 3;
              final w = (box.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap + 8, // room for the ribbons
                children: [
                  for (var i = 0; i < regular.length; i++)
                    SizedBox(
                      width: w,
                      child: _PackCard(
                        pack: regular[i],
                        tier: (i * 3 ~/ regular.length) + 1,
                        savePct: savingsPct(regular[i], widget.packs),
                        selected: selected?.sku == regular[i].sku,
                        onTap: () => pick(regular[i]),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        if (selected != null)
          _BuyButton(pack: selected, onTap: () => widget.onBuy(selected)),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.verified_user_outlined,
              size: 15,
              color: AppColors.success,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                'Paid securely via Google Play · charged only after you confirm',
                textAlign: TextAlign.center,
                style: AppText.body(12.5, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Selected packs get a brand-gradient ring and a glow.
BoxDecoration _ring(bool selected, {double radius = 20}) => BoxDecoration(
  borderRadius: BorderRadius.circular(radius),
  gradient: selected
      ? AppColors.brand
      : LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.14),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
  boxShadow: selected
      ? [
          BoxShadow(
            color: AppColors.pink.withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ]
      : const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
);

class _PackCard extends StatelessWidget {
  const _PackCard({
    required this.pack,
    required this.tier,
    required this.savePct,
    required this.selected,
    required this.onTap,
  });

  final CoinPack pack;

  /// 1–3: how big the coin pile looks.
  final int tier;
  final int savePct;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = pack.coins + pack.bonusCoins;
    final ribbon = pack.label;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      label:
          '$total coins for ${rupeesLabel(pack.pricePaise)}${ribbon != null ? ', $ribbon' : ''}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedScale(
          scale: selected ? 1.04 : 1,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: EdgeInsets.all(selected ? 2 : 1),
                decoration: _ring(selected),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(selected ? 18 : 19),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: selected
                          ? const [Color(0xFF3A1F5C), Color(0xFF1C1433)]
                          : const [Color(0xFF221D40), Color(0xFF15132A)],
                    ),
                  ),
                  child: Column(
                    children: [
                      _CoinPile(tier: tier),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _grouped(total),
                          style: AppText.heading(22, spacing: -0.4),
                        ),
                      ),
                      Text(
                        'coins',
                        style: AppText.body(
                          11.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 20,
                        child: pack.bonusCoins > 0
                            ? _Pill(
                                '+${_grouped(pack.bonusCoins)} free',
                                color: AppColors.success,
                              )
                            : savePct > 0
                            ? _Pill(
                                'Save $savePct%',
                                color: const Color(0xFFFCD34D),
                              )
                            : null,
                      ),
                      const SizedBox(height: 8),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: selected ? AppColors.brand : null,
                          color: selected
                              ? null
                              : Colors.white.withValues(alpha: 0.07),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            rupeesLabel(pack.pricePaise),
                            style: AppText.body(14.5, weight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (ribbon != null && pack.bonusCoins == 0)
                Positioned(top: -10, child: _Ribbon(ribbon)),
              if (selected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.brand,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
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

/// 1–3 overlapping coins, glowing softly.
class _CoinPile extends StatelessWidget {
  const _CoinPile({required this.tier});
  final int tier;

  @override
  Widget build(BuildContext context) {
    const size = 30.0;
    final offsets = switch (tier) {
      1 => const [Offset(0, 0)],
      2 => const [Offset(-9, 4), Offset(9, -2)],
      _ => const [Offset(-13, 5), Offset(13, 5), Offset(0, -4)],
    };
    return SizedBox(
      height: 40,
      width: 64,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 44,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          for (final o in offsets)
            Transform.translate(
              offset: o,
              child: const CoinIcon(size: size),
            ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, {required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(999),
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: AppText.body(11, weight: FontWeight.w800, color: color),
      ),
    ),
  );
}

class _Ribbon extends StatelessWidget {
  const _Ribbon(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      gradient: const LinearGradient(
        colors: [Color(0xFFDB2777), Color(0xFFEA580C)],
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFFDB2777).withValues(alpha: 0.4),
          blurRadius: 8,
        ),
      ],
    ),
    child: Text(text, style: AppText.body(10.5, weight: FontWeight.w800)),
  );
}

/// New users' welcome pack: wide, gold-edged, with a countdown.
class _WelcomePack extends StatefulWidget {
  const _WelcomePack({
    required this.pack,
    required this.selected,
    required this.onTap,
  });
  final CoinPack pack;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_WelcomePack> createState() => _WelcomePackState();
}

class _WelcomePackState extends State<_WelcomePack> {
  Timer? _tick;

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
    final p = widget.pack;
    final left = p.offerEndsAt?.difference(DateTime.now());
    String two(int n) => n.toString().padLeft(2, '0');
    final countdown = left == null || left.isNegative
        ? null
        : '${two(left.inHours)}:${two(left.inMinutes % 60)}:${two(left.inSeconds % 60)}';
    const gold = LinearGradient(
      colors: [Color(0xFFFDE68A), Color(0xFFF59E0B), Color(0xFFDB2777)],
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: widget.selected,
      button: true,
      label:
          'Welcome offer: ${p.coins} coins plus ${p.bonusCoins} free for ${rupeesLabel(p.pricePaise)}',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: EdgeInsets.all(widget.selected ? 2 : 1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: gold,
            boxShadow: [
              BoxShadow(
                color: const Color(
                  0xFFF59E0B,
                ).withValues(alpha: widget.selected ? 0.35 : 0.15),
                blurRadius: 22,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3B2A12),
                  Color(0xFF2A1633),
                  Color(0xFF16132B),
                ],
              ),
            ),
            child: Row(
              children: [
                const _CoinPile(tier: 3),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME OFFER · 2× COINS',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.body(
                          11,
                          weight: FontWeight.w800,
                          color: const Color(0xFFFCD34D),
                        ).copyWith(letterSpacing: 0.8),
                      ),
                      const SizedBox(height: 3),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${p.coins}',
                                style: AppText.heading(22),
                              ),
                              TextSpan(
                                text: '  +${p.bonusCoins} free',
                                style: AppText.body(
                                  15,
                                  weight: FontWeight.w800,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (countdown != null) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 13,
                              color: Color(0xFFFCD34D),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Ends in $countdown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppText.body(
                                  12,
                                  weight: FontWeight.w700,
                                  color: const Color(0xFFFDE68A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: gold,
                  ),
                  child: Text(
                    rupeesLabel(p.pricePaise),
                    style: AppText.body(
                      15,
                      weight: FontWeight.w800,
                      color: const Color(0xFF3B2503),
                    ),
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

class _BuyButton extends StatelessWidget {
  const _BuyButton({required this.pack, required this.onTap});
  final CoinPack pack;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final total = pack.coins + pack.bonusCoins;
    return Semantics(
      button: true,
      label: 'Add $total coins for ${rupeesLabel(pack.pricePaise)}',
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              gradient: AppColors.brand,
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CoinIcon(size: 22),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Add ${_grouped(total)} coins · ${rupeesLabel(pack.pricePaise)}',
                      style: AppText.heading(16.5, weight: FontWeight.w800),
                    ),
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

String _grouped(int n) => rupeesLabel(n * 100).substring(1);
