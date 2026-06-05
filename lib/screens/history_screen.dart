import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color rose = Color(0xFFD88C8C);
  static const Color blue = Color(0xFF7FA7C9);
  static const Color amber = Color(0xFFD9A86C);
  static const Color sage = Color(0xFF8FAF9B);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: darkText),
        title: const Text(
          "Report History",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: const [
          HistoryCard(
            title: "Bike Accident Report",
            date: "Today, 10:45 AM",
            severity: "High Severity",
            services: "Ambulance + Police",
            status: "Emergency team notified",
            color: rose,
            icon: Icons.local_hospital_rounded,
          ),
          SizedBox(height: 16),
          HistoryCard(
            title: "Car Collision Report",
            date: "Yesterday, 6:20 PM",
            severity: "Medium Severity",
            services: "Police",
            status: "Report verified",
            color: blue,
            icon: Icons.local_police_rounded,
          ),
          SizedBox(height: 16),
          HistoryCard(
            title: "Roadside Fire Report",
            date: "2 days ago, 8:10 PM",
            severity: "High Severity",
            services: "Fire Force + Police",
            status: "Resolved",
            color: amber,
            icon: Icons.local_fire_department_rounded,
          ),
          SizedBox(height: 16),
          HistoryCard(
            title: "Minor Road Incident",
            date: "Last week",
            severity: "Low Severity",
            services: "Under Review",
            status: "No emergency dispatch required",
            color: sage,
            icon: Icons.report_problem_rounded,
          ),
        ],
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  final String title;
  final String date;
  final String severity;
  final String services;
  final String status;
  final Color color;
  final IconData icon;

  const HistoryCard({
    super.key,
    required this.title,
    required this.date,
    required this.severity,
    required this.services,
    required this.status,
    required this.color,
    required this.icon,
  });

  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(date, style: const TextStyle(color: lightText)),
                const SizedBox(height: 12),
                Text("Severity: $severity"),
                Text("Services: $services"),
                Text("Status: $status"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}