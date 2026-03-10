import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'admin_dashboard.dart';
import 'garbage_collector_dashboard.dart';
import 'services/auth_service.dart';

import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        useMaterial3: true,
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F766E), // Deep Teal
          primary: const Color(0xFF0F766E),
          secondary: const Color(0xFF0EA5E9), // Light Blue for accents
          tertiary: const Color(0xFF10B981), // Emerald
          surface: const Color(0xFFF0FDF4), // Very light mint surface
          onSurface: const Color(0xFF0F172A), // Slate 900
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Slate 50 background
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent, // Modern transparent appbar
          foregroundColor: Color(0xFF0F172A),
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0F172A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shadowColor: const Color(0xFF0F766E).withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide.none, // Remove border, use shadow instead
          ),
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
                elevation: 4,
                shadowColor: const Color(0xFF0F766E).withOpacity(0.3),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, // Bolder
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith(
                  (states) => Colors.white.withOpacity(0.15),
                ),
              ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hoverColor: const Color(0xFFF1F5F9),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none, // Sleek borderless look
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
          ),
          labelStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        ),
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

    return AnimatedBuilder(
      animation: authService,
      builder: (context, _) {
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
      },
    );
  }
}
