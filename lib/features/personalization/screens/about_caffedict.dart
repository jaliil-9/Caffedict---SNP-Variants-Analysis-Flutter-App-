import 'package:caffedict/features/personalization/screens/profile_widgets/setting_builds.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Caffedict'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            // App Logo/Icon
            Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // ignore: deprecated_member_use
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                ),
                child: Image.asset(isDarkMode
                    ? 'assets/logo/logo_no_bg_dark.png'
                    : 'assets/logo/logo_no_bg_light.png')),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              'Caffedict',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            SettingBuilds.buildSection(
              context,
              'About Us',
              [
                SettingBuilds.buildInfoCard(
                  context,
                  'What is Caffedict?',
                  'Caffedict is an innovative app that analyzes genetic data to help you understand your caffeine metabolism. Using advanced machine learning models, we identify SNPs (Single Nucleotide Polymorphisms) that influence how your body processes caffeine.',
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                SettingBuilds.buildInfoCard(
                  context,
                  'Our Mission',
                  'We aim to provide personalized insights into caffeine metabolism through genetic analysis, helping you make informed decisions about your caffeine consumption.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
