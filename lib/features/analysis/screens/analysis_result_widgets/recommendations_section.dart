import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class RecommendationsSection extends StatelessWidget {
  const RecommendationsSection({
    super.key,
    required this.context,
    required this.isComprehensive,
  });

  final BuildContext context;
  final bool isComprehensive;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalysisController>();
    List<Map<String, dynamic>> recommendations;

    if (isComprehensive) {
      final result = controller.compResult.value!;
      final List<Map<String, dynamic>> baseRecs2 = [
        {
          'icon': Icons.coffee,
          'title': 'Caffeine Intake',
          'description': result.metabolismCategory == 'Fast'
              ? 'You metabolize caffeine quickly. Can typically tolerate higher caffeine intake.'
              : result.metabolismCategory == 'Medium'
                  ? 'You have normal caffeine metabolism. Follow general caffeine consumption guidelines.'
                  : 'You metabolize caffeine slowly. Consider reducing caffeine intake.',
        },
        {
          'icon': Icons.access_time,
          'title': 'Timing Considerations',
          'description': result.metabolismCategory == 'Fast'
              ? 'Effects may wear off quickly. Consider timing for optimal effect.'
              : result.metabolismCategory == 'Medium'
                  ? 'Avoid consumption 6-8 hours before bedtime.'
                  : 'Avoid caffeine later in the day due to prolonged effects.',
        },
      ];
      final List<Map<String, dynamic>> baseRecs = baseRecs2;

      baseRecs.add({
        'icon': Iconsax.health,
        'title': 'Sensitivity Management',
        'description': result.sensitivityLevel == 'High'
            ? 'High caffeine sensitivity: Start with very low doses and monitor anxiety levels.'
            : result.sensitivityLevel == 'Moderate'
                ? 'Moderate sensitivity: Watch for individual responses and maintain consistent routine.'
                : 'Low sensitivity: May have higher tolerance but still maintain healthy limits.',
      });
      recommendations = baseRecs;
    } else {
      final result = controller.basicResult.value!;
      final List<Map<String, dynamic>> baseRecs = [
        {
          'icon': Icons.coffee,
          'title': 'Caffeine Intake',
          'description': result.metabolismCategory == 'Fast'
              ? 'You metabolize caffeine quickly. Can typically tolerate higher caffeine intake.'
              : result.metabolismCategory == 'Medium'
                  ? 'You have normal caffeine metabolism. Follow general caffeine consumption guidelines.'
                  : 'You metabolize caffeine slowly. Consider reducing caffeine intake.',
        },
        {
          'icon': Icons.access_time,
          'title': 'Timing Considerations',
          'description': result.metabolismCategory == 'Fast'
              ? 'Effects may wear off quickly. Consider timing for optimal effect.'
              : result.metabolismCategory == 'Medium'
                  ? 'Avoid consumption 6-8 hours before bedtime.'
                  : 'Avoid caffeine later in the day due to prolonged effects.',
        },
      ];
      recommendations = baseRecs;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            ...recommendations.map((rec) {
              return Column(
                children: [
                  RecommendationTile(
                      context: context,
                      icon: rec['icon'] as IconData,
                      title: rec['title'] as String,
                      description: rec['description'] as String),
                  if (rec != recommendations.last) const Divider(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class RecommendationTile extends StatelessWidget {
  const RecommendationTile({
    super.key,
    required this.context,
    required this.icon,
    required this.title,
    required this.description,
  });

  final BuildContext context;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24),
          const SizedBox(width: Sizes.spaceBtwItems),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
