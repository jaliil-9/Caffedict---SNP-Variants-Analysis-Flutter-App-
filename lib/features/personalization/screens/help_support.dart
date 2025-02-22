import 'package:caffedict/features/personalization/screens/profile_widgets/setting_builds.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            // FAQ Section
            SettingBuilds.buildSection(
              context,
              'Frequently Asked Questions',
              [
                SettingBuilds.buildExpandableTile(
                  context,
                  'How does Caffedict work?',
                  'Caffedict analyzes your genetic data to identify specific SNPs related to caffeine metabolism. Our machine learning model processes this information to provide personalized insights.',
                ),
                SettingBuilds.buildExpandableTile(
                  context,
                  'How accurate are the results?',
                  'Our analysis is based on peer-reviewed scientific research and validated machine learning models. However, results should be used as informative guidance rather than medical advice.',
                ),
                SettingBuilds.buildExpandableTile(
                  context,
                  'Is my genetic data secure?',
                  'Yes, we use industry-standard encryption to protect your genetic data. Your privacy and data security are our top priorities.',
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            // Contact Support Section
            SettingBuilds.buildSection(
              context,
              'Contact Support',
              [
                SettingBuilds.buildTile(
                  context,
                  Iconsax.message,
                  'Email Support',
                  subtitle: 'jalilbouziane@protonmail.com',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
