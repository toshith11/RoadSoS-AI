import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const RoadSoSApp());
}

class RoadSoSApp extends StatelessWidget {
  const RoadSoSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RoadSoS',
      home: const HomeScreen(),
    );
  }
}