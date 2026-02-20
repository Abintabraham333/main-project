import 'package:flutter/material.dart';
import 'login_page.dart';
import 'services/auth_service.dart';
import 'manage_pickups_page.dart';
import 'manage_complaints_page.dart';
import 'manage_users_page.dart';
import 'manage_zones_page.dart';

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
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.deepPurple, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Admin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'System Management & Oversight',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Admin Features Grid
              const Text(
                'Management Options',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildFeatureCard(
                    icon: Icons.people,
                    title: 'Users Management',
                    subtitle: 'Manage residents & collectors',
                    color: Colors.blue,
                  ),
                  _buildFeatureCard(
                    icon: Icons.report,
                    title: 'Complaints Review',
                    subtitle: 'View all complaints',
                    color: Colors.orange,
                  ),
                  _buildFeatureCard(
                    icon: Icons.schedule,
                    title: 'Pickup Schedule',
                    subtitle: 'Manage schedules',
                    color: Colors.green,
                  ),
                  _buildFeatureCard(
                    icon: Icons.analytics,
                    title: 'Statistics',
                    subtitle: 'View analytics',
                    color: Colors.purple,
                  ),
                  _buildFeatureCard(
                    icon: Icons.domain,
                    title: 'Zone Management',
                    subtitle: 'Manage zones & areas',
                    color: Colors.teal,
                  ),
                  _buildFeatureCard(
                    icon: Icons.settings,
                    title: 'System Settings',
                    subtitle: 'Configure system',
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Widget? page;
          switch (title) {
            case 'Users Management':
              page = const ManageUsersPage();
              break;
            case 'Complaints Review':
              page = const ManageComplaintsPage();
              break;
            case 'Pickup Schedule':
              page = const ManagePickupsPage();
              break;
            case 'Zone Management':
              page = const ManageZonesPage();
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
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
