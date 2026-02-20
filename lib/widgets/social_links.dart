import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class SocialLinks extends StatelessWidget {
  const SocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    final socialLinks = [
      {
        'platform': 'Website',
        'value': AppConstants.websiteUrl,
        'icon': Icons.language,
      },
      {
        'platform': 'Email',
        'value': AppConstants.supportEmail,
        'icon': Icons.email,
      },
      {
        'platform': 'Phone',
        'value': AppConstants.supportPhone,
        'icon': Icons.phone,
      },
      {
        'platform': 'LinkedIn',
        'value': AppConstants.linkedInUrl,
        'icon': Icons.business,
      },
      {
        'platform': 'Twitter',
        'value': AppConstants.twitterUrl,
        'icon': Icons.share,
      },
    ];

    return Column(
      children: [
        ...socialLinks.map(
          (link) => _socialLink(
            platform: link['platform'] as String,
            value: link['value'] as String,
            icon: link['icon'] as IconData,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              const Text(
                'Made with ♻️ for a sustainable future',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Version ${AppConstants.appVersion} • ${AppConstants.copyright}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialLink({
    required String platform,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppConstants.primaryGreen, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  platform,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppConstants.textDark,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 11, color: Colors.blue),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}
