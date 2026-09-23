import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app/theme.dart';
import '../../widgets/common.dart';

class SelfieResult {
  const SelfieResult(this.jpeg, this.blinks);
  final Uint8List jpeg;
  final int blinks;
}

/// Live selfie with an on-device liveness prompt: exactly one face, and two
/// blinks (both eyes closed, then open) before the photo is taken. Frames are
/// analysed locally with ML Kit; only the final photo is returned.
class SelfieCapture extends StatefulWidget {
  const SelfieCapture({super.key});

  @override
  State<SelfieCapture> createState() => _SelfieCaptureState();
}

class _SelfieCaptureState extends State<SelfieCapture> {
  static const _closed = 0.25, _open = 0.6, _needed = 2;

  CameraController? _cam;
  final _detector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );
  bool _busy = false, _eyesClosed = false, _capturing = false;
  int _blinks = 0, _faces = 0;
  String? _error;
  Uint8List? _photo;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    if (!(await Permission.camera.request()).isGranted) {
      setState(() => _error = 'Allow the camera to take your selfie');
      return;
    }
    try {
      final front = (await availableCameras()).firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      final cam = CameraController(
        front,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );
      await cam.initialize();
      if (!mounted) return cam.dispose();
      setState(() => _cam = cam);
      await cam.startImageStream(_onFrame);
    } catch (e) {
      setState(() => _error = 'Could not open the front camera');
    }
  }

  Future<void> _onFrame(CameraImage img) async {
    if (_busy || _capturing || _cam == null) return;
    _busy = true;
    try {
      final rotation =
          InputImageRotationValue.fromRawValue(
            _cam!.description.sensorOrientation,
          ) ??
          InputImageRotation.rotation270deg;
      final plane = img.planes.first;
      final faces = await _detector.processImage(
        InputImage.fromBytes(
          bytes: plane.bytes,
          metadata: InputImageMetadata(
            size: Size(img.width.toDouble(), img.height.toDouble()),
            rotation: rotation,
            format: InputImageFormat.nv21,
            bytesPerRow: plane.bytesPerRow,
          ),
        ),
      );
      if (!mounted) return;
      setState(() => _faces = faces.length);
      if (faces.length != 1) return;
      final l = faces.single.leftEyeOpenProbability,
          r = faces.single.rightEyeOpenProbability;
      if (l == null || r == null) return;
      if (!_eyesClosed && l < _closed && r < _closed) {
        _eyesClosed = true;
      } else if (_eyesClosed && l > _open && r > _open) {
        _eyesClosed = false;
        setState(() => _blinks++);
        if (_blinks >= _needed) await _capture();
      }
    } catch (e) {
      if (kDebugMode) debugPrint('face detection: $e');
    } finally {
      _busy = false;
    }
  }

  Future<void> _capture() async {
    _capturing = true;
    // Let the eyes settle open for a natural photo.
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await _cam!.stopImageStream();
    final file = await _cam!.takePicture();
    final bytes = await file.readAsBytes();
    if (mounted) setState(() => _photo = bytes);
  }

  void _retake() {
    setState(() {
      _photo = null;
      _blinks = 0;
      _eyesClosed = false;
      _capturing = false;
    });
    _cam?.startImageStream(_onFrame);
  }

  @override
  void dispose() {
    _cam?.dispose();
    _detector.close();
    super.dispose();
  }

  String get _prompt {
    if (_faces == 0) return 'Look at the camera';
    if (_faces > 1) return 'Only you in the frame, please';
    if (_blinks == 0) return 'Now blink twice';
    return 'One more blink';
  }

  @override
  Widget build(BuildContext context) {
    final cam = _cam;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  CircleIconButton(
                    icon: Icons.close_rounded,
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  Text('Take a quick selfie', style: AppText.heading(20)),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: _error != null
                    ? Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: AppText.body(16),
                        ),
                      )
                    : _photo != null
                    ? _Oval(child: Image.memory(_photo!, fit: BoxFit.cover))
                    : cam == null || !cam.value.isInitialized
                    ? const CircularProgressIndicator(color: Color(0xFF10B981))
                    : _Oval(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: cam.value.previewSize!.height,
                            height: cam.value.previewSize!.width,
                            child: CameraPreview(cam),
                          ),
                        ),
                      ),
              ),
            ),
            if (_photo == null && _error == null) ...[
              Semantics(
                liveRegion: true,
                child: Text(_prompt, style: AppText.heading(22)),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < _needed; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _blinks
                            ? const Color(0xFF10B981)
                            : Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 32),
            ] else if (_photo != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _retake,
                        child: const Text('Retake'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                        ),
                        onPressed: () => Navigator.pop(
                          context,
                          SelfieResult(_photo!, _blinks),
                        ),
                        child: const Text('Use this photo'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Oval extends StatelessWidget {
  const _Oval({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    width: 260,
    height: 340,
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.elliptical(130, 170)),
      border: Border.all(color: const Color(0xFF10B981), width: 3),
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.elliptical(128, 168)),
      child: SizedBox.expand(child: child),
    ),
  );
}
