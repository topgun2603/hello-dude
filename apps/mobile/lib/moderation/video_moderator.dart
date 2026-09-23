import 'dart:async';

import 'package:flutter/foundation.dart';

import 'nudity_detector.dart';

/// Checks the other person's video every few seconds during a video call.
///
/// On a nudity score at or above [threshold] it blurs at once ([hidden] turns
/// true) and hands one frame to [report] for the safety team (at most once per
/// [reportCooldown]; the server also rate-limits). The blur lifts after
/// [clearAfter] clean checks in a row.
class VideoModerator extends ChangeNotifier {
  VideoModerator({
    required this.capture,
    required this.detector,
    required this.report,
    this.interval = const Duration(seconds: 3),
    this.threshold = 0.7,
    this.clearAfter = 3,
    this.reportCooldown = const Duration(seconds: 30),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  /// Grabs the current remote frame as JPEG (null if no frame yet).
  final Future<Uint8List?> Function() capture;
  final NudityDetector detector;
  final Future<void> Function(Uint8List jpeg, double score) report;
  final Duration interval;
  final double threshold;
  final int clearAfter;
  final Duration reportCooldown;
  final DateTime Function() _now;

  bool _hidden = false;
  bool get hidden => _hidden;

  Timer? _timer;
  bool _busy = false;
  bool _disposed = false;
  int _cleanStreak = 0;
  DateTime? _lastReport;

  void start() {
    _timer ??= Timer.periodic(interval, (_) => check());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// One check. Public so tests can drive it without timers.
  Future<void> check() async {
    if (_busy || _disposed) return; // never queue up checks on a slow phone
    _busy = true;
    try {
      final frame = await capture();
      if (frame == null || _disposed) return;
      final score = await detector.score(frame);
      if (_disposed) return;
      if (score >= threshold) {
        _cleanStreak = 0;
        _setHidden(true);
        final now = _now();
        if (_lastReport == null || now.difference(_lastReport!) >= reportCooldown) {
          _lastReport = now;
          // Upload in the background; the blur never waits for the network.
          unawaited(report(frame, score).catchError((Object e) => debugPrint('moderation upload failed: $e')));
        }
      } else if (_hidden && ++_cleanStreak >= clearAfter) {
        _cleanStreak = 0;
        _setHidden(false);
      }
    } catch (e) {
      // A failed capture or inference must never break the call.
      debugPrint('moderation check failed: $e');
    } finally {
      _busy = false;
    }
  }

  void _setHidden(bool v) {
    if (_hidden == v) return;
    _hidden = v;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    stop();
    super.dispose();
  }
}
