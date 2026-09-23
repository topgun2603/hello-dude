import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../app/theme.dart';

/// "Two bubbles meet, a heart beats" — the same loader as the admin panel
/// (apps/admin/src/components/love-loader.tsx), for signing in/out and app start.
class LoveLoader extends StatelessWidget {
  const LoveLoader({super.key, required this.title, this.subtitle});
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: [title, ?subtitle].join('. '),
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          fit: StackFit.expand,
          children: [
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.6, -1),
                    end: Alignment(0.6, 1),
                    colors: [Color(0xEB1A0B2E), Color(0xF5120724)],
                  ),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.1),
                  radius: 0.6,
                  colors: [Color(0x47EC4899), Color(0x00EC4899)],
                ),
              ),
            ),
            Center(
              child: ExcludeSemantics(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _Scene(),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: AppText.heading(24),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: AppText.hand(24, color: const Color(0xFFFBCFE8)),
                      ),
                    ],
                    const SizedBox(height: 20),
                    const _Dots(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the loader above everything (dialogs, sheets, other routes) while
/// [task] runs, for at least [minimum] so it never just flickers.
Future<T> withLoveLoader<T>(
  BuildContext context, {
  required String title,
  String? subtitle,
  required Future<T> Function() task,
  Duration minimum = const Duration(milliseconds: 900),
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final entry = OverlayEntry(
    builder: (_) => _FadeIn(
      child: LoveLoader(title: title, subtitle: subtitle),
    ),
  );
  overlay.insert(entry);
  final started = DateTime.now();
  try {
    return await task();
  } finally {
    final left = minimum - DateTime.now().difference(started);
    if (left > Duration.zero) await Future<void>.delayed(left);
    entry.remove();
  }
}

class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 250),
    builder: (context, v, child) => Opacity(opacity: v, child: child),
    child: child,
  );
}

// ---------------------------------------------------------------------------

/// Keyframe helper: value at time t (0..1) through [values] at [times], eased.
double _keys(
  double t,
  List<double> times,
  List<double> values, [
  Curve curve = Curves.easeInOut,
]) {
  for (var i = 0; i < times.length - 1; i++) {
    if (t <= times[i + 1]) {
      final span = times[i + 1] - times[i];
      final local = span == 0 ? 1.0 : ((t - times[i]) / span).clamp(0.0, 1.0);
      return values[i] + (values[i + 1] - values[i]) * curve.transform(local);
    }
  }
  return values.last;
}

class _Scene extends StatefulWidget {
  const _Scene();

  @override
  State<_Scene> createState() => _SceneState();
}

