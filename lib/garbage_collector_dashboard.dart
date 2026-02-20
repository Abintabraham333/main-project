import 'package:flutter/material.dart';
import 'login_page.dart';
import 'services/auth_service.dart';
import 'todays_route_page.dart';

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

              const SizedBox(height: 30),

              // Current Tasks Section
              const Text(
                'Assigned Pickups',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _buildPickupCard(
                zone: 'Zone A',
                address: '123 Main Street',
                status: 'Pending',
                icon: Icons.location_on,
              ),
              const SizedBox(height: 12),
              _buildPickupCard(
                zone: 'Zone B',
                address: '456 Oak Avenue',
                status: 'Completed',
                icon: Icons.check_circle,
              ),
              const SizedBox(height: 12),
              _buildPickupCard(
                zone: 'Zone C',
                address: '789 Elm Street',
                status: 'Pending',
                icon: Icons.location_on,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          if (title == "Today's Route") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TodaysRoutePage()),
            );
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

  Widget _buildPickupCard({
    required String zone,
    required String address,
    required String status,
    required IconData icon,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.orange, size: 32),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(status),
              backgroundColor: status == 'Completed'
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: status == 'Completed' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
