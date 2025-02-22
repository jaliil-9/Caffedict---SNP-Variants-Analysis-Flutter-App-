class ComprehensiveAnalysisResult {
  final String metabolismCategory;
  final Map<String, double> metabolismProbabilities;
  final String sensitivityLevel;
  final Map<String, double> sensitivityProbabilities;
  final double compositeScore;
  final double confidence;

  final String cyp1a2Genotype;
  final String cyp1a2Impact;
  final String ahrGenotype;
  final String ahrImpact;
  final String adora2aGenotype;
  final String adora2aImpact;

  ComprehensiveAnalysisResult({
    required this.metabolismCategory,
    required this.metabolismProbabilities,
    required this.sensitivityLevel,
    required this.sensitivityProbabilities,
    required this.compositeScore,
    required this.confidence,
    required this.cyp1a2Genotype,
    required this.cyp1a2Impact,
    required this.ahrGenotype,
    required this.ahrImpact,
    required this.adora2aGenotype,
    required this.adora2aImpact,
  });

  // Map the result to json to save it in supabase
  Map<String, dynamic> toJson() => {
        'metabolism_category': metabolismCategory,
        'metabolism_probabilities': metabolismProbabilities,
        'sensitivity_level': sensitivityLevel,
        'sensitivity_probabilities': sensitivityProbabilities,
        'composite_score': compositeScore,
        'confidence': confidence,
        'cyp1a2_genotype': cyp1a2Genotype,
        'cyp1a2_impact': cyp1a2Impact,
        'ahr_genotype': ahrGenotype,
        'ahr_impact': ahrImpact,
        'adora2a_genotype': adora2aGenotype,
        'adora2a_impact': adora2aImpact,
      };

  factory ComprehensiveAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ComprehensiveAnalysisResult(
      metabolismCategory: json['metabolism_category'],
      metabolismProbabilities:
          Map<String, double>.from(json['metabolism_probabilities']),
      sensitivityLevel: json['sensitivity_level'],
      sensitivityProbabilities:
          Map<String, double>.from(json['sensitivity_probabilities']),
      compositeScore: json['composite_score'],
      confidence: json['confidence'],
      cyp1a2Genotype: json['cyp1a2_genotype'],
      cyp1a2Impact: json['cyp1a2_impact'],
      ahrGenotype: json['ahr_genotype'],
      ahrImpact: json['ahr_impact'],
      adora2aGenotype: json['adora2a_genotype'],
      adora2aImpact: json['adora2a_impact'],
    );
  }
}
