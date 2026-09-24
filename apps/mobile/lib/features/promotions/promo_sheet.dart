import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesu_api/api.dart';

import '../../app/theme.dart';
import '../../data/session.dart';

/// Colours of each promotion theme (admin "Offers popup" → Colours).
LinearGradient promoGradient(PromotionThemeEnum theme) => switch (theme) {
  PromotionThemeEnum.gold => const LinearGradient(
    colors: [Color(0xFFFDE68A), Color(0xFFD97706)],
  ),
  PromotionThemeEnum.green => const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF0E7490)],
  ),
  _ => AppColors.brand,
};

List<Color> _confettiColors(PromotionThemeEnum theme) => switch (theme) {
  PromotionThemeEnum.gold => const [
    Color(0xFFFDE68A),
    Color(0xFFF59E0B),
    Color(0xFFD97706),
    Colors.white,
  ],
  PromotionThemeEnum.green => const [
    Color(0xFF10B981),
    Color(0xFF34D399),
    Color(0xFF0E7490),
    Colors.white,
  ],
  _ => const [
    Color(0xFF7C3AED),
    Color(0xFFDB2777),
    Color(0xFFEA580C),
    Color(0xFFF472B6),
    Color(0xFFFDE68A),
  ],
};

bool _showing = false;

/// Asks the server for the offer to show now (admin → Offers popup) and, if
/// there is one, opens it as a bottom sheet with confetti. Completes when the
/// sheet closes; `onAction` runs if the button was tapped. Never throws.
Future<void> showAppOpenPromotion(
  BuildContext context,
  WidgetRef ref, {
  required void Function(PromotionCtaActionEnum action) onAction,
}) async {
  if (_showing) return;
  _showing = true;
  try {
    final api = ref.read(apiProvider);
    final promo = (await api.call(
      () => api.promotions.getCurrentPromotion(),
    )).promotion;
    if (promo == null || !context.mounted) return;

    void log(LogPromotionEventRequestActionEnum a) => unawaited(
      api
          .send(
            () => api.promotions.logPromotionEvent(
              promo.id,
              LogPromotionEventRequest(action: a),
            ),
          )
          .then<void>((_) {}, onError: (_) {}),
    );
    log(LogPromotionEventRequestActionEnum.shown);

    final sheet = showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => PromoSheet(promo: promo),
    );

    // Confetti goes in after the sheet's route so it falls over the sheet.
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    OverlayEntry? confetti;
    ConfettiController? controller;
    if (promo.confetti && !reduceMotion) {
      controller = ConfettiController(
        duration: const Duration(milliseconds: 900),
      );
      confetti = OverlayEntry(
        builder: (_) =>
            _ConfettiLayer(controller: controller!, theme: promo.theme),
      );
      Overlay.of(context, rootOverlay: true).insert(confetti);
      controller.play();
    }

    final tapped = await sheet;

    // Let the last pieces fall before removing the layer.
    if (confetti != null) {
      final entry = confetti;
      final c = controller!;
      Timer(const Duration(seconds: 2), () {
        entry.remove();
        c.dispose();
      });
    }
    if (tapped == true) {
      log(LogPromotionEventRequestActionEnum.clicked);
      onAction(promo.ctaAction);
    }
  } catch (_) {
    /* no popup is fine */
  } finally {
    _showing = false;
  }
}

/// Full-screen confetti above the sheet; never blocks taps.
class _ConfettiLayer extends StatelessWidget {
  const _ConfettiLayer({required this.controller, required this.theme});
  final ConfettiController controller;
  final PromotionThemeEnum theme;

