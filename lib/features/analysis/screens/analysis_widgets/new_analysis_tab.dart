import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/features/analysis/controllers/analysis_options_controller.dart';
import 'package:caffedict/features/analysis/screens/analysis_widgets/guest_analysis_screen.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NewAnalysisTab extends StatelessWidget {
  final bool showAppBar;
  final bool isGuestUser;

  NewAnalysisTab({
    super.key,
    this.showAppBar = false,
    this.isGuestUser = false,
  });

  final controller = Get.put(AnalysisOptionsController());

  @override
  Widget build(BuildContext context) {
    if (isGuestUser) {
      return GuestAnalysisScreen(context: context, title: 'New Analysis');
    }

    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('New Analysis')) : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAnalysisOptions(context),
            const SizedBox(height: Sizes.spaceBtwSections),
            _buildStartAnalysisButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisOptions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analysis Options',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Obx(() => Column(
                  children: [
                    ExpansionTile(
                      title: const Text('Full Analysis'),
                      subtitle: const Text(
                          'Comprehensive analysis of three caffeine-related variants'),
                      leading: Icon(
                        controller.selectedAnalysisType.value ==
                                AnalysisType.comprehensive
                            ? Iconsax.tick_circle
                            : Iconsax.chart_2,
                      ),
                      children: [
                        _buildVcfUploadTile(
                          'CYP1A2',
                          'Upload a .vcf file',
                          controller.cyp1a2File,
                        ),
                        _buildVcfUploadTile(
                          'AHR',
                          'Upload a .vcf file',
                          controller.ahrFile,
                        ),
                        _buildVcfUploadTile(
                          'ADORA2A',
                          'Upload a .vcf file',
                          controller.adora2aFile,
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        if (expanded) {
                          controller.selectedAnalysisType.value =
                              AnalysisType.comprehensive;
                        }
                      },
                    ),
                    ExpansionTile(
                      title: const Text('Quick Scan'),
                      subtitle: const Text('Focus on key CYP1A2 variant only'),
                      leading: Icon(
                        controller.selectedAnalysisType.value ==
                                AnalysisType.basic
                            ? Iconsax.tick_circle
                            : Iconsax.timer_1,
                      ),
                      children: [
                        _buildVcfUploadTile(
                          'CYP1A2',
                          'Upload a .vcf file',
                          controller.cyp1a2File,
                        ),
                      ],
                      onExpansionChanged: (expanded) {
                        if (expanded) {
                          controller.selectedAnalysisType.value =
                              AnalysisType.basic;
                        }
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildVcfUploadTile(
    String gene,
    String description,
    Rx<String?> filePath,
  ) {
    return ListTile(
      title: Text(gene),
      subtitle: Obx(() => Text(
            filePath.value?.split('/').last ?? description,
          )),
      trailing: FilledButton(
        onPressed: () => controller.pickVcfFile(gene),
        child: const Text('Upload'),
      ),
    );
  }

  Widget _buildStartAnalysisButton(BuildContext context) {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // Use the canStartAnalysis method to set the button state
            onPressed: controller.canStartAnalysis
                ? () => _showAnalysisProgress(context)
                : null,
            child: const Text('Start Analysis'),
          ),
        ));
  }

  void _showAnalysisProgress(BuildContext context) {
    Get.dialog(
      barrierDismissible: false,
      Obx(() => AlertDialog(
            // Set the processing state as the dialog title
            title: Text(controller.stageMessage),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LinearProgressIndicator(
                  value: controller.analysisProgress.value,
                  backgroundColor: Theme.of(context).disabledColor,
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStageIndicator(context, AnalysisStage.processing,
                        controller.currentStage.value),
                    _buildStageIndicator(context, AnalysisStage.analyzing,
                        controller.currentStage.value),
                    _buildStageIndicator(context, AnalysisStage.generating,
                        controller.currentStage.value),
                  ],
                ),
                const SizedBox(height: Sizes.spaceBtwItems),
                Text(
                  '${(controller.analysisProgress.value * 100).toInt()}% Complete',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )),
    );
    controller.runAnalysis();
  }

  Widget _buildStageIndicator(
      BuildContext context, AnalysisStage stage, AnalysisStage? current) {
    final bool active = current == stage;
    final bool passed = current != null && current.index > stage.index;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: passed
                ? Theme.of(context).primaryColor
                : active
                    ? Theme.of(context).primaryColor.withOpacity(0.5)
                    : Theme.of(context).disabledColor,
          ),
          child: Icon(
            stage == AnalysisStage.processing
                ? Iconsax.document_upload
                : stage == AnalysisStage.analyzing
                    ? Iconsax.chart_2
                    : Iconsax.document_text,
            color: Colors.white,
            size: 16,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stage == AnalysisStage.processing
              ? 'Processing'
              : stage == AnalysisStage.analyzing
                  ? 'Analysing'
                  : 'Generating',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: active || passed
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
              ),
        ),
      ],
    );
  }
}
