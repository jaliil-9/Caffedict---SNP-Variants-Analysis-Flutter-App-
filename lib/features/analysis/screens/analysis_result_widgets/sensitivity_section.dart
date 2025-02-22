import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SensitivitySection extends StatelessWidget {
  const SensitivitySection({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalysisController>();
    final result = controller.compResult.value!;

    Color sensitivityColor;
    switch (result.sensitivityLevel) {
      case 'High':
        sensitivityColor = Colors.red;
        break;
      case 'Medium':
        sensitivityColor = Colors.orange;
        break;
      case 'Low':
        sensitivityColor = Colors.green;
        break;
      default:
        sensitivityColor = Colors.grey;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Caffeine Sensitivity',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: sensitivityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.health,
                    color: sensitivityColor,
                    size: 32,
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result.sensitivityLevel} Sensitivity',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: sensitivityColor),
                        ),
                        Text(
                          'Composite Score: ${result.compositeScore.toStringAsFixed(2)}',
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
