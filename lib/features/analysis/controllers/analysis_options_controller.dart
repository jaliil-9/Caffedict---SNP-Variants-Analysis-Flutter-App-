import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/features/analysis/screens/analysis_results_page.dart';
import 'package:caffedict/util/helpers/loaders.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:io';

enum AnalysisStage { processing, analyzing, generating }

class AnalysisOptionsController extends GetxController {
  static AnalysisOptionsController get instance => Get.find();

  final RxDouble analysisProgress = RxDouble(0.0);
  final Rx<AnalysisType> selectedAnalysisType =
      Rx<AnalysisType>(AnalysisType.basic);
  final Rx<AnalysisStage?> currentStage = Rx<AnalysisStage?>(null);

  // VCF file paths
  final Rx<String?> cyp1a2File = Rx<String?>(null);
  final Rx<String?> ahrFile = Rx<String?>(null);
  final Rx<String?> adora2aFile = Rx<String?>(null);

  // Method to clear the fields
  void clearFiles() {
    cyp1a2File.value = null;
    ahrFile.value = null;
    adora2aFile.value = null;
  }

  // Method to get .vcf files using file_picker
  Future<void> pickVcfFile(String gene) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['vcf'],
      );

      if (result != null && result.files.single.path != null) {
        final path = result.files.single.path!;
        switch (gene) {
          case 'CYP1A2':
            cyp1a2File.value = path;
            break;
          case 'AHR':
            ahrFile.value = path;
            break;
          case 'ADORA2A':
            adora2aFile.value = path;
            break;
        }
      }
    } catch (e) {
      JBLoaders.errorSnackBar(
          title: 'Failed..', message: 'Error picking VCF file');
    }
  }

  // Condition to start the analysis
  bool get canStartAnalysis {
    if (selectedAnalysisType.value == AnalysisType.comprehensive) {
      return cyp1a2File.value != null &&
          ahrFile.value != null &&
          adora2aFile.value != null;
    }
    return cyp1a2File.value != null;
  }

  Future<void> runAnalysis() async {
    if (!canStartAnalysis) {
      JBLoaders.warningSnackBar(
        title: 'Error',
        message: 'Please upload all required VCF files',
      );
      return;
    }

    // Create VCF paths map
    final Map<String, String> vcfPaths = {
      'CYP1A2': cyp1a2File.value!,
      if (selectedAnalysisType.value == AnalysisType.comprehensive) ...{
        'AHR': ahrFile.value!,
        'ADORA2A': adora2aFile.value!,
      },
    };

    /// Methode to Simulate the progression state of the analysis
    currentStage.value = AnalysisStage.processing;
    analysisProgress.value = 0.0;

    // Simulate processing stage (0-30%)
    await _simulateProgress(0.0, 0.3);

    currentStage.value = AnalysisStage.analyzing;
    // Simulate analysis stage (30-70%)
    await _simulateProgress(0.3, 0.7);

    currentStage.value = AnalysisStage.generating;
    // Simulate report generation until 90%
    await _simulateProgress(0.7, 0.9);

    // Run the actual analysis:
    final analysisController = Get.put(AnalysisController());
    await analysisController.runAnalysis(vcfPaths, selectedAnalysisType.value);

    // Once analysis is complete, progress is set to 100%.
    analysisProgress.value = 1.0;

    // Delete processed files from the cache.
    for (final path in vcfPaths.values) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Close the progress dialog and navigate to results screen.
    Get.back();
    Get.to(() => AnalysisResultsPage(
          showBackArrow: true,
        ));
  }

  // Method to animate the processing simulation
  Future<void> _simulateProgress(double start, double end) async {
    double current = start;
    while (current < end) {
      await Future.delayed(const Duration(milliseconds: 400));
      current += 0.02;
      analysisProgress.value = current;
    }
  }

  String get stageMessage {
    switch (currentStage.value) {
      case AnalysisStage.processing:
        return 'Processing data...';
      case AnalysisStage.analyzing:
        return 'Analyzing variants...';
      case AnalysisStage.generating:
        return 'Generating report...';
      default:
        return '';
    }
  }
}
