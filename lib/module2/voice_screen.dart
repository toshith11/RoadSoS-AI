import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  FlutterSoundRecorder? recorder;
  bool isRecording = false;
  String? filePath;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  Future<void> initRecorder() async {
    recorder = FlutterSoundRecorder();
    await recorder!.openRecorder();

    await Permission.microphone.request();
    setState(() {});
  }

  Future<void> startRecording() async {
    final dir = await getApplicationDocumentsDirectory();
    filePath = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

    await recorder!.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );

    setState(() {
      isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    await recorder!.stopRecorder();

    setState(() {
      isRecording = false;
    });

    print("VOICE SAVED: $filePath");
  }

  @override
  void dispose() {
    recorder?.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Module"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isRecording ? "🎙 Recording..." : "Ready to record",
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: isRecording ? null : startRecording,
              child: const Text("Start Recording"),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: isRecording ? stopRecording : null,
              child: const Text("Stop Recording"),
            ),

            const SizedBox(height: 20),

            if (filePath != null)
              Text(
                "Saved: $filePath",
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}