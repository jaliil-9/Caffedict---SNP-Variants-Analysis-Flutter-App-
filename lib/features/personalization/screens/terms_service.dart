import 'package:caffedict/features/personalization/screens/profile_widgets/setting_builds.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class TermsServiceScreen extends StatelessWidget {
  const TermsServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
              'Terms of Service',
              [
                SettingBuilds.buildTermsCard(
                  context,
                  'Service Usage',
                  'By using Caffedict, you agree to provide accurate genetic data for analysis. The service is intended for informational purposes only and should not be considered medical advice.',
                ),
                SettingBuilds.buildTermsCard(
                  context,
                  'User Responsibilities',
                  'Users are responsible for maintaining the confidentiality of their account credentials and ensuring the accuracy of provided information.',
                ),
                SettingBuilds.buildTermsCard(
                  context,
                  'Data Usage',
                  'We collect and process genetic data solely for the purpose of providing caffeine metabolism analysis. Your data will not be shared with third parties without explicit consent.',
                ),
                SettingBuilds.buildTermsCard(
                  context,
                  'Limitations',
                  'Caffedict provides analysis based on current scientific understanding of genetic factors affecting caffeine metabolism. Results should be interpreted as guidance rather than definitive medical advice.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
