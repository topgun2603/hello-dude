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
    final input = await compute(preprocess, jpeg);
    if (input == null) return 0;
    final output = Uint8List(_labels.length * 4);
    await _isolate.run(input, output);
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
@visibleForTesting
Uint8List? preprocess(Uint8List jpeg) {
  final decoded = _decode(jpeg);
  if (decoded == null) return null;
  final small = img.copyResize(
    decoded,
    width: _size,
    height: _size,
    interpolation: img.Interpolation.linear,
  );
  final floats = Float32List(_size * _size * 3);
  var i = 0;
  for (final p in small) {
    floats[i++] = p.r / 255.0;
    floats[i++] = p.g / 255.0;
    floats[i++] = p.b / 255.0;
  }
  return floats.buffer.asUint8List();
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
