import 'package:flutter/material.dart';
import '../utils/constants.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Education',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Learn about app permissions and how to protect your privacy',
            style: TextStyle(
              color: AppConstants.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildEducationCard(
            'What are App Permissions?',
            'App permissions are access rights that apps request to use specific features of your device. These can include access to your camera, microphone, location, contacts, and more.',
            Icons.info,
            AppConstants.primaryColor,
          ),
          
          _buildEducationCard(
            'Dangerous Permissions',
            'Dangerous permissions can access your private data or control features that affect your privacy. These include:\n\n• Camera & Microphone - Can record without notification\n• Location - Tracks your movements\n• Contacts - Accesses personal information\n• SMS - Can read and send messages\n• Storage - Accesses your files and photos',
            Icons.warning,
            AppConstants.highRiskColor,
          ),
          
          _buildEducationCard(
            'Why Review Permissions?',
            'Many apps request more permissions than they actually need. For example, a flashlight app doesn\'t need access to your contacts or location. Reviewing permissions helps you:\n\n• Protect your personal data\n• Prevent unauthorized tracking\n• Reduce security risks\n• Improve device performance',
            Icons.shield,
            AppConstants.mediumRiskColor,
          ),
          
          _buildEducationCard(
            'Best Practices',
            '1. Only grant permissions that are necessary for the app\'s core functionality\n\n2. Deny location access unless the app specifically needs it\n\n3. Be cautious of apps requesting camera and microphone together\n\n4. Review permissions regularly, especially after app updates\n\n5. Uninstall apps you no longer use\n\n6. Check which apps have background location access',
            Icons.check_circle,
            AppConstants.lowRiskColor,
          ),
          
          _buildEducationCard(
            'Red Flags',
            'Be especially careful if an app:\n\n• Requests many unrelated permissions\n• Asks for camera, microphone, and location together\n• Requests SMS or call permissions without clear reason\n• Wants to run in the background constantly\n• Is from an unknown developer\n• Has poor reviews mentioning privacy concerns',
            Icons.flag,
            AppConstants.errorColor,
          ),
          
          _buildEducationCard(
            'How to Manage Permissions',
            '1. Tap on any app in the Apps tab\n2. Review the permissions it has been granted\n3. Tap "Open App Settings" button\n4. In the system settings, you can:\n   • Revoke specific permissions\n   • Change location access to "Only while using"\n   • Disable background permissions\n\nNote: Some apps may not work properly if you revoke essential permissions.',
            Icons.settings,
            AppConstants.secondaryColor,
          ),
          
          const SizedBox(height: 16),
          
          // Additional Resources
          Card(
            color: AppConstants.surfaceColor,
            elevation: AppConstants.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: AppConstants.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Remember',
                        style: TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your privacy is in your hands. This app helps you understand what permissions your apps have, but you need to take action to protect your data. Regularly review and revoke unnecessary permissions.',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: AppConstants.surfaceColor,
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(AppConstants.paddingMedium),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium,
            0,
            AppConstants.paddingMedium,
            AppConstants.paddingMedium,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: AppConstants.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Text(
              content,
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
