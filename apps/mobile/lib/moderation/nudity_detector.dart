import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

/// Scores a video frame for nudity, on the phone. Nothing is sent anywhere.
abstract class NudityDetector {
  /// 0 (clearly fine) … 1 (clearly nudity) for a JPEG frame.
  Future<double> score(Uint8List jpeg);
  void dispose();
}

/// GantMan/nsfw_model 1.2.0 (MIT): MobileNet v2, 224×224 RGB scaled to 0–1,
/// five outputs in this order.
const _labels = ['drawings', 'hentai', 'neutral', 'porn', 'sexy'];
const _size = 224;
const modelAsset = 'assets/models/nsfw_mobilenet_v2_140_224.tflite';

/// Frames the model can't judge are skipped (score 0): motion blur and dark
/// rooms were ~90% of false alarms (owner report 2026-09-24 — two blurry room
/// shots scored 0.86 and 0.98). Sharpness = variance of the Laplacian on the
/// 224×224 grey image: clear frames ~300–1200, those false alarms ~30.
const minSharpness = 80.0;
const minBrightness = 30.0; // mean grey level 0–255

/// A frame ready for the model, with how clear it is.
typedef PreparedFrame = ({
  Uint8List input,
  double sharpness,
  double brightness,
});

bool usableFrame(PreparedFrame f) =>
    f.sharpness >= minSharpness && f.brightness >= minBrightness;

/// Nudity = porn + hentai. "sexy" (swimwear, lingerie) alone is not flagged.
double nudityScore(List<double> probs) =>
    probs[_labels.indexOf('porn')] + probs[_labels.indexOf('hentai')];

class TfliteNudityDetector implements NudityDetector {
  TfliteNudityDetector._(this._interpreter, this._isolate);

  final Interpreter _interpreter;
  final IsolateInterpreter _isolate;

  static Future<TfliteNudityDetector> load() async {
    final interpreter = await Interpreter.fromAsset(
      modelAsset,
      options: InterpreterOptions()..threads = 2,
    );
    final isolate = await IsolateInterpreter.create(
      address: interpreter.address,
    );
    return TfliteNudityDetector._(interpreter, isolate);
  }

  @override
  Future<double> score(Uint8List jpeg) async {
    // Decode + resize off the UI thread too.
    final frame = await compute(prepareFrame, jpeg);
    // Blurry or dark: the model can't judge it, so it doesn't count.
    if (frame == null || !usableFrame(frame)) return 0;
    final output = Uint8List(_labels.length * 4);
    await _isolate.run(frame.input, output);
    final probs = output.buffer
        .asFloat32List()
        .map((v) => v.toDouble())
        .toList();
    return nudityScore(probs).clamp(0, 1).toDouble();
  }

  @override
  void dispose() {
    _isolate.close();
    _interpreter.close();
  }
}

/// JPEG → 224×224×3 float32 bytes (RGB / 255), or null if it can't be decoded.
/// (The model itself maps 0–1 to −1…1: its first ops are ×2 and −1.)
@visibleForTesting
Uint8List? preprocess(Uint8List jpeg) => prepareFrame(jpeg)?.input;

/// Model input plus sharpness and brightness, or null if it can't be decoded.
PreparedFrame? prepareFrame(Uint8List jpeg) {
  final decoded = _decode(jpeg);
  if (decoded == null) return null;
  final small = img.copyResize(
    decoded,
    width: _size,
    height: _size,
    interpolation: img.Interpolation.linear,
  );
  final floats = Float32List(_size * _size * 3);
  final grey = Float32List(_size * _size);
  var i = 0, g = 0;
  var sum = 0.0;
  for (final p in small) {
    floats[i++] = p.r / 255.0;
    floats[i++] = p.g / 255.0;
    floats[i++] = p.b / 255.0;
    final y = 0.299 * p.r + 0.587 * p.g + 0.114 * p.b;
    grey[g++] = y;
    sum += y;
  }
  return (
    input: floats.buffer.asUint8List(),
    sharpness: laplacianVariance(grey, _size),
    brightness: sum / grey.length,
  );
}

/// Variance of the 4-neighbour Laplacian: low = blurry.
@visibleForTesting
double laplacianVariance(Float32List grey, int size) {
  var n = 0;
  var mean = 0.0, m2 = 0.0;
  for (var y = 1; y < size - 1; y++) {
    for (var x = 1; x < size - 1; x++) {
      final c = y * size + x;
      final v =
          4 * grey[c] -
          grey[c - 1] -
          grey[c + 1] -
          grey[c - size] -
          grey[c + size];
      n++;
      final d = v - mean;
      mean += d / n;
      m2 += d * (v - mean);
    }
  }
  return n > 1 ? m2 / n : 0;
}

/// The image package throws on corrupt data rather than returning null.
img.Image? _decode(Uint8List jpeg) {
  try {
    return img.decodeJpg(jpeg);
  } catch (_) {
    return null;
  }
}

/// Smaller JPEG of a flagged frame for the safety team (keeps uploads light).
Uint8List shrinkForUpload(Uint8List jpeg) {
  final decoded = _decode(jpeg);
  if (decoded == null) return jpeg;
  final resized = decoded.width > 480
      ? img.copyResize(decoded, width: 480)
      : decoded;
  return img.encodeJpg(resized, quality: 70);
}

Future<NudityDetector>? _shared;

/// One detector for the whole app session: the model loads on the first video
/// call (~0.3 s) and stays in memory. A failed load is retried next call.
Future<NudityDetector> sharedNudityDetector() {
  return _shared ??= TfliteNudityDetector.load()
      .then<NudityDetector>((d) => d)
      .catchError((Object e) {
        _shared = null;
        throw e;
      });
}
