import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MetabolismTypeSection extends StatelessWidget {
  const MetabolismTypeSection({
    super.key,
    required this.context,
    required this.isComprehensive,
  });

  final BuildContext context;
  final bool isComprehensive;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalysisController());
    final category = isComprehensive
        ? controller.compResult.value!.metabolismCategory
        : controller.basicResult.value!.metabolismCategory;
    final confidence = isComprehensive
        ? controller.compResult.value!.confidence
        : controller.basicResult.value!.confidence;

    Color categoryColor;
    switch (category) {
      case 'Fast':
        categoryColor = Colors.green;
        break;
      case 'Medium':
        categoryColor = Colors.orange;
        break;
      case 'Slow':
        categoryColor = Colors.red;
        break;
      default:
        categoryColor = Colors.grey;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.speed, color: categoryColor, size: 32),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$category Metabolizer',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: categoryColor),
                        ),
                        Text(
                          'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
