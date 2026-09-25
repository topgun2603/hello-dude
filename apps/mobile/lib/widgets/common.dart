import 'package:flutter/material.dart';

import '../app/config.dart';
import '../app/theme.dart';

/// Dark screen with the purple/pink radial glows from the designs.
class GlowBackground extends StatelessWidget {
  const GlowBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: AppColors.background,
      gradient: RadialGradient(
        center: Alignment(1.25, -0.85),
        radius: 0.9,
        colors: [Color(0x66EC4899), Color(0x000A0A18)],
      ),
    ),
    child: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(-1.3, 0.1),
          radius: 0.9,
          colors: [Color(0x557C3AED), Color(0x000A0A18)],
        ),
      ),
      child: child,
    ),
  );
}

/// Fills the screen when there is room (so [Spacer]s push the button down)
/// and scrolls when there isn't — small phones, big fonts, open keyboard.
///
/// Children are split into groups at each [Spacer] and the free height is
/// shared between the gaps. This measures the real laid-out height; the old
/// SliverFillRemaining version trusted intrinsic heights, which ListTile and
/// TextField under-report when text wraps, and overflowed on small phones.
class FillScrollView extends StatelessWidget {
  const FillScrollView({
    super.key,
    required this.padding,
    required this.children,
  });
  final EdgeInsets padding;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final groups = <List<Widget>>[[]];
    for (final c in children) {
      c is Spacer ? groups.add([]) : groups.last.add(c);
    }
    return LayoutBuilder(
      builder: (context, box) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: (box.maxHeight - padding.vertical).clamp(
              0,
              double.infinity,
            ),
          ),
          // Unbounded height: the column is as tall as its content, but at
          // least minHeight, and spaceBetween hands the extra to the gaps.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final g in groups)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: g,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shrinks one line of text to fit the width instead of wrapping (headlines).
class OneLine extends StatelessWidget {
  const OneLine(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      FittedBox(fit: BoxFit.scaleDown, child: child);
}

/// The round sound-wave logo.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 38});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: const BoxDecoration(
      shape: BoxShape.circle,
      gradient: AppColors.brandLogo,
    ),
    child: CustomPaint(painter: _WavePainter()),
  );
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white
      ..strokeWidth = size.width * 0.063
      ..strokeCap = StrokeCap.round;
    final u =
        size.width /
        24 *
        0.52; // design draws the 24-unit icon at ~52% of the circle
    final ox = size.width / 2 - 12 * u, oy = size.height / 2 - 12 * u;
    for (final (x, top, bottom) in const [
      (4.0, 10.0, 14.0),
      (8.0, 7.0, 17.0),
      (12.0, 4.0, 20.0),
      (16.0, 7.0, 17.0),
      (20.0, 10.0, 14.0),
    ]) {
      canvas.drawLine(
        Offset(ox + x * u, oy + top * u),
        Offset(ox + x * u, oy + bottom * u),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BrandTitle extends StatelessWidget {
  const BrandTitle({
    super.key,
    this.logoSize = 38,
    this.fontSize = 21,
    this.dark = false,
  });
  final double logoSize, fontSize;
  final bool dark;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      BrandMark(size: logoSize),
      const SizedBox(width: 10),
      // Shrinks in tight header rows (the name is a placeholder; any length).
      Flexible(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            AppConfig.appName,
            maxLines: 1,
            style: AppText.heading(
              fontSize,
              color: dark ? AppColors.lightText : Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}

/// Full-width pill button with the brand gradient.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.icon,
    this.gradient = AppColors.brand,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  /// Brand by default; the companion side passes its green.
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    return Opacity(
      opacity: enabled || loading ? 1 : 0.5,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: gradient,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: enabled ? onPressed : null,
            child: Center(
              child: loading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shrinks rather than overflows on narrow phones / big fonts.
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label,
                              maxLines: 1,
                              style: AppText.body(17, weight: FontWeight.w700),
                            ),
                          ),
                        ),
                        if (icon != null) ...[
                          const SizedBox(width: 10),
                          Icon(icon, color: Colors.white, size: 20),
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

/// Round translucent icon button used for Back / Notifications.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.light = false,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final bool light;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: Material(
      color: light ? Colors.white : Colors.white.withValues(alpha: 0.1),
      shape: CircleBorder(
        side: BorderSide(
          color: light
              ? Colors.transparent
              : Colors.white.withValues(alpha: 0.14),
        ),
      ),
      elevation: light ? 3 : 0,
      shadowColor: const Color(0x1A14122B),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            size: 22,
            color: light ? AppColors.lightText : Colors.white,
          ),
        ),
      ),
    ),
  );
}

