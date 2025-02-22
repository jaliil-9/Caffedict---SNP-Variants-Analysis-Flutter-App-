import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GeneticVariantsSection extends StatelessWidget {
  const GeneticVariantsSection({
    super.key,
    required this.context,
    required this.isComprehensive,
  });

  final BuildContext context;
  final bool isComprehensive;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnalysisController());
    Map<String, Map<String, String>> variants;

    if (isComprehensive) {
      final result = controller.compResult.value!;
      variants = {
        'CYP1A2': {
          'rs762551': result.cyp1a2Genotype,
          'impact': result.cyp1a2Impact
        },
        'AHR': {'rs2066853': result.ahrGenotype, 'impact': result.ahrImpact},
        'ADORA2A': {
          'rs5751876': result.adora2aGenotype,
          'impact': result.adora2aImpact
        },
      };
    } else {
      final result = controller.basicResult.value!;
      variants = {
        'CYP1A2': {
          'rs762551': result.cyp1a2Genotype,
          'impact': result.cyp1a2Impact
        },
      };
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Genetic Variants Analysis',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            ...variants.entries.map((entry) {
              final gene = entry.key;
              final details = entry.value;
              return Column(
                children: [
                  VariantTile(
                      context: context,
                      gene: gene,
                      variant: details.keys.first,
                      genotype: details.values.first,
                      impact: details['impact'] as String),
                  if (gene != variants.keys.last) const Divider(),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class VariantTile extends StatelessWidget {
  const VariantTile({
    super.key,
    required this.context,
    required this.gene,
    required this.variant,
    required this.genotype,
    required this.impact,
  });

  final BuildContext context;
  final String gene;
  final String variant;
  final String genotype;
  final String impact;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Row(
        children: [
          Text(
            gene,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              variant,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text('Genotype: $genotype'),
          Text(impact),
        ],
      ),
    );
  }
}
