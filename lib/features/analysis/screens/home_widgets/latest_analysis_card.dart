import 'package:caffedict/data/analysis/analysis_history.dart';
import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/features/analysis/models/analysis_history_model.dart';
import 'package:caffedict/features/analysis/models/basic_analysis_result_model.dart';
import 'package:caffedict/features/analysis/models/comprehensive_analysis_result_model.dart';
import 'package:caffedict/features/analysis/screens/analysis_results_page.dart';
import 'package:caffedict/features/authentication/screens/register_screen.dart';
import 'package:caffedict/features/demo/screens/demo%20pages/demo_result_screen.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:caffedict/features/demo/controllers/demo_analysis_controller.dart';

class LatestAnalysisCard extends StatelessWidget {
  LatestAnalysisCard({
    super.key,
    required this.context,
    required this.isGuestUser,
  });

  final BuildContext context;
  final bool isGuestUser;
  final analysisHistoryRepo = Get.put(AnalysisHistoryRepository());
  final authRepo = AuthenticationRepository.instance;

  String _buildGenotypeText(AnalysisHistoryModel analysis) {
    if (analysis.analysisType == 'basic') {
      final basicResult = BasicAnalysisResult.fromJson(analysis.fullResults);
      return 'CYP1A2 variant genotype: ${basicResult.cyp1a2Genotype}';
    } else {
      final compResult =
          ComprehensiveAnalysisResult.fromJson(analysis.fullResults);
      return '''CYP1A2 variant genotype: ${compResult.cyp1a2Genotype}
AHR variant genotype: ${compResult.ahrGenotype}
ADORA2A variant genotype: ${compResult.adora2aGenotype}''';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isGuestUser) {
      return _buildGuestCard();
    }

    return FutureBuilder<List<AnalysisHistoryModel>>(
      future: analysisHistoryRepo.fetchAnalysisHistory(authRepo.authUser!.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(Sizes.defaultSpace),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyCard();
        }

        final latestAnalysis = snapshot.data!.first;
        return _buildAnalysisCard(latestAnalysis);
      },
    );
  }

  Widget _buildGuestCard() {
    return Obx(() {
      final demoResult = DemoAnalysisController.demoResult.value;
      return _buildCardContent(
        title: 'Demo Analysis',
        isDemo: true,
        metabolismType: demoResult?.metabolismType,
        genotypeText: demoResult != null
            ? 'CYP1A2 variant genotype: ${demoResult.genotype}'
            : null,
      );
    });
  }

  Widget _buildEmptyCard() {
    return _buildCardContent(
      title: 'No Analysis',
      isDemo: false,
      metabolismType: null,
      genotypeText: null,
    );
  }

  Widget _buildAnalysisCard(AnalysisHistoryModel analysis) {
    return _buildCardContent(
      title: 'Latest Analysis',
      isDemo: false,
      metabolismType: '${analysis.metabolismCategory} Metabolizer',
      genotypeText: _buildGenotypeText(analysis),
      analysisData: analysis,
    );
  }

  Widget _buildCardContent({
    required String title,
    required bool isDemo,
    String? metabolismType,
    String? genotypeText,
    AnalysisHistoryModel? analysisData,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (metabolismType != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          _getMetabolismColor(metabolismType).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      metabolismType,
                      style: TextStyle(
                        color: _getMetabolismColor(metabolismType),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwSections),
            Text(
              genotypeText ?? 'Run the analysis to see your results',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: metabolismType != null
                    ? () {
                        final controller = Get.put(AnalysisController());
                        if (isDemo) {
                          final demoController =
                              Get.put(DemoAnalysisController());
                          Get.to(() => DemoResultsPage(
                                showAppBar: true,
                                controller: demoController,
                              ));
                        } else if (analysisData != null) {
                          // Clear existing results
                          controller.basicResult.value = null;
                          controller.compResult.value = null;

                          // Set appropriate result
                          if (analysisData.analysisType == 'basic') {
                            controller.basicResult.value =
                                BasicAnalysisResult.fromJson(
                                    analysisData.fullResults);
                          } else {
                            controller.compResult.value =
                                ComprehensiveAnalysisResult.fromJson(
                                    analysisData.fullResults);
                          }

                          Get.to(() =>
                              const AnalysisResultsPage(showBackArrow: true));
                        }
                      }
                    : null,
                child: const Text('View Full Results'),
              ),
            ),
            if (isGuestUser) ...[
              const SizedBox(height: Sizes.spaceBtwItems),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.to(() => const RegisterScreen()),
                  child: const Text('Sign Up to Save Results'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getMetabolismColor(String type) {
    if (type.contains('Fast')) return Colors.green;
    if (type.contains('Slow')) return Colors.red;
    return Colors.orange;
  }
}
