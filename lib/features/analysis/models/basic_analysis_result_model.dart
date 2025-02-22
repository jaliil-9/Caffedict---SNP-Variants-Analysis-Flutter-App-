class BasicAnalysisResult {
  final String metabolismCategory;
  final Map<String, double> probabilities;
  final double confidence;
  final String cyp1a2Genotype;
  final String cyp1a2Impact;

  BasicAnalysisResult({
    required this.metabolismCategory,
    required this.probabilities,
    required this.confidence,
    required this.cyp1a2Genotype,
    required this.cyp1a2Impact,
  });

  // Map and save the result record to supabase
  Map<String, dynamic> toJson() => {
        'metabolism_category': metabolismCategory,
        'probabilities': probabilities,
        'confidence': confidence,
        'cyp1a2_genotype': cyp1a2Genotype,
        'cyp1a2_impact': cyp1a2Impact,
      };

  factory BasicAnalysisResult.fromJson(Map<String, dynamic> json) {
    return BasicAnalysisResult(
      metabolismCategory: json['metabolism_category'],
      probabilities: Map<String, double>.from(json['probabilities']),
      confidence: json['confidence'],
      cyp1a2Genotype: json['cyp1a2_genotype'],
      cyp1a2Impact: json['cyp1a2_impact'],
    );
  }
}
