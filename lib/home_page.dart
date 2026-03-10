import 'package:flutter/material.dart';
import 'package:flutter_application_7/request_pickup_page.dart';
import 'package:flutter_application_7/about_page.dart';
import 'package:flutter_application_7/help_page.dart';
import 'package:flutter_application_7/login_page.dart';
import 'package:flutter_application_7/lodgecomplaint_page.dart';
import 'package:flutter_application_7/pickuphistory_page.dart';
import 'package:flutter_application_7/pickupstatus_page.dart';
import 'package:flutter_application_7/recyclingguide_page.dart';
import 'package:flutter_application_7/viewschedule_page.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Static flag so banner shows only once per app run
  static bool hasShownBanner = false;
  bool showBanner = false;

  @override
  void initState() {
    super.initState();

    // Show banner only if it hasn't been shown yet
    if (!hasShownBanner) {
      showBanner = true;
      hasShownBanner = true;

      // Hide banner automatically after 2 seconds
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() => showBanner = false);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oikos'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
            child: const Text("About Us"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpPage()),
              );
            },
            child: const Text("Help"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LandingPage()),
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner shows only once per app run
              if (showBanner)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F766E), Color(0xFF10B981)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F766E).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Login successful! Welcome back.",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              const Text(
                "Resident Services",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Manage your waste and recycling easily.",
                style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    DashboardCard(
                      icon: Icons.local_shipping_outlined,
                      title: "Request Pickup",
                      subtitle: "Schedule bulk pickup",
                      gradientColors: const [
                        Color(0xFF0EA5E9),
                        Color(0xFF0284C7),
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RequestPickupPage(),
                        ),
                      ),
                    ),
                    DashboardCard(
                      icon: Icons.report_problem_outlined,
                      title: "Lodge Complaint",
                      subtitle: "Report issues",
                      gradientColors: const [
                        Color(0xFFF43F5E),
                        Color(0xFFE11D48),
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LodgeComplaintPage(),
                        ),
                      ),
                    ),
                    DashboardCard(
                      icon: Icons.calendar_today_outlined,
                      title: "View Schedule",
                      subtitle: "Check pickup dates",
                      gradientColors: const [
                        Color(0xFF8B5CF6),
                        Color(0xFF7C3AED),
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ViewSchedulePage(),
                        ),
                      ),
                    ),
                    DashboardCard(
                      icon: Icons.recycling_outlined,
                      title: "Recycling Guide",
                      subtitle: "What to recycle",
                      gradientColors: const [
                        Color(0xFF10B981),
                        Color(0xFF059669),
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RecyclingGuidePage(),
                        ),
                      ),
                    ),
                    DashboardCard(
                      icon: Icons.history_outlined,
                      title: "Pickup History",
                      subtitle: "Past pickups",
                      gradientColors: const [
                        Color(0xFFF59E0B),
                        Color(0xFFD97706),
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PickupHistoryPage(),
                        ),
                      ),
                    ),
                    DashboardCard(
                      icon: Icons.check_circle_outline,
                      title: "Pickup Status",
                      subtitle: "Check status",
                      gradientColors: const [
                        Color(0xFF0F766E),
                        Color(0xFF115E59),
                      ],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PickupStatusPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final List<Color> gradientColors;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          highlightColor: gradientColors[0].withOpacity(0.05),
          splashColor: gradientColors[0].withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: gradientColors[0].withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 28, color: Colors.white),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
