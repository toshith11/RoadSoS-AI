import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'camera_screen.dart';
import 'voice_screen.dart';

class GPSScreen extends StatefulWidget {
  const GPSScreen({super.key});

  @override
  State<GPSScreen> createState() => _GPSScreenState();
}

class _GPSScreenState extends State<GPSScreen> {
  String data = "Press button to get GPS";
  bool loading = false;

  Future<void> getGPS() async {
    setState(() {
      loading = true;
      data = "Fetching GPS...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      setState(() {
        loading = false;
        data = "GPS disabled";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position pos = await Geolocator.getCurrentPosition();

    setState(() {
      loading = false;
      data =
          "LAT: ${pos.latitude}\nLON: ${pos.longitude}\nTIME: ${DateTime.now()}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS Module")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(data, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: getGPS,
              child: const Text("Get GPS"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraScreen()),
                );
              },
              child: const Text("Open Camera (Photo + Video)"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VoiceScreen()),
                );
              },
              child: const Text("Open Voice Recorder"),
            ),
          ],
        ),
      ),
    );
  }
}