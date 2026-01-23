import 'package:flutter/material.dart';
import 'constants/app_constants.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: AppConstants.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: AppConstants.backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              "Help & Support",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryGreen,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Find answers to common questions and get assistance",
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Contact Support Card - Link to dedicated section
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Could navigate to dedicated contact page or show dialog
                  _showContactDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "📞 Need Immediate Support?",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryGreen,
                        ),
                      ),
                      const Divider(height: 16),
                      const Text(
                        "Contact our support team directly for urgent issues",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, color: AppConstants.primaryGreen),
                          const SizedBox(width: 8),
                          Text(
                            AppConstants.supportPhone,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward, color: Colors.grey),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Links Card
            _buildQuickLinksCard(),
            const SizedBox(height: 20),

            // FAQ Card
            _buildFAQCard(),
            const SizedBox(height: 20),

            // App Features Card
            _buildFeaturesCard(),
            const SizedBox(height: 20),

            // Tips & Best Practices Card
            _buildTipsCard(),
            const SizedBox(height: 20),

            // Account & Privacy Card
            _buildAccountCard(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('📞 Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${AppConstants.supportPhone}'),
            const SizedBox(height: 8),
            Text('Email: ${AppConstants.supportEmail}'),
            const SizedBox(height: 8),
            Text('Hours: ${AppConstants.supportHours}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinksCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "⚡ Quick Links",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const Divider(height: 16),
            _quickLinkButton("View My Pickup Schedule", Icons.calendar_today),
            const SizedBox(height: 8),
            _quickLinkButton("Track Active Pickup", Icons.local_shipping),
            const SizedBox(height: 8),
            _quickLinkButton("Download Waste Guide", Icons.download),
            const SizedBox(height: 8),
            _quickLinkButton("Report an Issue", Icons.report_problem),
          ],
        ),
      ),
    );
  }

  Widget _quickLinkButton(String label, IconData icon) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening $label...')),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xFF2E7D32)),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQCard() {
    final faqItems = [
      {
        'question': 'How do I request a special waste pickup?',
        'answer':
            'Go to "Request Pickup" from your dashboard, fill in your address, zone, waste type, and preferred date. You will receive a request ID to track the status.'
      },
      {
        'question': 'How do I check my collection schedule?',
        'answer':
            'Visit the "View Schedule" page and enter your pincode or area name. The system will show your weekly waste and recycling schedule.'
      },
      {
        'question': 'How do I file a complaint?',
        'answer':
            'Select "Lodge Complaint" from the dashboard, describe the issue, upload a photo if needed, and submit. You will receive a ticket ID to track the complaint.'
      },
      {
        'question': 'Can I reschedule my pickup?',
        'answer':
            'Yes! Go to "Pickup Status", select the pickup you want to reschedule, click the "Reschedule" button, and select a new date and time.'
      },
      {
        'question': 'What items are NOT recyclable?',
        'answer':
            'Check the "Recycling Guide" for a comprehensive list. Generally, plastic film, contaminated materials, and hazardous waste are not recyclable.'
      },
      {
        'question': 'How can I reduce my waste?',
        'answer':
            'Follow the 3 Rs: Reduce (use less), Reuse (give items new life), and Recycle (process materials into new products).'
      },
    ];

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "❓ Frequently Asked Questions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const Divider(height: 16),
            ...List.generate(
              faqItems.length,
              (index) => _buildFAQItem(
                index,
                faqItems[index]['question']!,
                faqItems[index]['answer']!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(int index, String question, String answer) {
    final isExpanded = expandedIndex == index;

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              expandedIndex = isExpanded ? null : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 32, bottom: 12),
            child: Text(
              answer,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ),
        if (index < 5) const Divider(height: 16),
      ],
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "✨ App Features",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const Divider(height: 16),
            _featureItem("📍 Real-time Tracking", "Track your waste pickups in real-time with GPS updates"),
            _featureItem("📅 Smart Scheduling", "Never miss a collection day with automatic reminders"),
            _featureItem("♻️ Recycling Guide", "Learn what can and cannot be recycled"),
            _featureItem("📞 Direct Contact", "Call collectors directly from the app"),
            _featureItem("💬 Report Issues", "File complaints and track their resolution"),
            _featureItem("📊 Waste Stats", "View your waste patterns and recycling contributions"),
          ],
        ),
      ),
    );
  }

  Widget _featureItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "💡 Tips & Best Practices",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryGreen,
              ),
            ),
            const Divider(height: 16),
            ...(AppConstants.wasteManagementTips.asMap().entries.map((e) {
              final icons = [
                Icons.timer,
                Icons.water_drop,
                Icons.delete,
                Icons.schedule,
                Icons.warning,
                Icons.eco,
              ];
              return _tipItem(e.value, icons[e.key]);
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _tipItem(String tip, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tip,
              style: const TextStyle(
                color: AppConstants.textDark,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "🔒 Account & Privacy",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const Divider(height: 16),
            _accountItem(
              "Privacy Policy",
              "Learn how we protect your data",
              Icons.privacy_tip,
            ),
            const SizedBox(height: 12),
            _accountItem(
              "Terms & Conditions",
              "Review our terms of service",
              Icons.description,
            ),
            const SizedBox(height: 12),
            _accountItem(
              "Version Info",
              "App Version 1.0.0",
              Icons.info,
            ),
            const SizedBox(height: 12),
            Center(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Feedback sent! Thank you.'),
                    ),
                  );
                },
                icon: const Icon(Icons.feedback),
                label: const Text('Send Feedback'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _accountItem(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF2E7D32), size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ],
    );
  }
}
