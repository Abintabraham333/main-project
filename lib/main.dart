import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'admin_dashboard.dart';
import 'garbage_collector_dashboard.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize auth service
  final authService = AuthService();
  await authService.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waste Management App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const AppInitializer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppInitializer extends StatelessWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUser = authService.currentUser;

    // Check if user is already logged in
    if (currentUser != null) {
      // Route to appropriate dashboard based on user type
      if (currentUser.userType == 'Admin') {
        return const AdminDashboardPage();
      } else if (currentUser.userType == 'Garbage Collector') {
        return const GarbageCollectorDashboardPage();
      } else {
        return const HomePage();
      }
    }

    // No logged-in user, show login page
    return const LandingPage();
  }
}

