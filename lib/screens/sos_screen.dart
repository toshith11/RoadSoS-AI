import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String locationText = "Location not fetched yet";
  String phoneText = "Phone number not saved yet";

  final TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadPhoneNumber();
  }

  Future<void> loadPhoneNumber() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      phoneText =
          prefs.getString("phone") ?? "Phone number not saved yet";
    });
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
      phoneText = phone;
    });

    showMessage("Phone number saved successfully");
  }

  Future<void> getLocation() async {
    bool serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      showMessage("Enable location services");
      return;
    }

    LocationPermission permission =
        await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      showMessage(
          "Location permission permanently denied");
      return;
    }

    if (permission == LocationPermission.denied) {
      showMessage("Location permission denied");
      return;
    }

    Position position =
        await Geolocator.getCurrentPosition();

    setState(() {
      locationText =
          "Lat: ${position.latitude.toStringAsFixed(5)}, "
          "Lng: ${position.longitude.toStringAsFixed(5)}";
    });

    showMessage("Location fetched successfully");
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void sendRequest(String service) {

    if (locationText == "Location not fetched yet") {
      showMessage("Please fetch location first");
      return;
    }

    if (phoneText == "Phone number not saved yet") {
      showMessage("Please save phone number first");
      return;
    }

    showMessage("$service request sent successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme:
            const IconThemeData(color: darkText),

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
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "Share your location and phone number to request help.",
              style: TextStyle(
                fontSize: 16,
                color: lightText,
              ),
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
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Allow Location Access",
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

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,

              decoration: InputDecoration(
                hintText: "Enter phone number",

                filled: true,
                fillColor: Colors.white,

                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(18),
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
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Save Phone Number",
                ),
              ),
            ),

            const SizedBox(height: 30),

            HelpButton(
              text: "Request Ambulance",
              icon: Icons.local_hospital_rounded,
              color: ambulanceColor,
              onTap: () =>
                  sendRequest("Ambulance"),
            ),

            const SizedBox(height: 14),

            HelpButton(
              text: "Request Police",
              icon: Icons.local_police_rounded,
              color: policeColor,
              onTap: () =>
                  sendRequest("Police"),
            ),

            const SizedBox(height: 14),

            HelpButton(
              text: "Request Fire Force",
              icon:
                  Icons.local_fire_department_rounded,
              color: fireColor,
              onTap: () =>
                  sendRequest("Fire Force"),
            ),

            const SizedBox(height: 14),

            HelpButton(
              text: "Request All Services",
              icon: Icons.warning_amber_rounded,
              color: allServiceColor,
              onTap: () =>
                  sendRequest("All Services"),
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

  static const Color darkText =
      Color(0xFF3F3A37);

  static const Color lightText =
      Color(0xFF8B817C);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.05),
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

            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
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

        icon: Icon(
          icon,
          color: Colors.white,
        ),

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
            borderRadius:
                BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}