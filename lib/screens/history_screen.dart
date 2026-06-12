import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color rose = Color(0xFFD88C8C);
  static const Color blue = Color(0xFF7FA7C9);
  static const Color amber = Color(0xFFD9A86C);
  static const Color sage = Color(0xFF8FAF9B);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  final ApiService apiService = ApiService();

  bool isLoading = true;
  List<dynamic> incidents = [];

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final data = await apiService.getIncidentHistory();

    setState(() {
      incidents = data;
      isLoading = false;
    });
  }

  String getServices(dynamic services) {
    if (services == null) return "Not Available";

    if (services is List) {
      return services.join(" + ");
    }

    return services.toString();
  }

  Color getColor(String severity) {
    final value = severity.toLowerCase();

    if (value.contains("high") || value.contains("major")) {
      return rose;
    } else if (value.contains("medium")) {
      return blue;
    } else if (value.contains("fire")) {
      return amber;
    } else {
      return sage;
    }
  }

  IconData getIcon(String services) {
    final value = services.toLowerCase();

    if (value.contains("ambulance")) {
      return Icons.local_hospital_rounded;
    } else if (value.contains("police")) {
      return Icons.local_police_rounded;
    } else if (value.contains("fire")) {
      return Icons.local_fire_department_rounded;
    } else {
      return Icons.report_problem_rounded;
    }
  }

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : incidents.isEmpty
              ? const Center(
                  child: Text(
                    "No incident history found",
                    style: TextStyle(
                      color: lightText,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(22),
                  itemCount: incidents.length,
                  itemBuilder: (context, index) {
                    final incident = incidents[index];

                    final title =
                        incident["description"]?.toString() ??
                            "Accident Report";

                    final date =
                        incident["timestamp"]?.toString() ??
                            "Date not available";

                    final severity =
                        incident["severity"]?.toString() ??
                            incident["category"]?.toString() ??
                            "Not Available";

                    final services = getServices(
                      incident["required_services"] ??
                          incident["services"],
                    );

                    final status =
                        incident["status"]?.toString() ??
                            "Pending";

                    final color = getColor(severity);
                    final icon = getIcon(services);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: HistoryCard(
                        title: title,
                        date: date,
                        severity: severity,
                        services: services,
                        status: status,
                        color: color,
                        icon: icon,
                      ),
                    );
                  },
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
                Text(
                  date,
                  style: const TextStyle(color: lightText),
                ),
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