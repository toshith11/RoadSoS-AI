import 'package:flutter/material.dart';
import 'sos_screen.dart';
import 'report_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color bgColor = Color(0xFFF8F5F2);
  static const Color primaryRose = Color(0xFFD98C8C);
  static const Color warmBrown = Color(0xFFB89B84);
  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 22),

              const Text(
                'RoadSoS',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: primaryRose,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Smart Emergency Response',
                style: TextStyle(
                  fontSize: 17,
                  color: lightText,
                ),
              ),

              const SizedBox(height: 42),

              EmergencyCard(
                title: 'I Need Help',
                subtitle:
                    'No login needed. Share location and request emergency help.',
                icon: Icons.emergency_rounded,
                iconColor: primaryRose,
                iconBgColor: Color(0xFFF6E1E1),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SOSScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 22),

              EmergencyCard(
                title: 'Report Accident Nearby',
                subtitle:
                    'Record accident video, add details and let AI decide required services.',
                icon: Icons.videocam_rounded,
                iconColor: warmBrown,
                iconBgColor: Color(0xFFEFE4DA),
               onTap: () {
                Navigator.push(
                   context,
                      MaterialPageRoute(
                        builder: (context) => const ReportScreen(),
                     ),
                    );
                  },
              ),

              const Spacer(),

              const Center(
                child: Text(
                  'Your Safety, Our Priority',
                  style: TextStyle(
                    color: lightText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmergencyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final VoidCallback onTap;

  const EmergencyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.onTap,
  });

  static const Color darkText = Color(0xFF3F3A37);
  static const Color lightText = Color(0xFF8B817C);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: iconBgColor,
              child: Icon(
                icon,
                color: iconColor,
                size: 36,
              ),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: darkText,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: lightText,
                      height: 1.35,
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
}