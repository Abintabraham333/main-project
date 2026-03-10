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
        title: const Text(
          'Garbage Collector Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Garbage Collector',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Manage your collection tasks',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Garbage Collector Features Grid
              const Text(
                'Your Tasks',
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
                    context: context,
                    icon: Icons.route,
                    title: 'Today\'s Route',
                    subtitle: 'View pickup locations',
                    color: Colors.green,
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.check_circle,
                    title: 'Mark Complete',
                    subtitle: 'Complete pickups',
                    color: Colors.blue,
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.error_outline,
                    title: 'Report Issues',
                    subtitle: 'Report problems',
                    color: Colors.red,
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.history,
                    title: 'History',
                    subtitle: 'Past collections',
                    color: Colors.purple,
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'New requests',
                    color: Colors.amber,
                  ),
                  _buildFeatureCard(
                    context: context,
                    icon: Icons.account_circle,
                    title: 'My Profile',
                    subtitle: 'Edit profile',
                    color: Colors.teal,
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      child: InkWell(
        onTap: () {
          if (title == "Today's Route") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TodaysRoutePage()),
            );
          } else if (title == 'Mark Complete') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MarkCompletePage()),
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
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: color),
              ),
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
