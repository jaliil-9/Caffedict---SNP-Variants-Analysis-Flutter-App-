class AnalysisHistoryModel {
  final String id;
  final String userId;
  final DateTime analysisDate;
  final String analysisType; // 'basic' or 'comprehensive'
  final String metabolismCategory;
  final String? sensitivityLevel;
  final double confidence;
  final Map<String, dynamic> fullResults;

  AnalysisHistoryModel({
    required this.id,
    required this.userId,
    required this.analysisDate,
    required this.analysisType,
    required this.metabolismCategory,
    this.sensitivityLevel,
    required this.confidence,
    required this.fullResults,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'analysis_date': analysisDate.toIso8601String(),
        'analysis_type': analysisType,
        'metabolism_category': metabolismCategory,
        'sensitivity_level': sensitivityLevel,
        'confidence': confidence,
        'full_results': fullResults,
      };

  factory AnalysisHistoryModel.fromJson(Map<String, dynamic> json) =>
      AnalysisHistoryModel(
        id: json['id'],
        userId: json['user_id'],
        analysisDate: DateTime.parse(json['analysis_date']),
        analysisType: json['analysis_type'],
        metabolismCategory: json['metabolism_category'],
        sensitivityLevel: json['sensitivity_level'],
        confidence: json['confidence'],
        fullResults: json['full_results'],
      );
}