/// Three-dot sign-up progress (step is 0-based).
class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.step, this.light = false});
  final int step;
  final bool light;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Step ${step + 1} of 3',
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == step
                  ? (light ? const Color(0xFF7C3AED) : AppColors.lilac)
                  : (light
                        ? const Color(0xFFD9D5EA)
                        : Colors.white.withValues(alpha: 0.22)),
            ),
          ),
      ],
    ),
  );
}

/// Text painted with a gradient (headline accents).
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.style,
    this.gradient = AppColors.headline,
  });
  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (b) =>
        gradient.createShader(Rect.fromLTWH(0, 0, b.width, b.height)),
    child: Text(text, style: style),
  );
}

/// Illustrated avatars chosen from the user's gender at sign-up
/// (1 female, 2 male, 3 transgender; masters in design/brand/avatars/).
const avatarImages = {
  1: 'assets/images/avatars/female.jpg',
  2: 'assets/images/avatars/male.jpg',
  3: 'assets/images/avatars/transgender.jpg',
};

/// An illustrated avatar for ids 1–3, otherwise a gradient circle with the
/// first letter. Companions may have an admin-approved [photoUrl] (a signed
/// path from the API); it shows instead, falling back to the avatar if it can't
/// load. Callers are always avatar-only.
class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.name,
    required this.avatarId,
    this.size = 46,
    this.statusColor,
    this.photoUrl,
  });
  final String name;
  final int avatarId;
  final double size;
  final Color? statusColor;
  final String? photoUrl;

  /// Absolute URL for a photo path the API returned.
  static String photoSrc(String path) =>
      path.startsWith('http') ? path : '${AppConfig.apiBaseUrl}$path';

  static const _gradients = [
    [Color(0xFFEC4899), Color(0xFF9333EA)],
    [Color(0xFF3B82F6), Color(0xFF6D28D9)],
    [Color(0xFFF97316), Color(0xFFDB2777)],
    [Color(0xFF10B981), Color(0xFF0E7490)],
    [Color(0xFFF59E0B), Color(0xFFDC2626)],
    [Color(0xFF06B6D4), Color(0xFF4F46E5)],
  ];

  @override
  Widget build(BuildContext context) {
    final g = _gradients[(avatarId - 1).abs() % _gradients.length];
    final image = avatarImages[avatarId];
    final fallback = _fallback(image, g);
    final photo = photoUrl;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          if (photo != null)
            ClipOval(
              child: Image.network(
                photoSrc(photo),
                width: size,
                height: size,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                excludeFromSemantics: true,
                // Expired link or offline: show the avatar, never a broken image.
                errorBuilder: (_, _, _) => fallback,
                frameBuilder: (_, child, frame, sync) =>
                    frame == null && !sync ? fallback : child,
              ),
            )
          else
            fallback,
          if (statusColor != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.26,
                height: size * 0.26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor,
                  border: Border.all(color: const Color(0xFF16142C), width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _fallback(String? image, List<Color> g) => SizedBox(
    width: size,
    height: size,
    child: Stack(
      children: [
        if (image != null)
          ClipOval(
            child: Image.asset(
              image,
              width: size,
              height: size,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              excludeFromSemantics: true,
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: g,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              name.isEmpty ? '?' : name.characters.first.toUpperCase(),
              style: AppText.heading(size * 0.39),
            ),
          ),
      ],
    ),
  );
}

/// Error toast: a deep rose card with an icon (softer than plain red).
void showError(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF4C1130),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0x99FB7185)),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFFDA4AF),
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppText.body(14.5, weight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
}
