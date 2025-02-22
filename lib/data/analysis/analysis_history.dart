import 'package:caffedict/features/analysis/models/analysis_history_model.dart';
import 'package:caffedict/features/analysis/models/basic_analysis_result_model.dart';
import 'package:caffedict/features/analysis/models/comprehensive_analysis_result_model.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class AnalysisHistoryRepository extends GetxController {
  static AnalysisHistoryRepository get instance => Get.find();

  final supabase = Supabase.instance.client;

  // Get Analysis history from supabase database
  Future<List<AnalysisHistoryModel>> fetchAnalysisHistory(String userId) async {
    try {
      // Ensure to only fetching records for the logged-in user
      final List<dynamic> response = await supabase
          .from('analysis_history')
          .select()
          .eq('user_id', userId)
          .order('analysis_date', ascending: false);

      return response
          .map((json) => AnalysisHistoryModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Save Analysis result in the database
  Future<void> saveAnalysisResult({
    required String userId,
    required String analysisType,
    required dynamic result,
  }) async {
    try {
      // Validate result type
      if (!(result is BasicAnalysisResult ||
          result is ComprehensiveAnalysisResult)) {
        throw 'Invalid result type provided';
      }

      final historyEntry = AnalysisHistoryModel(
        id: const Uuid().v4(),
        userId: userId,
        analysisDate: DateTime.now(),
        analysisType: analysisType,
        metabolismCategory: result.metabolismCategory,
        sensitivityLevel: result is ComprehensiveAnalysisResult
            ? result.sensitivityLevel
            : null,
        confidence: result.confidence,
        fullResults: result.toJson(),
      );

      await supabase
          .from('analysis_history')
          .upsert(historyEntry.toJson())
          .select()
          .single();
    } catch (e) {
      throw 'Failed to save analysis history: ${e.toString()}';
    }
  }
}
