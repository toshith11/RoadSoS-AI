import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  static const Color bgColor = Color(0xFFF7F4F2);
  static const Color ambulanceColor = Color(0xFFD88C8C);
  static const Color policeColor = Color(0xFF7FA7C9);
  static const Color fireColor = Color(0xFFD9A86C);
  static const Color allServiceColor = Color(0xFF4B4542);
  static const Color locationColor = Color(0xFF8FAF9B);
  static const Color savePhoneColor = Color(0xFFB7A0C9);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  final ApiService apiService = ApiService();
  final TextEditingController phoneController = TextEditingController();

  String locationText = "Location not fetched yet";
  String phoneText = "Phone number not saved yet";

  bool isLocationFetched = false;
  bool isPhoneSaved = false;
  bool isSending = false;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    loadPhoneNumber();
  }

  Future<void> loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPhone = prefs.getString("phone");

    if (savedPhone != null && savedPhone.isNotEmpty) {
      setState(() {
        phoneText = "$savedPhone ✓";
        phoneController.text = savedPhone;
        isPhoneSaved = true;
      });
    }
  }

  Future<void> savePhoneNumber() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      showMessage("Please enter phone number");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("phone", phone);

    setState(() {
      phoneText = "$phone ✓";
      isPhoneSaved = true;
    });

    showMessage("Phone number saved successfully");
  }

  Future<void> getLocation() async {
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
      latitude = position.latitude;
      longitude = position.longitude;

      locationText =
          "Lat: ${position.latitude.toStringAsFixed(5)}, Lng: ${position.longitude.toStringAsFixed(5)} ✓";

      isLocationFetched = true;
    });

    showMessage("Location fetched successfully");
  }

  Future<void> sendRequest(String service) async {
    if (!isLocationFetched || latitude == null || longitude == null) {
      showMessage("Please fetch location first");
      return;
    }

    if (!isPhoneSaved) {
      showMessage("Please save phone number first");
      return;
    }

    setState(() {
      isSending = true;
    });

    showMessage("Sending $service request...");

    final response = await apiService.sendSOSRequest(
  latitude: latitude!,
  longitude: longitude!,
  phone: phoneController.text.trim(),
  service: service,
);

    setState(() {
      isSending = false;
    });

    if (response["success"] == true) {
      showMessage(
        "${response["message"] ?? "$service request sent"}. ETA: ${response["eta"] ?? "Not available"}",
      );
    } else {
      showMessage(
        response["message"] ?? "Failed to send $service request",
      );
    }
  }

  void editPhoneNumber() {
    setState(() {
      isPhoneSaved = false;
      phoneText = "Update your phone number";
    });
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
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
          "Emergency Help",
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
              "Share your location and phone number to request help.",
              style: TextStyle(fontSize: 16, color: lightText),
            ),

            const SizedBox(height: 25),

            InfoCard(
              icon: Icons.location_on_rounded,
              title: "Current Location",
              subtitle: locationText,
              iconColor: locationColor,
              bgColor: const Color(0xFFE8F1EB),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: getLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: locationColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  isLocationFetched
                      ? "Location Captured ✓"
                      : "Allow Location Access",
                ),
              ),
            ),

            const SizedBox(height: 25),

            InfoCard(
              icon: Icons.phone_rounded,
              title: "Phone Number",
              subtitle: phoneText,
              iconColor: savePhoneColor,
              bgColor: const Color(0xFFF0EBF6),
            ),

            const SizedBox(height: 12),

            if (!isPhoneSaved) ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: "Enter phone number",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: savePhoneNumber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: savePhoneColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text("Save Phone Number"),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: editPhoneNumber,
                  icon: const Icon(Icons.edit_rounded),
                  label: const Text("Edit Phone Number"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: savePhoneColor,
                    side: const BorderSide(color: savePhoneColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 30),

            if (isSending)
              const Center(
                child: CircularProgressIndicator(),
              ),

            if (isSending) const SizedBox(height: 20),

            HelpButton(
              text: "Request Ambulance",
              icon: Icons.local_hospital_rounded,
              color: ambulanceColor,
              onTap: () => sendRequest("Ambulance"),
            ),

            const SizedBox(height: 14),

            HelpButton(
              text: "Request Police",
              icon: Icons.local_police_rounded,
              color: policeColor,
              onTap: () => sendRequest("Police"),
            ),

            const SizedBox(height: 14),

            HelpButton(
              text: "Request Fire Force",
              icon: Icons.local_fire_department_rounded,
              color: fireColor,
              onTap: () => sendRequest("Fire Force"),
            ),

            const SizedBox(height: 14),

            HelpButton(
              text: "Request Trauma",
              icon: Icons.warning_amber_rounded,
              color: allServiceColor,
              onTap: () => sendRequest("Trauma"),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconColor;
  final Color bgColor;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconColor,
    required this.bgColor,
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
            backgroundColor: bgColor,
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

class HelpButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HelpButton({
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