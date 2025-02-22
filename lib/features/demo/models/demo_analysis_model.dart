class DemoAnalysisResult {
  final String genotype;
  final String metabolismType;
  final String feedback;

  DemoAnalysisResult({
    required this.genotype,
    required this.metabolismType,
    required this.feedback,
  });

  factory DemoAnalysisResult.fromReport(String report) {
    final lines = report.split('\n');

    final genotype = lines
        .firstWhere((line) => line.contains('Genotype'))
        .split(':')[1]
        .trim();
    final metabolism = lines
        .firstWhere((line) => line.contains('Classification'))
        .split(':')[1]
        .trim();
    final feedbackIndex = lines.indexOf('Feedback:');
    final feedback = lines.sublist(feedbackIndex + 1).join('\n').trim();

    return DemoAnalysisResult(
      genotype: genotype,
      metabolismType: metabolism,
      feedback: feedback,
    );
  }
}

class DNASample {
  final String id;
  final String name;
  final String description;
  final String sequence;

  DNASample({
    required this.id,
    required this.name,
    required this.description,
    required this.sequence,
  });
}

final List<DNASample> predefinedSamples = [
  DNASample(
    id: '1',
    name: 'Fast Metabolizer Sample',
    description: 'A genetic profile associated with rapid caffeine metabolism.',
    sequence: 'SAMPLE_1_SEQUENCE_AA',
  ),
  DNASample(
    id: '2',
    name: 'Slow Metabolizer Sample',
    description: 'A genetic profile associated with slow caffeine metabolism.',
    sequence: 'SAMPLE_2_SEQUENCE_CC',
  ),
  DNASample(
    id: '3',
    name: 'Normal Metabolizer Sample',
    description:
        'A genetic profile associated with typical caffeine metabolism.',
    sequence: 'SAMPLE_3_SEQUENCE_AC',
  ),
];
