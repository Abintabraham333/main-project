import 'package:flutter/material.dart';
import 'login_page.dart';
import 'services/auth_service.dart';
import 'manage_pickups_page.dart';
import 'manage_complaints_page.dart';
import 'manage_users_page.dart';
import 'manage_zones_page.dart';
import 'manage_collector_reports_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
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
                        Color(0xFF6366F1),
                        Color(0xFF4338CA),
                      ], // Indigo gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4338CA).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome, Admin',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'System Management & Oversight',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Admin Features Grid
                const Text(
                  'Management Options',
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
                      icon: Icons.people_outline,
                      title: 'Users Management',
                      subtitle: 'Manage roles & access',
                      gradientColors: const [
                        Color(0xFF0EA5E9),
                        Color(0xFF0284C7),
                      ], // Sky Blue
                    ),
                    _buildFeatureCard(
                      icon: Icons.report_outlined,
                      title: 'Complaints',
                      subtitle: 'Review user issues',
                      gradientColors: const [
                        Color(0xFFF59E0B),
                        Color(0xFFD97706),
                      ], // Amber
                    ),
                    _buildFeatureCard(
                      icon: Icons.warning_amber_rounded,
                      title: 'GC Reports',
                      subtitle: 'View field issues',
                      gradientColors: const [
                        Color(0xFFF43F5E),
                        Color(0xFFE11D48),
                      ], // Rose
                    ),
                    _buildFeatureCard(
                      icon: Icons.schedule_outlined,
                      title: 'Pickup Schedule',
                      subtitle: 'Manage schedules',
                      gradientColors: const [
                        Color(0xFF10B981),
                        Color(0xFF059669),
                      ], // Emerald
                    ),
                    _buildFeatureCard(
                      icon: Icons.analytics_outlined,
                      title: 'Statistics',
                      subtitle: 'View system analytics',
                      gradientColors: const [
                        Color(0xFF8B5CF6),
                        Color(0xFF7C3AED),
                      ], // Violet
                    ),
                    _buildFeatureCard(
                      icon: Icons.domain_outlined,
                      title: 'Zone Mgmt',
                      subtitle: 'Manage areas',
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
            Widget? page;
            switch (title) {
              case 'Users Management':
                page = const ManageUsersPage();
                break;
              case 'Complaints':
                page = const ManageComplaintsPage();
                break;
              case 'Pickup Schedule':
                page = const ManagePickupsPage();
                break;
              case 'Zone Mgmt':
                page = const ManageZonesPage();
                break;
              case 'GC Reports':
                page = const ManageCollectorReportsPage();
                break;
              // Add other cases as implemented
            }

            if (page != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => page!),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Coming Soon!")));
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