  @override
  Widget build(BuildContext context) {
    final colors = _confettiColors(theme);
    Widget cannon(Alignment a, double direction) => Align(
      alignment: a,
      child: ConfettiWidget(
        confettiController: controller,
        blastDirection: direction,
        blastDirectionality: direction.isNaN
            ? BlastDirectionality.explosive
            : BlastDirectionality.directional,
        emissionFrequency: 0.35,
        numberOfParticles: 14,
        maxBlastForce: 38,
        minBlastForce: 14,
        gravity: 0.25,
        particleDrag: 0.04,
        colors: colors,
      ),
    );
    return IgnorePointer(
      child: Stack(
        children: [
          cannon(
            const Alignment(0, -0.35),
            double.nan,
          ), // burst above the sheet
          cannon(
            const Alignment(-1, 0.1),
            -pi / 3,
          ), // from the left edge, up and right
          cannon(
            const Alignment(1, 0.1),
            -2 * pi / 3,
          ), // from the right edge, up and left
        ],
      ),
    );
  }
}

/// The offer bottom sheet (preview in admin → Offers popup). Pops `true` when
/// the button is tapped.
class PromoSheet extends StatefulWidget {
  const PromoSheet({super.key, required this.promo});
  final Promotion promo;

  @override
  State<PromoSheet> createState() => _PromoSheetState();
}

class _PromoSheetState extends State<PromoSheet> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    if (widget.promo.endsAt != null) {
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  String? _countdown() {
    final ends = widget.promo.endsAt;
    if (ends == null) return null;
    final left = ends.difference(DateTime.now());
    if (left.isNegative) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    if (left.inDays >= 1) return '${left.inDays}d ${left.inHours % 24}h left';
    return '${two(left.inHours)}:${two(left.inMinutes % 60)}:${two(left.inSeconds % 60)} left';
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.promo;
    final gradient = promoGradient(p.theme);
    final onButton = p.theme == PromotionThemeEnum.gold
        ? const Color(0xFF3B2503)
        : Colors.white;
    final countdown = _countdown();
    final hasButton = p.ctaAction != PromotionCtaActionEnum.none;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 44),
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            20 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF16142C),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: AppColors.cardBorder)),
          ),
          // Scrolls on small phones instead of overflowing.
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 48),
                if (p.badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      p.badge!.toUpperCase(),
                      style: AppText.body(
                        11.5,
                        weight: FontWeight.w800,
                        color: AppColors.pinkSoft,
                      ).copyWith(letterSpacing: 1.2),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                if (p.highlight != null)
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (r) => gradient.createShader(r),
                    child: Text(
                      p.highlight!,
                      textAlign: TextAlign.center,
                      style: AppText.heading(
                        38,
                        weight: FontWeight.w800,
                        spacing: -1,
                      ),
                    ),
                  ),
                Text(
                  p.title,
                  textAlign: TextAlign.center,
                  style: AppText.heading(20),
                ),
                if (p.body.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    p.body,
                    textAlign: TextAlign.center,
                    style: AppText.body(14.5, color: AppColors.textSecondary),
                  ),
                ],
                if (countdown != null) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: Color(0xFFFCD34D),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        countdown,
                        style: AppText.body(
                          13.5,
                          weight: FontWeight.w700,
                          color: const Color(0xFFFCD34D),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                Semantics(
                  button: true,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => Navigator.pop(context, hasButton),
                      child: Ink(
                        height: 54,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Center(
                          child: Text(
                            p.ctaLabel,
                            style: AppText.body(
                              16.5,
                              weight: FontWeight.w800,
                              color: onButton,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (hasButton)
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      'Not now',
                      style: AppText.body(
                        14,
                        weight: FontWeight.w600,
                        color: AppColors.navInactive,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        // Emoji medal sitting on the sheet's top edge.
        ExcludeSemantics(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient,
              border: Border.all(color: const Color(0xFF16142C), width: 5),
              boxShadow: [
                BoxShadow(
                  color: gradient.colors.first.withValues(alpha: 0.45),
                  blurRadius: 24,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(p.emoji ?? '🎁', style: const TextStyle(fontSize: 40)),
          ),
        ),
      ],
    );
  }
}
