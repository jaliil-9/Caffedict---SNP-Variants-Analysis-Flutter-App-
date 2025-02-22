import 'package:caffedict/data/analysis/analysis_history.dart';
import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/features/analysis/controllers/analysis_controller.dart';
import 'package:caffedict/features/analysis/models/analysis_history_model.dart';
import 'package:caffedict/features/analysis/models/basic_analysis_result_model.dart';
import 'package:caffedict/features/analysis/models/comprehensive_analysis_result_model.dart';
import 'package:caffedict/features/analysis/screens/analysis_results_page.dart';
import 'package:caffedict/features/analysis/screens/analysis_widgets/guest_analysis_screen.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AnalysisHistoryTab extends StatelessWidget {
  const AnalysisHistoryTab({
    super.key,
    this.showAppBar = false,
    this.isGuestUser = false,
  });

  final bool showAppBar;
  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    if (isGuestUser) {
      return GuestAnalysisScreen(context: context, title: 'Analysis History');
    }

    final historyRepo = Get.put(AnalysisHistoryRepository());
    final userId = AuthenticationRepository.instance.authUser!.id;

    return Scaffold(
      appBar: showAppBar ? AppBar(title: const Text('Analysis History')) : null,
      body: FutureBuilder<List<AnalysisHistoryModel>>(
        future: historyRepo.fetchAnalysisHistory(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final history = snapshot.data!;
          if (history.isEmpty) {
            return const Center(
              child: Text('No analysis history available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return _buildHistoryCard(context, entry);
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, AnalysisHistoryModel entry) {
    final analysisController = Get.put(AnalysisController());

    return Card(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwItems),
      child: InkWell(
        onTap: () {
          // Clear both results first
          analysisController.basicResult.value = null;
          analysisController.compResult.value = null;

          // Set the appropriate result based on analysis type
          if (entry.analysisType == 'basic') {
            analysisController.basicResult.value =
                BasicAnalysisResult.fromJson(entry.fullResults);
          } else {
            analysisController.compResult.value =
                ComprehensiveAnalysisResult.fromJson(entry.fullResults);
          }

          Get.to(() => const AnalysisResultsPage(showBackArrow: true));
        },
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.analysisType == 'comprehensive'
                        ? 'Full Analysis'
                        : 'Quick Scan',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    DateFormat('yyyy-MM-dd').format(entry.analysisDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getMetabolismColor(entry.metabolismCategory)
                          .withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${entry.metabolismCategory} Metabolizer',
                      style: TextStyle(
                        color: _getMetabolismColor(entry.metabolismCategory),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (entry.sensitivityLevel != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getSensitivityColor(entry.sensitivityLevel!)
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${entry.sensitivityLevel} Sensitivity',
                        style: TextStyle(
                          color: _getSensitivityColor(entry.sensitivityLevel!),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Theme.of(context).disabledColor,
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                'Confidence: ${(entry.confidence * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMetabolismColor(String category) {
    switch (category) {
      case 'Fast':
        return Colors.green;
      case 'Medium':
        return Colors.orange;
      case 'Slow':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getSensitivityColor(String level) {
    switch (level) {
      case 'High':
        return Colors.red;
      case 'Moderate':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
