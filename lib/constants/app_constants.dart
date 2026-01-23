import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color backgroundColor = Color(0xFFF6F8F7);
  static const Color textDark = Colors.black87;
  static const Color textGrey = Colors.grey;

  // Contact Information
  static const String supportPhone = '+1-800-WASTE-911';
  static const String supportEmail = 'support@oikos.waste.com';
  static const String websiteUrl = 'www.oikos-waste.com';
  static const String linkedInUrl = '@oikos-waste-management';
  static const String twitterUrl = '@OikosWaste';
  static const String officeAddress = '123 Eco Park, Green City, GC 12345';

  // Support Hours
  static const String supportHours = 'Mon-Fri: 8:00 AM - 6:00 PM';

  // App Info
  static const String appName = 'Oikos';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Smart Waste Management for Sustainable Communities';
  static const String copyright = '© 2025 Oikos';

  // Demo Credentials
  static const Map<String, String> demoCredentials = {
    'resident': 'resident@demo.com|password123',
    'admin': 'admin@demo.com|admin123',
    'collector': 'collector@demo.com|collector123',
  };

  // Sizing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 3.0;

  // Features List
  static const List<Map<String, String>> appFeatures = [
    {'icon': '📍', 'title': 'Real-time Tracking', 'description': 'Track your waste pickups in real-time with GPS updates'},
    {'icon': '📅', 'title': 'Smart Scheduling', 'description': 'Never miss a collection day with automatic reminders'},
    {'icon': '♻️', 'title': 'Recycling Guide', 'description': 'Learn what can and cannot be recycled'},
    {'icon': '📞', 'title': 'Direct Contact', 'description': 'Call collectors directly from the app'},
    {'icon': '💬', 'title': 'Report Issues', 'description': 'File complaints and track their resolution'},
    {'icon': '📊', 'title': 'Waste Stats', 'description': 'View your waste patterns and recycling contributions'},
  ];

  // Team Members
  static const List<Map<String, String>> teamMembers = [
    {
      'name': 'Dr. Sarah Green',
      'role': 'Founder & CEO',
      'expertise': 'Environmental Science'
    },
    {
      'name': 'James Chen',
      'role': 'CTO',
      'expertise': 'Mobile & IoT Development'
    },
    {
      'name': 'Maria Rodriguez',
      'role': 'Operations Lead',
      'expertise': 'Waste Management'
    },
    {
      'name': 'Arun Patel',
      'role': 'Data Officer',
      'expertise': 'Analytics & Insights'
    },
  ];

  // Core Values
  static const List<Map<String, String>> coreValues = [
    {
      'title': 'Sustainability',
      'description': 'Environmental responsibility in every action'
    },
    {
      'title': 'Innovation',
      'description': 'Cutting-edge technology for waste management'
    },
    {
      'title': 'Transparency',
      'description': 'Clear communication with all stakeholders'
    },
    {
      'title': 'Community',
      'description': 'Building stronger communities together'
    },
  ];

  // Impact Statistics
  static const List<Map<String, String>> impactStats = [
    {'number': '50K+', 'label': 'Users Served'},
    {'number': '1000+', 'label': 'Tons Recycled'},
    {'number': '15', 'label': 'Cities Covered'},
    {'number': '98%', 'label': 'User Satisfaction'},
  ];

  // Tips
  static const List<String> wasteManagementTips = [
    'Place bins at curbside by 7 AM',
    'Keep recyclables clean and dry',
    'Remove plastic bags before composting',
    'Schedule pickups 24 hours in advance',
    'Keep hazardous waste separate',
    'Use biodegradable bags when possible',
  ];
}
