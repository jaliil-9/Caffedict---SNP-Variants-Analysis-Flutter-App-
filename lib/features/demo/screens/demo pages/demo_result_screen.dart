import 'package:caffedict/features/demo/controllers/demo_analysis_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DemoResultsPage extends StatelessWidget {
  const DemoResultsPage({
    super.key,
    this.showAppBar = false,
    this.controller,
  });

  final bool showAppBar;
  final DemoAnalysisController? controller;

  @override
  Widget build(BuildContext context) {
    final DemoAnalysisController analysisController =
        controller ?? Get.find<DemoAnalysisController>();

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: const Text('Demo Analysis Results'),
            )
          : null,
      body: Obx(() {
        // First check for demo result if viewing from latest analysis card
        final result = showAppBar
            ? DemoAnalysisController.demoResult.value
            : analysisController.analysisResult.value;

        if (result == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final metabolismData = _getMetabolismData(result.metabolismType);
        final sample = analysisController.selectedSample;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sample Information Card
                if (sample != null)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.defaultSpace),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.document_text),
                              const SizedBox(width: Sizes.spaceBtwItems),
                              Expanded(
                                child: Text(
                                  'Analyzed Sample: ${sample.name}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          Text(sample.description),
                        ],
                      ),
                    ),
                  ),
                if (sample != null)
                  const SizedBox(height: Sizes.spaceBtwSections),

                // Metabolism Overview Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.defaultSpace),
                    child: Column(
                      children: [
                        Text(
                          'Caffeine Metabolism Profile',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: metabolismData['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Icon(
                                  metabolismData['icon'],
                                  color: metabolismData['color'],
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: Sizes.spaceBtwItems),
                              Text(
                                metabolismData['text'],
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(color: metabolismData['color']),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwSections),

                // Genetic Analysis Card
                Text(
                  'Genetic Variants Analysis',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Iconsax.data, size: 24),
                            const SizedBox(width: Sizes.spaceBtwItems),
                            Text(
                              'Analysis Results',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const Divider(),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const TextSpan(
                                text: 'CYP1A2 Genotype: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: result.genotype,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        Text(result.feedback),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwSections),

                // Recommendations Card
                Text(
                  'Recommendations',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: metabolismData['recommendations']
                          .map<Widget>((recommendation) => Column(
                                children: [
                                  _buildRecommendationTile(
                                    context,
                                    icon: recommendation['icon'],
                                    title: recommendation['title'],
                                    description: recommendation['description'],
                                  ),
                                  if (recommendation !=
                                      metabolismData['recommendations'].last)
                                    const Divider(),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(height: Sizes.spaceBtwSections * 2.5),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRecommendationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
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
    );
  }
}

Map<String, dynamic> _getMetabolismData(String type) {
  if (type.contains("Fast")) {
    return {
      'text': 'Fast Metabolizer',
      'color': Colors.green,
      'icon': Iconsax.flash,
      'recommendations': [
        {
          'icon': Iconsax.coffee,
          'title': 'Caffeine Intake',
          'description':
              'You metabolize caffeine quickly. Higher intake may be needed.',
        },
        {
          'icon': Iconsax.clock,
          'title': 'Timing',
          'description':
              'You can consume caffeine later in the day with minimal disruption.',
        },
      ],
    };
  } else if (type.contains("Slow")) {
    return {
      'text': 'Slow Metabolizer',
      'color': Colors.red,
      'icon': Iconsax.timer,
      'recommendations': [
        {
          'icon': Iconsax.warning_2,
          'title': 'Caffeine Sensitivity',
          'description':
              'Limit caffeine intake to avoid potential negative effects.',
        },
        {
          'icon': Iconsax.moon,
          'title': 'Sleep Hygiene',
          'description':
              'Avoid caffeine in the afternoon to prevent sleep disturbances.',
        },
      ],
    };
  } else {
    return {
      'text': 'Medium Metabolizer',
      'color': Colors.orange,
      'icon': Iconsax.activity,
      'recommendations': [
        {
          'icon': Iconsax.coffee,
          'title': 'Balanced Intake',
          'description': 'Moderate caffeine consumption is suitable for you.',
        },
        {
          'icon': Iconsax.sun_1,
          'title': 'Morning Consumption',
          'description':
              'Caffeine is best consumed in the morning for optimal benefits.',
        },
      ],
    };
  }
}
