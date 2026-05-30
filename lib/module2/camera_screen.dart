import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller!.initialize();
    setState(() {});
  }

  Future<void> _takePhoto() async {
    if (_controller == null) return;

    final image = await _controller!.takePicture();
    debugPrint("📸 Photo saved: ${image.path}");
  }

  Future<void> _toggleVideo() async {
    if (_controller == null) return;

    if (_isRecording) {
      final video = await _controller!.stopVideoRecording();
      debugPrint("🎥 Video saved: ${video.path}");
    } else {
      await _controller!.startVideoRecording();
      debugPrint("🎥 Recording started");
    }

    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera Module (Photo + Video)")),

      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: "photo",
                  onPressed: _takePhoto,
                  child: const Icon(Icons.camera_alt),
                ),

                FloatingActionButton(
                  heroTag: "video",
                  backgroundColor: _isRecording ? Colors.red : Colors.blue,
                  onPressed: _toggleVideo,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.videocam,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}