class _SceneState extends State<_Scene> with TickerProviderStateMixin {
  // 2.4 s: bubbles lean in and out, mini hearts float. 1.2 s: heart beat + ring.
  late final _lean = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2400),
  );
  late final _beat = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect "remove animations" in the phone's accessibility settings.
    if (MediaQuery.of(context).disableAnimations) {
      _lean.stop();
      _beat.stop();
    } else {
      if (!_lean.isAnimating) _lean.repeat();
      if (!_beat.isAnimating) _beat.repeat();
    }
  }

  @override
  void dispose() {
    _lean.dispose();
    _beat.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.of(context).disableAnimations;
    return SizedBox(
      width: 288,
      height: 176,
      child: AnimatedBuilder(
        animation: Listenable.merge([_lean, _beat]),
        builder: (context, _) {
          final t = _lean.value, b = _beat.value;
          const times = [0.0, 0.35, 0.65, 1.0];
          final dx = still ? 0.0 : _keys(t, times, [0, 26, 26, 0]);
          final rot = still
              ? 0.0
              : _keys(t, times, [0, 6, 6, 0]) * math.pi / 180;
          final heartScale = still
              ? 1.0
              : _keys(
                  b,
                  const [0, 0.15, 0.3, 0.45, 1],
                  const [1, 1.25, 1, 1.18, 1],
                );
          final ring = Curves.easeOut.transform(b);
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // floating mini hearts
              if (!still)
                for (var i = 0; i < 5; i++) _miniHeart(i, t),
              // pink bubble (left, winking) and blue bubble (right, mirrored) lean in
              Positioned(
                left: 16,
                top: 40,
                child: Transform.translate(
                  offset: Offset(dx, 0),
                  child: Transform.rotate(
                    angle: rot,
                    child: const _Bubble(
                      from: Color(0xFFF472B6),
                      to: Color(0xFFDB2777),
                      wink: true,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 16,
                top: 40,
                child: Transform.translate(
                  offset: Offset(-dx, 0),
                  child: Transform.rotate(
                    angle: -rot,
                    child: const _Bubble(
                      from: Color(0xFF67E8F9),
                      to: Color(0xFF3B82F6),
                      flip: true,
                    ),
                  ),
                ),
              ),
              // the heart that beats when they meet
              Positioned(
                left: 0,
                right: 0,
                top: 8,
                child: Center(
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        if (!still)
                          Opacity(
                            opacity: (0.7 * (1 - ring)).clamp(0.0, 1.0),
                            child: Transform.scale(
                              scale: 0.6 + 1.3 * ring,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFF472B6),
                                    width: 2,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Transform.scale(
                          scale: heartScale,
                          child: const CustomPaint(
                            size: Size(48, 48),
                            painter: _HeartPainter(glow: true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _miniHeart(int i, double t) {
    final p =
        (t - i * 0.45 / 2.4) %
        1.0; // each heart starts 0.45 s after the previous
    final y = -110 * Curves.easeInOut.transform(p);
    final opacity = _keys(p, const [0, 0.5, 1], const [0, 1, 0]);
    final scale = _keys(p, const [0, 0.5, 1], const [0.6, 1, 0.8]);
    final x = i.isOdd
        ? _keys(p, const [0, 0.5, 1], const [0, 8, -4])
        : _keys(p, const [0, 0.5, 1], const [0, -8, 4]);
    return Positioned(
      left: 288 * (0.30 + i * 0.10),
      bottom: 40,
      child: Transform.translate(
        offset: Offset(x, y),
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            child: const CustomPaint(
              size: Size(16, 16),
              painter: _HeartPainter(color: Color(0xCCF472B6)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Heart from the admin loader's SVG path (24×24 viewBox).
class _HeartPainter extends CustomPainter {
  const _HeartPainter({this.color, this.glow = false});
  final Color? color;
  final bool glow;

  static Path _heart() => Path()
    ..moveTo(12, 21)
    ..cubicTo(12, 21, 4.5, 16.4, 2.4, 11.8)
    ..cubicTo(0.9, 8.4, 3, 4.5, 6.7, 4.5)
    ..cubicTo(8.8, 4.5, 10.3, 5.7, 11, 7.1)
    ..lineTo(13, 7.1)
    ..cubicTo(13.7, 5.7, 15.2, 4.5, 17.3, 4.5)
    ..cubicTo(21, 4.5, 23.1, 8.4, 21.6, 11.8)
    ..cubicTo(19.5, 16.4, 12, 21, 12, 21)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 24, size.height / 24);
    final path = _heart();
    if (glow) {
      canvas.drawPath(
        path.shift(const Offset(0, 1.5)),
        Paint()
          ..color = const Color(0xCCEC4899)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );
    }
    final paint = Paint()..isAntiAlias = true;
    if (color != null) {
      paint.color = color!;
    } else {
      paint.shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFBCFE8), Color(0xFFF472B6), Color(0xFFDB2777)],
        stops: [0, 0.45, 1],
      ).createShader(const Rect.fromLTWH(0, 0, 24, 24));
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _HeartPainter old) =>
      old.color != color || old.glow != glow;
}

/// Speech bubble with a little face, like the app icon (96×88 viewBox).
class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.from,
    required this.to,
    this.wink = false,
    this.flip = false,
  });
  final Color from, to;
  final bool wink, flip;

  @override
  Widget build(BuildContext context) {
    final bubble = CustomPaint(
      size: const Size(96, 88),
      painter: _BubblePainter(from, to, wink),
    );
    return flip ? Transform.flip(flipX: true, child: bubble) : bubble;
  }
}

class _BubblePainter extends CustomPainter {
  const _BubblePainter(this.from, this.to, this.wink);
  final Color from, to;
  final bool wink;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 96, size.height / 88);
    final body = Path()
      ..moveTo(48, 4)
      ..cubicTo(24, 4, 6, 18, 6, 38)
      ..cubicTo(6, 49, 12, 59, 22, 65)
      ..lineTo(18, 82)
      ..lineTo(36, 71)
      ..cubicTo(40, 72, 44, 72, 48, 72)
      ..cubicTo(72, 72, 90, 58, 90, 38)
      ..cubicTo(90, 18, 72, 4, 48, 4)
      ..close();
    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [from, to],
        ).createShader(const Rect.fromLTWH(0, 0, 96, 88)),
    );

    // glossy highlight
    canvas.save();
    canvas.translate(30, 20);
    canvas.rotate(-20 * math.pi / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 24, height: 12),
      Paint()..color = Colors.white.withValues(alpha: 0.3),
    );
    canvas.restore();

    // face
    final ink = Paint()
      ..color = const Color(0xFF1A0B2E)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    if (wink) {
      canvas.drawLine(const Offset(58, 34), const Offset(66, 30), ink);
      canvas.drawLine(const Offset(58, 34), const Offset(66, 38), ink);
    } else {
      canvas.drawPath(
        Path()
          ..moveTo(58, 36)
          ..cubicTo(60, 32, 65, 32, 67, 36),
        ink,
      );
    }
    canvas.drawPath(
      Path()
        ..moveTo(32, 36)
        ..cubicTo(34, 32, 39, 32, 41, 36),
      ink,
    );
    canvas.drawPath(
      Path()
        ..moveTo(36, 48)
        ..cubicTo(42, 55, 54, 55, 60, 48),
      ink,
    );
  }

  @override
  bool shouldRepaint(covariant _BubblePainter old) =>
      old.from != from || old.to != to || old.wink != wink;
}

class _Dots extends StatefulWidget {
  const _Dots();

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _c.stop();
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    builder: (context, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 3; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Builder(
            builder: (_) {
              final p = (_c.value - i * 0.15 / 0.9) % 1.0;
              final y = _keys(p, const [0, 0.5, 1], const [0, -6, 0]);
              final o = _keys(p, const [0, 0.5, 1], const [0.4, 1, 0.4]);
              return Transform.translate(
                offset: Offset(0, y),
                child: Opacity(
                  opacity: o,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF9A8D4),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ],
    ),
  );
}
