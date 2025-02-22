import 'package:caffedict/data/analysis/analysis_history.dart';
import 'package:caffedict/data/analysis/basic_analysis.dart';
import 'package:caffedict/data/analysis/comprehensive_analysis.dart';
import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/features/analysis/models/basic_analysis_result_model.dart';
import 'package:caffedict/features/analysis/models/comprehensive_analysis_result_model.dart';
import 'package:caffedict/util/helpers/loaders.dart';
import 'package:get/get.dart';

enum AnalysisType { basic, comprehensive }

class AnalysisController extends GetxController {
  static AnalysisController get instance => Get.find();

  final Rx<BasicAnalysisResult?> basicResult = Rx<BasicAnalysisResult?>(null);
  final Rx<ComprehensiveAnalysisResult?> compResult =
      Rx<ComprehensiveAnalysisResult?>(null);

  final BasicAnalysisRepository basicRepo = BasicAnalysisRepository();
  final ComprehensiveAnalysisRepository compRepo =
      ComprehensiveAnalysisRepository();

  /// Run analysis based on the selected type and VCF file paths
  Future<void> runAnalysis(
      Map<String, String> vcfPaths, AnalysisType type) async {
    try {
      // Clear both results first
      basicResult.value = null;
      compResult.value = null;

      // Perform basic analysis (Quick Scan)
      if (type == AnalysisType.basic) {
        BasicAnalysisResult result =
            await basicRepo.analyze(vcfPaths['CYP1A2']!);
        basicResult.value = result;

        // Save to history
        await Get.put(AnalysisHistoryRepository()).saveAnalysisResult(
          userId: AuthenticationRepository.instance.authUser!.id,
          analysisType: 'basic',
          result: result,
        );
      } else {
        // Perform comprehensive analysis (Full Analysis)
        ComprehensiveAnalysisResult result = await compRepo.analyze(vcfPaths);
        compResult.value = result;

        // Save to history
        await Get.put(AnalysisHistoryRepository()).saveAnalysisResult(
          userId: AuthenticationRepository.instance.authUser!.id,
          analysisType: 'comprehensive',
          result: result,
        );
      }
    } catch (e) {
      JBLoaders.errorSnackBar(
          title: 'Oops..', message: "Analysis failed, try again");
    }
  }
}
