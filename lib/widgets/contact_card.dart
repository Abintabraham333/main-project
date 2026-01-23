import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ContactCard extends StatelessWidget {
  final BuildContext context;

  const ContactCard({required this.context, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "📞 Get in Touch",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryGreen,
              ),
            ),
            const Divider(height: 16),
            _contactItem(
              icon: Icons.phone,
              label: "Call Support",
              value: AppConstants.supportPhone,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling support...')),
                );
              },
            ),
            const SizedBox(height: 12),
            _contactItem(
              icon: Icons.email,
              label: "Email Support",
              value: AppConstants.supportEmail,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening email...')),
                );
              },
            ),
            const SizedBox(height: 12),
            _contactItem(
              icon: Icons.access_time,
              label: "Support Hours",
              value: AppConstants.supportHours,
              onTap: null,
            ),
            const SizedBox(height: 12),
            _contactItem(
              icon: Icons.location_on,
              label: "Visit Us",
              value: AppConstants.officeAddress,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening location...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactItem({
    required IconData icon,
    required String label,
    required String value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryGreen, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
