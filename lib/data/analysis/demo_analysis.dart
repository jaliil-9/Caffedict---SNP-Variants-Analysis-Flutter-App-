class DemoAnalysisRepository {
  Future<String> analyzeCyp1a2(String sequence) async {
    await Future.delayed(const Duration(seconds: 1));

    final (genotype, metabolismType) =
        _determineGenotypeAndMetabolism(sequence);
    final feedback = _generateFeedback(metabolismType);

    return '''
Analysis Results:
---------------
Genotype: $genotype
Classification: $metabolismType

Feedback:
$feedback
''';
  }

  (String, String) _determineGenotypeAndMetabolism(String sequence) {
    // Use the sequence content to determine different results for different samples
    if (sequence.contains('SAMPLE_1')) {
      return ('A/A', 'Fast Metabolizer');
    } else if (sequence.contains('SAMPLE_2')) {
      return ('C/C', 'Slow Metabolizer');
    } else if (sequence.contains('SAMPLE_3')) {
      return ('A/C', 'Normal Metabolizer');
    } else {
      // Default case
      return ('A/C', 'Normal Metabolizer');
    }
  }

  String _generateFeedback(String metabolismType) => switch (metabolismType) {
        'Fast Metabolizer' => '''
Sample has the AA genotype which is associated with fast caffeine metabolism. Research suggests that individuals with this variant:
• Process caffeine more quickly than average
• May require higher doses for the same effect
• Generally have better tolerance to caffeine
• Might benefit from timing caffeine intake for optimal performance''',
        'Slow Metabolizer' => '''
Sample has the CC genotype which is associated with slow caffeine metabolism. Research indicates that individuals with this variant:
• Process caffeine more slowly than average
• May experience prolonged effects from caffeine
• Could be more sensitive to caffeine's effects
• Should consider limiting caffeine intake, especially later in the day''',
        _ => '''
Sample has the AC genotype which is associated with normal caffeine metabolism. This common variant suggests:
• Average rate of caffeine processing
• Typical response to caffeine intake
• Standard recommendations for caffeine consumption apply
• Good balance between effectiveness and duration of caffeine effects'''
      };
}
