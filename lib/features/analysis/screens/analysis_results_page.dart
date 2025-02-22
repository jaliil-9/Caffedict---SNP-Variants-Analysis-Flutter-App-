import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/features/analysis/screens/analysis_result_widgets/genetic_variants_section.dart';
import 'package:caffedict/features/analysis/screens/analysis_result_widgets/metabolism_type_section.dart';
import 'package:caffedict/features/analysis/screens/analysis_result_widgets/recommendations_section.dart';
import 'package:caffedict/features/analysis/screens/analysis_result_widgets/sensitivity_section.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalysisResultsPage extends StatelessWidget {
  const AnalysisResultsPage({super.key, this.showBackArrow = false});

  final bool showBackArrow;

  @override
  Widget build(BuildContext context) {
    final analysisController = Get.put(AnalysisController());
    final bool isComprehensive = analysisController.compResult.value != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        automaticallyImplyLeading: showBackArrow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetabolismTypeSection(
                  context: context, isComprehensive: isComprehensive),
              const SizedBox(height: Sizes.spaceBtwSections),
              if (isComprehensive) ...[
                SensitivitySection(context: context),
                const SizedBox(height: Sizes.spaceBtwSections),
              ],
              GeneticVariantsSection(
                  context: context, isComprehensive: isComprehensive),
              const SizedBox(height: Sizes.spaceBtwSections),
              RecommendationsSection(
                  context: context, isComprehensive: isComprehensive),
            ],
          ),
        ),
      ),
    );
  }
}
