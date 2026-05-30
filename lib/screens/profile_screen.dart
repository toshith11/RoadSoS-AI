import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color rose = Color(0xFFD88C8C);
  static const Color blue = Color(0xFF7FA7C9);
  static const Color amber = Color(0xFFD9A86C);
  static const Color sage = Color(0xFF8FAF9B);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  int points = 150;
  int reports = 3;
  int verifiedReports = 2;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      points = prefs.getInt("citizen_points") ?? 0;
      reports = prefs.getInt("reports_submitted") ?? 0;
      verifiedReports = prefs.getInt("verified_reports") ?? 0;
    });
  }

  String getLevel() {
    if (points >= 1000) return "Emergency Hero";
    if (points >= 500) return "Safety Champion";
    if (points >= 300) return "Road Guardian";
    if (points >= 100) return "Community Reporter";
    return "Beginner Helper";
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
      body: SingleChildScrollView(
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

            const Text(
              "Citizen Reporter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              getLevel(),
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
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🎖️ Badges",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 15),

                  ListTile(
                    leading: Icon(Icons.verified),
                    title: Text("Verified Reporter"),
                  ),

                  ListTile(
                    leading: Icon(Icons.emergency),
                    title: Text("First Responder"),
                  ),

                  ListTile(
                    leading: Icon(Icons.shield),
                    title: Text("Road Guardian"),
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