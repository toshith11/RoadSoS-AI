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
    initCamera();
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    _controller = CameraController(
      cameras.first,
      ResolutionPreset.high,
      enableAudio: true,
    );

    await _controller!.initialize();
    setState(() {});
  }

  Future<void> takePhoto() async {
    final file = await _controller!.takePicture();
    debugPrint("PHOTO: ${file.path}");
  }

  Future<void> toggleVideo() async {
    if (_isRecording) {
      final file = await _controller!.stopVideoRecording();
      debugPrint("VIDEO: ${file.path}");
    } else {
      await _controller!.startVideoRecording();
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
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Column(
        children: [
          Expanded(child: CameraPreview(_controller!)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: takePhoto,
                child: const Icon(Icons.camera_alt),
              ),

              FloatingActionButton(
                onPressed: toggleVideo,
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
                child: Icon(_isRecording ? Icons.stop : Icons.videocam),
              ),
            ],
          )
        ],
      ),
    );
  }
}