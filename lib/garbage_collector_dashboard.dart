import 'package:flutter/material.dart';
import 'login_page.dart';
import 'services/auth_service.dart';
import 'todays_route_page.dart';
import 'mark_complete_page.dart';
import 'collector_report_issue_page.dart';
import 'collector_history_page.dart';
import 'collector_notifications_page.dart';
import 'collector_profile_page.dart';

class GarbageCollectorDashboardPage extends StatelessWidget {
  const GarbageCollectorDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Garbage Collector'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authService = AuthService();
              await authService.logout();
              if (!context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LandingPage()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF59E0B),
                        Color(0xFFD97706),
                      ], // Warm Amber to Orange
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.work_outline,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your collection tasks for today.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Garbage Collector Features Grid
                const Text(
                  'Your Tasks',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                  children: [
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.route_outlined,
                      title: 'Today\'s Route',
                      subtitle: 'View pickup locations',
                      gradientColors: const [
                        Color(0xFF10B981),
                        Color(0xFF059669),
                      ], // Emerald
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.check_circle_outline,
                      title: 'Mark Complete',
                      subtitle: 'Complete pickups',
                      gradientColors: const [
                        Color(0xFF0EA5E9),
                        Color(0xFF0284C7),
                      ], // Light Blue
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.error_outline,
                      title: 'Report Issues',
                      subtitle: 'Report problems',
                      gradientColors: const [
                        Color(0xFFF43F5E),
                        Color(0xFFE11D48),
                      ], // Rose
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.history_outlined,
                      title: 'History',
                      subtitle: 'Past collections',
                      gradientColors: const [
                        Color(0xFF8B5CF6),
                        Color(0xFF7C3AED),
                      ], // Violet
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'New requests',
                      gradientColors: const [
                        Color(0xFFF59E0B),
                        Color(0xFFD97706),
                      ], // Amber
                    ),
                    _buildFeatureCard(
                      context: context,
                      icon: Icons.account_circle_outlined,
                      title: 'My Profile',
                      subtitle: 'Edit profile',
                      gradientColors: const [
                        Color(0xFF0F766E),
                        Color(0xFF115E59),
                      ], // Teal
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
  }) {
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
          onTap: () {
            if (title == "Today's Route") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TodaysRoutePage(),
                ),
              );
            } else if (title == 'Mark Complete') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MarkCompletePage(),
                ),
              );
            } else if (title == 'Report Issues') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectorReportIssuePage(),
                ),
              );
            } else if (title == 'History') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectorHistoryPage(),
                ),
              );
            } else if (title == 'Notifications') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectorNotificationsPage(),
                ),
              );
            } else if (title == 'My Profile') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CollectorProfilePage(),
                ),
              );
            }
          },
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
                        fontSize: 15,
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
