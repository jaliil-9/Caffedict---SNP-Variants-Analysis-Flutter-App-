import 'package:caffedict/features/personalization/screens/profile_widgets/setting_builds.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: February 2025',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            SettingBuilds.buildSection(
              context,
              'Privacy Policy',
              [
                SettingBuilds.buildPrivacyCard(
                  context,
                  'Data Collection',
                  'We collect data provided by users for analysis purposes. This includes SNP data related to caffeine metabolism genes.',
                ),
                SettingBuilds.buildPrivacyCard(
                  context,
                  'Data Usage',
                  'Your data is used exclusively for analyzing caffeine metabolism patterns. We use an AI model to process this data and generate reports & insights.',
                ),
                SettingBuilds.buildPrivacyCard(
                  context,
                  'Data Protection',
                  'We implement industry-standard security measures to protect your data. Access to raw genetic data is strictly limited and monitored.',
                ),
                SettingBuilds.buildPrivacyCard(
                  context,
                  'Data Sharing',
                  'We do not share your data with third parties without explicit consent. Anonymized data may be used for improving our analysis models.',
                ),
                SettingBuilds.buildPrivacyCard(
                  context,
                  'User Rights',
                  'You have the right to access, modify, or delete your data at any time through the app settings.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
