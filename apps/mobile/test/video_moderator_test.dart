import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:pesu/moderation/nudity_detector.dart';
import 'package:pesu/moderation/video_moderator.dart';

class _FakeDetector implements NudityDetector {
  _FakeDetector(this.scores);
  final List<double> scores;
  int calls = 0;
  @override
  Future<double> score(Uint8List jpeg) async => scores[calls++ % scores.length];
  @override
  void dispose() {}
}

final _frame = Uint8List.fromList([0xff, 0xd8, 1, 2, 3]);

void main() {
  test(
    'blurs after 2 flagged frames in a row, reports once per cooldown, clears after 3 clean frames',
    () async {
      var now = DateTime(2026, 9, 23, 12);
      final reports = <double>[];
      final detector = _FakeDetector([
        0.95,
        0.1,
        0.9,
        0.95,
        0.9,
        0.1,
        0.1,
        0.1,
      ]);
      final m = VideoModerator(
        capture: () async => _frame,
        detector: detector,
        report: (_, score) async => reports.add(score),
        now: () => now,
      );
      var changes = 0;
      m.addListener(() => changes++);

      await m.check(); // 0.95 alone: could be a misread, nothing happens
      expect(m.hidden, isFalse);
      await m.check(); // clean frame resets the count
      await m.check(); // 0.9 → first of a run
      expect(m.hidden, isFalse);
      expect(reports, isEmpty);
      await m.check(); // 0.95 → second in a row: hidden + report
      expect(m.hidden, isTrue);
      expect(reports, [0.95]);

      now = now.add(const Duration(seconds: 3));
      await m.check(); // 0.9 → still hidden, inside cooldown: no second report
      expect(reports, [0.95]);

      await m.check(); // clean 1
      await m.check(); // clean 2
      expect(m.hidden, isTrue);
      await m.check(); // clean 3 → visible again
      expect(m.hidden, isFalse);
      expect(changes, 2); // hidden once, shown once

      now = now.add(const Duration(seconds: 40));
      detector.scores
        ..clear()
        ..add(0.8);
      await m.check();
      await m.check(); // two in a row after the cooldown → reported again
      expect(reports, [0.95, 0.8]);
      m.dispose();
    },
  );

  test(
    'silent mode (1:1 calls) never blurs but still reports two in a row',
    () async {
      final reports = <double>[];
      final m = VideoModerator(
        capture: () async => _frame,
        detector: _FakeDetector([0.9, 0.95, 0.9]),
        report: (_, score) async => reports.add(score),
        silent: true,
      );
      var changes = 0;
      m.addListener(() => changes++);
      await m.check();
      expect(reports, isEmpty); // one flagged frame is not enough
      await m.check();
      expect(reports, [0.95]);
      expect(m.hidden, isFalse);
      expect(changes, 0); // the screen never changes
      m.dispose();
    },
  );

  test(
    'blurry or dark frames are not judged (they caused most false alarms)',
    () {
      img.Image scene({bool blur = false, int light = 255}) {
        final im = img.Image(width: 320, height: 240);
        for (var y = 0; y < 240; y++) {
          for (var x = 0; x < 320; x++) {
            final on = ((x ~/ 8) + (y ~/ 8)).isEven; // sharp checkerboard
            final v = on ? light : light ~/ 5;
            im.setPixelRgb(x, y, v, v, v);
          }
        }
        return blur ? img.gaussianBlur(im, radius: 12) : im;
      }

      PreparedFrame prep(img.Image i) =>
          prepareFrame(Uint8List.fromList(img.encodeJpg(i)))!;
      expect(usableFrame(prep(scene())), isTrue);
      expect(usableFrame(prep(scene(blur: true))), isFalse); // motion blur
      expect(usableFrame(prep(scene(light: 20))), isFalse); // dark room
    },
  );

  test(
    'a slow check is never overlapped, and failures never throw into the call',
    () async {
      final gate = Completer<Uint8List?>();
      var captures = 0;
      final m = VideoModerator(
        capture: () {
          captures++;
          return gate.future;
        },
        detector: _FakeDetector([0.1]),
        report: (_, _) async {},
      );
      final first = m.check();
      await m.check(); // skipped: the first one is still running
      expect(captures, 1);
      gate.complete(null); // no frame yet
      await first;

      final failing = VideoModerator(
        capture: () async => throw StateError('camera gone'),
        detector: _FakeDetector([0.9]),
        report: (_, _) async {},
      );
      await failing.check();
      expect(failing.hidden, isFalse);
      m.dispose();
      failing.dispose();
    },
  );

  test(
    'model input is 224×224×3 floats in 0–1, and the nudity score is porn + hentai',
    () {
      final source = img.Image(width: 640, height: 480)
        ..clear(img.ColorRgb8(255, 0, 128));
      final bytes = preprocess(Uint8List.fromList(img.encodeJpg(source)))!;
      final floats = bytes.buffer.asFloat32List();
      expect(floats.length, 224 * 224 * 3);
      expect(floats[0], closeTo(1.0, 0.02)); // red
      expect(floats[1], closeTo(0.0, 0.02)); // green
      expect(floats[2], closeTo(0.5, 0.02)); // blue
      expect(preprocess(Uint8List.fromList([1, 2, 3])), isNull);

      // labels: drawings, hentai, neutral, porn, sexy
      expect(nudityScore([0.0, 0.1, 0.2, 0.6, 0.1]), closeTo(0.7, 1e-9));
      expect(
        nudityScore([0.0, 0.0, 0.1, 0.0, 0.9]),
        0,
      ); // swimwear alone is not nudity

      final small = shrinkForUpload(
        Uint8List.fromList(img.encodeJpg(img.Image(width: 1280, height: 720))),
      );
      expect(img.decodeJpg(small)!.width, 480);
    },
  );
}
