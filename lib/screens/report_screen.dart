import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'analysis_screen.dart';
import '../services/api_service.dart';

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

  final ApiService apiService = ApiService();
  final ImagePicker picker = ImagePicker();
  final TextEditingController descriptionController = TextEditingController();

  String videoStatus = "No video recorded yet";
  String locationStatus = "Location not fetched yet";

  XFile? recordedVideo;
  bool isSubmitting = false;
  bool isLocationFetched = false;

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> recordVideo() async {
    try {
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(seconds: 30),
      );

      if (video == null) {
        showMessage("Video recording cancelled");
        return;
      }

      setState(() {
        recordedVideo = video;
        videoStatus = "Video recorded successfully ✓";
      });

      showMessage("Video recorded successfully");
    } catch (e) {
      showMessage("Camera access failed or not supported on this device");
    }
  }

  Future<void> fetchLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showMessage("Please enable location services");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      showMessage("Location permission permanently denied");
      return;
    }

    if (permission == LocationPermission.denied) {
      showMessage("Location permission denied");
      return;
    }

    final position = await Geolocator.getCurrentPosition();

    setState(() {
      locationStatus =
          "Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)} ✓";
      isLocationFetched = true;
    });

    showMessage("Location fetched successfully");
  }

  Future<void> submitReport() async {
    if (recordedVideo == null) {
      showMessage("Please record accident video first");
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      showMessage("Please add accident description");
      return;
    }

    if (!isLocationFetched) {
      showMessage("Please fetch location");
      return;
    }

    setState(() {
      isSubmitting = true;
    });

    showMessage("Submitting accident report...");

    final response = await apiService.submitAccidentReport(
      description: descriptionController.text.trim(),
      location: locationStatus,
    );

    setState(() {
      isSubmitting = false;
    });

    if (response["success"] == true) {
      showMessage("Report submitted successfully");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AnalysisScreen(),
        ),
      );
    } else {
      showMessage("Failed to submit report");
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
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
              "Record accident video, add comments, and share location for AI analysis.",
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
              text: "Allow Camera & Record Video",
              icon: Icons.videocam_rounded,
              color: blue,
              onTap: recordVideo,
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
              text: isLocationFetched
                  ? "Location Captured ✓"
                  : "Fetch Current Location",
              icon: Icons.my_location_rounded,
              color: sage,
              onTap: fetchLocation,
            ),

            const SizedBox(height: 35),

            if (isSubmitting)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (isSubmitting) const SizedBox(height: 20),

            ActionButton(
              text: isSubmitting ? "Submitting..." : "Submit Accident Report",
              icon: Icons.send_rounded,
              color: rose,
              onTap: isSubmitting ? () {} : submitReport,
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