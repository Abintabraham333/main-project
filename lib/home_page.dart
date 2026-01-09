import 'package:flutter/material.dart';
import 'package:flutter_application_7/Requestpickuppage.dart';
import 'package:flutter_application_7/lodgecomplaint_page.dart';
import 'package:flutter_application_7/pickuphistory_page.dart';
import 'package:flutter_application_7/recyclingguide_page.dart';
import 'package:flutter_application_7/viewschedule_page.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Oikos',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F6F7),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool showBanner = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => showBanner = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Oikos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        actions: const [
          TextButton(
            onPressed: null,
            child: Text("Home", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: null,
            child: Text("About Us", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: null,
            child: Text("Help", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: null,
            child: Text("Logout", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (showBanner)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "✓ Login successful! Welcome back.",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 16),

            const Text(
              "Resident Services Dashboard",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  DashboardCard(
                    icon: Icons.local_shipping,
                    title: "Request Pickup",
                    subtitle: "Schedule bulk pickup",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RequestPickupPage(),
                      ),
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.report_problem,
                    title: "Lodge Complaint",
                    subtitle: "Report issues",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LodgeComplaintPage(),
                      ),
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.calendar_today,
                    title: "View Schedule",
                    subtitle: "Check pickup dates",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ViewSchedulePage(),
                      ),
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.recycling,
                    title: "Recycling Guide",
                    subtitle: "What to recycle",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RecyclingGuidePage(),
                      ),
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.history,
                    title: "Pickup History",
                    subtitle: "Past pickups",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PickupHistoryPage(),
                      ),
                    ),
                  ),
                  DashboardCard(
                    icon: Icons.check_circle,
                    title: "Pickup Status",
                    subtitle: "Check status",
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const PickupHistoryPage(),
                      ),
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

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[600], fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
