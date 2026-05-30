import 'package:flutter/material.dart';
import 'analysis_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color rose = Color(0xFFD88C8C);
  static const Color blue = Color(0xFF7FA7C9);
  static const Color sage = Color(0xFF8FAF9B);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  final TextEditingController descriptionController = TextEditingController();

  String videoStatus = "No video selected";
  String locationStatus = "Location not fetched yet";

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void selectVideo() {
    setState(() {
      videoStatus = "accident_video.mp4 selected";
    });
    showMessage("Video selected for demo");
  }

  void fetchLocation() {
    setState(() {
      locationStatus = "Lat: 12.97160, Lng: 77.59460";
    });
    showMessage("Location fetched for demo");
  }

  void submitReport() {
    if (videoStatus == "No video selected") {
      showMessage("Please upload accident video");
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      showMessage("Please add accident description");
      return;
    }

    if (locationStatus == "Location not fetched yet") {
      showMessage("Please fetch location");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AnalysisScreen(),
      ),
    );
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
          "Report Accident",
          style: TextStyle(
            color: darkText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload video, add comments, and share location for AI analysis.",
              style: TextStyle(fontSize: 16, color: lightText),
            ),

            const SizedBox(height: 25),

            ReportCard(
              icon: Icons.videocam_rounded,
              title: "Accident Video",
              subtitle: videoStatus,
              iconColor: rose,
              iconBgColor: const Color(0xFFF6E1E1),
            ),

            const SizedBox(height: 12),

            ActionButton(
              text: "Upload / Record Video",
              icon: Icons.video_call_rounded,
              color: blue,
              onTap: selectVideo,
            ),

            const SizedBox(height: 25),

            const Text(
              "Accident Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText:
                    "Example: A bike collided with a car. One person seems injured.",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            ReportCard(
              icon: Icons.location_on_rounded,
              title: "Accident Location",
              subtitle: locationStatus,
              iconColor: sage,
              iconBgColor: const Color(0xFFE8F1EB),
            ),

            const SizedBox(height: 12),

            ActionButton(
              text: "Fetch Current Location",
              icon: Icons.my_location_rounded,
              color: sage,
              onTap: fetchLocation,
            ),

            const SizedBox(height: 35),

            ActionButton(
              text: "Submit Accident Report",
              icon: Icons.send_rounded,
              color: rose,
              onTap: submitReport,
            ),
          ],
        ),
      ),
    );
  }
}

class ReportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color iconBgColor;

  const ReportCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.iconBgColor,
  });

  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: iconBgColor,
            child: Icon(icon, color: iconColor, size: 30),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: lightText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}