import 'package:caffedict/data/analysis/demo_analysis.dart';
import 'package:caffedict/features/demo/models/demo_analysis_model.dart';
import 'package:caffedict/features/demo/controllers/get_started_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DemoAnalysisController extends GetxController {
  static DemoAnalysisController get instance => Get.find();

  final DemoAnalysisRepository demoRepo = DemoAnalysisRepository();
  final controller = Get.put(GetStartedController());

  final Rx<DemoAnalysisResult?> analysisResult = Rx<DemoAnalysisResult?>(null);
  final RxString currentSampleId = ''.obs;

  static Rx<DemoAnalysisResult?> demoResult = Rx<DemoAnalysisResult?>(null);

  DNASample? get selectedSample => currentSampleId.value.isEmpty
      ? null
      : predefinedSamples.firstWhere((s) => s.id == currentSampleId.value);

  Future<void> analyzeSampleMethod(String sequence) async {
    try {
      final report = await demoRepo.analyzeCyp1a2(sequence);
      final result = DemoAnalysisResult.fromReport(report);

      analysisResult.value = result;
      demoResult.value = result; // Store for persistence
    } catch (e) {
      analysisResult.value = null;
      rethrow;
    }
  }

  Future<void> analyzeSample(BuildContext context, String sampleId) async {
    final sample = predefinedSamples.firstWhere((s) => s.id == sampleId);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                'Analyzing ${sample.name}',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text('Processing genetic variants...'),
            ],
          ),
        ),
      );

      await analyzeSampleMethod(sample.sequence);
      Navigator.of(context).pop(); // Dismiss progress dialog
      nextPage();
    } catch (e) {
      Navigator.of(context).pop(); // Dismiss progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing sample: $e')),
      );
    }
  }

  void nextPage() {
    controller.nextPage();
  }

  String get metabolismType => analysisResult.value?.metabolismType ?? "";
  String get genotype => analysisResult.value?.genotype ?? "";
  String get feedback => analysisResult.value?.feedback ?? "";
}
