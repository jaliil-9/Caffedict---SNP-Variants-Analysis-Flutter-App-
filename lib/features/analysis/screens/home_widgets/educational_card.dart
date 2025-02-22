import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:caffedict/util/constants/colors.dart';

class EducationalCard extends StatelessWidget {
  const EducationalCard({
    super.key,
    required this.context,
    required this.title,
    required this.description,
    required this.icon,
    required this.learnMoreUrl,
  });

  final BuildContext context;
  final String title;
  final String description;
  final IconData icon;
  final String learnMoreUrl;

  Future<void> _launchLearnMore() async {
    final Uri url = Uri.parse(learnMoreUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      // Optionally, show an error message if URL can't be launched.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the link.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: isDarkMode
                      ? AppColors.primaryDark
                      : AppColors.primaryLight,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _launchLearnMore,
                child: const Text('Learn More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
