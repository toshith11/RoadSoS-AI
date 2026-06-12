import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService apiService = ApiService();
  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color rose = Color(0xFFD88C8C);
  static const Color blue = Color(0xFF7FA7C9);
  static const Color amber = Color(0xFFD9A86C);
  static const Color sage = Color(0xFF8FAF9B);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  

  String name = "Citizen Reporter";
  String level = "Beginner Helper";
  int points = 0;
  int reports = 0;
  int verifiedReports = 0;
  List<dynamic> badges = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final response = await apiService.getCitizenProfile();
    setState(() {
      isLoading = false;

      if (response["success"] == true) {
        name = response["name"] ?? "Citizen Reporter";
        points = response["points"] ?? 0;
        level = response["level"] ?? "Beginner Helper";
        reports = response["reports"] ?? 0;
        verifiedReports = response["verifiedReports"] ?? 0;
        badges = response["badges"] ?? [];
      }
    });
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
          "Citizen Profile",
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: rose,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    level,
                    style: const TextStyle(
                      color: lightText,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _buildStatCard(
                    "🏆 Total Points",
                    points.toString(),
                    amber,
                  ),

                  const SizedBox(height: 15),

                  _buildStatCard(
                    "📹 Reports Submitted",
                    reports.toString(),
                    blue,
                  ),

                  const SizedBox(height: 15),

                  _buildStatCard(
                    "🚨 Verified Reports",
                    verifiedReports.toString(),
                    sage,
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "🎖️ Badges",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        if (badges.isEmpty)
                          const Text(
                            "No badges earned yet",
                            style: TextStyle(
                              color: lightText,
                              fontSize: 15,
                            ),
                          )
                        else
                          ...badges.map(
                            (badge) => ListTile(
                              leading: const Icon(Icons.verified),
                              title: Text(badge.toString()),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color,
  ) {
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
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}