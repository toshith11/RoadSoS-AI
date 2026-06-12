import 'dart:async';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {

  final Map<String, dynamic> analysisData;

  const AnalysisScreen({
    super.key,
    required this.analysisData,
  });

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  bool analysisCompleted = false;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      setState(() {
        analysisCompleted = true;
      });
    });
  }

  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color rose = Color(0xFFD88C8C);
  static const Color blue = Color(0xFF7FA7C9);
  static const Color sage = Color(0xFF8FAF9B);
  static const Color amber = Color(0xFFD9A86C);
  static const Color darkText = Color(0xFF3F3A37);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkText),
        title: const Text(
          "AI Analysis",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: analysisCompleted
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    const Icon(
                      Icons.verified_rounded,
                      color: sage,
                      size: 90,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Analysis Complete",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(height: 30),

                    ResultCard(
  title: "Severity",
  value: widget.analysisData["severity"].toString(),
  color: rose,
),

const SizedBox(height: 15),

ResultCard(
  title: "Victims Detected",
  value: widget.analysisData["victims_detected"].toString(),
  color: blue,
),

const SizedBox(height: 15),

ResultCard(
  title: "Required Services",
  value: (widget.analysisData["required_services"] as List)
      .join("\n"),
  color: amber,
),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [

                    CircularProgressIndicator(),

                    SizedBox(height: 30),

                    Text(
                      "Analyzing Video...",
                      style: TextStyle(fontSize: 18),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Analyzing Description...",
                      style: TextStyle(fontSize: 18),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "Analyzing Location...",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class ResultCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const ResultCard({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: color,
          width: 2,
        ),
      ),

      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}