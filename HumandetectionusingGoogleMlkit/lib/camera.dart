import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:permission_handler/permission_handler.dart';

/// A StatefulWidget that opens the camera and performs face detection in real-time.
class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;

  final FaceDetector _detector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isDetecting = false;
  List<Face> _faces = [];
  Size? _imageSize;
  CameraLensDirection? _cameraLensDirection;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _initializeCameras();
  }

  @override
  void dispose() {
    _controller?.stopImageStream().catchError((_) {});
    _controller?.dispose();
    _detector.close();
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      debugPrint('Camera permission denied');
    }
  }

  Future<void> _initializeCameras() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        debugPrint('No cameras found on this device');
        return;
      }

      // Prefer front camera
      _selectedCameraIndex = _cameras.indexWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      if (_selectedCameraIndex == -1) {
        _selectedCameraIndex = 0;
      }

      await _initCamera(_cameras[_selectedCameraIndex]);
    } catch (e) {
      debugPrint('Error initializing cameras: $e');
    }
  }

  Future<void> _initCamera(CameraDescription cameraDescription) async {
    // Dispose previous controller if exists
    await _controller?.stopImageStream().catchError((_) {});
    await _controller?.dispose();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21, // Explicitly set NV21 format
    );

    _cameraLensDirection = cameraDescription.lensDirection;

    try {
      await _controller!.initialize();

      if (!mounted) return;

      setState(() {
        _initializeControllerFuture = Future.value();
      });

      // Start image stream
      await _controller!.startImageStream((CameraImage image) async {
        if (_isDetecting) return;

        _isDetecting = true;

        try {
          final inputImage = _convertCameraImage(image, cameraDescription);
          final faces = await _detector.processImage(inputImage);

          if (mounted) {
            setState(() {
              _faces = faces;
              _imageSize = Size(
                image.width.toDouble(),
                image.height.toDouble(),
              );
            });
          }
        } catch (e) {
          debugPrint('Error detecting faces: $e');
        } finally {
          _isDetecting = false;
        }
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  InputImage _convertCameraImage(
      CameraImage image,
      CameraDescription cameraDescription,
      ) {
    // Get image rotation based on device orientation
    final sensorOrientation = cameraDescription.sensorOrientation;
    InputImageRotation? rotation;

    if (defaultTargetPlatform == TargetPlatform.android) {
      var rotationCompensation = sensorOrientation;

      // Front camera needs additional rotation compensation
      if (cameraDescription.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + 90) % 360;
      }

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    }

    if (rotation == null) {
      rotation = InputImageRotation.rotation0deg;
    }

    // Get image format
    InputImageFormat? format;
    if (defaultTargetPlatform == TargetPlatform.android) {
      format = InputImageFormat.nv21;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      format = InputImageFormat.bgra8888;
    } else {
      format = InputImageFormat.nv21;
    }

    // Concatenate plane bytes
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  Future<void> _toggleCamera() async {
    if (_cameras.length < 2) {
      debugPrint('Only one camera found');
      return;
    }

    final newIndex = (_selectedCameraIndex + 1) % _cameras.length;

    setState(() {
      _selectedCameraIndex = newIndex;
      _faces = []; // Clear faces when switching
    });

    await _initCamera(_cameras[_selectedCameraIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection Camera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: _controller == null || !_controller!.value.isInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),
          if (_imageSize != null && _cameraLensDirection != null)
            CustomPaint(
              painter: FacePainter(
                _faces,
                _imageSize!,
                _cameraLensDirection!,
                _controller!.value.previewSize!,
              ),
            ),
          // Face count overlay
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Faces detected: ${_faces.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws rectangles around detected faces with proper coordinate transformation
class FacePainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final CameraLensDirection cameraLensDirection;
  final Size previewSize;

  FacePainter(
      this.faces,
      this.imageSize,
      this.cameraLensDirection,
      this.previewSize,
      );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    for (Face face in faces) {
      final rect = _scaleRect(
        rect: face.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
        cameraLensDirection: cameraLensDirection,
      );

      canvas.drawRect(rect, paint);

      // Draw face ID (optional)
      if (face.trackingId != null) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'ID: ${face.trackingId}',
            style: const TextStyle(
              color: Colors.greenAccent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(rect.left, rect.top - 20));
      }
    }
  }

  Rect _scaleRect({
    required Rect rect,
    required Size imageSize,
    required Size widgetSize,
    required CameraLensDirection cameraLensDirection,
  }) {
    final scaleX = widgetSize.width / imageSize.height;
    final scaleY = widgetSize.height / imageSize.width;

    if (cameraLensDirection == CameraLensDirection.front) {
      // Front camera: mirror horizontally
      return Rect.fromLTRB(
        widgetSize.width - rect.top * scaleX,
        rect.left * scaleY,
        widgetSize.width - rect.bottom * scaleX,
        rect.right * scaleY,
      );
    } else {
      // Back camera
      return Rect.fromLTRB(
        rect.top * scaleX,
        rect.left * scaleY,
        rect.bottom * scaleX,
        rect.right * scaleY,
      );
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.faces != faces ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.cameraLensDirection != cameraLensDirection ||
        oldDelegate.previewSize != previewSize;
  }
}