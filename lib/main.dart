import 'package:flutter/material.dart';
import 'module2/gps_screen.dart';

void main() {
  runApp(const RoadSOS());
}

class RoadSOS extends StatelessWidget {
  const RoadSOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "RoadSOS",
      theme: ThemeData(primarySwatch: Colors.red),
      home: const GPSScreen(),
    );
  }
}