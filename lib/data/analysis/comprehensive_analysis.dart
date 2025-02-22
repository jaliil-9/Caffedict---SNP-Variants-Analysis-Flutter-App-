import 'dart:async';
import 'dart:math';
import 'package:caffedict/data/analysis/vcf_processor.dart';
import 'package:caffedict/features/analysis/models/comprehensive_analysis_result_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ComprehensiveAnalysisRepository {
  Interpreter? _interpreter;
  final List<String> metabolismCategories = ['Slow', 'Medium', 'Fast'];
  final List<String> sensitivityCategories = ['Low', 'Moderate', 'High'];

  /// Initialization of the interpreter.
  Future<Interpreter> get interpreter async {
    _interpreter ??=
        await Interpreter.fromAsset('assets/models/comp_model.tflite');
    return _interpreter!;
  }

  /// Scaling function for each genotype.
  double scaleValue(int genotype) {
    return (genotype - 1) / 0.8165;
  }

  /// Run the comprehensive analysis on the VCF files.
  Future<ComprehensiveAnalysisResult> analyze(
      Map<String, String> vcfPaths) async {
    final vcfProcessor = VCFProcessor();
    Map<String, GenotypeData> genotypeData =
        await vcfProcessor.processForComprehensiveModel(vcfPaths);

    double rs762551 = scaleValue(genotypeData['rs762551']!.numericGenotype);
    double rs2066853 = scaleValue(genotypeData['rs2066853']!.numericGenotype);
    double rs5751876 = scaleValue(genotypeData['rs5751876']!.numericGenotype);

    var input = [
      [rs762551, rs2066853, rs5751876]
    ];

    // The model outputs three tensors:
    //  • output0: metabolism probabilities ([1, 3])
    //  • output1: sensitivity probabilities ([1, 3])
    //  • output2: composite score ([1, 1])
    var output0 = List.generate(1, (_) => List.filled(3, 0.0));
    var output1 = List.generate(1, (_) => List.filled(3, 0.0));
    var output2 = List.generate(1, (_) => List.filled(1, 0.0));

    Map<int, Object> outputs = {
      0: output0,
      1: output1,
      2: output2,
    };

    // Ensure the model is loaded before inference.
    final model = await interpreter;
    model.runForMultipleInputs([input], outputs);

    List<double> metabolismProbs = output0[0];
    List<double> sensitivityProbs = output1[0];
    double compositeScore = output2[0][0];

    int maxMetaIndex =
        metabolismProbs.indexWhere((p) => p == metabolismProbs.reduce(max));
    int maxSensIndex =
        sensitivityProbs.indexWhere((p) => p == sensitivityProbs.reduce(max));

    String metabolismCategory = metabolismCategories[maxMetaIndex];
    String sensitivityLevel = sensitivityCategories[maxSensIndex];
    double confidence =
        (metabolismProbs[maxMetaIndex] + sensitivityProbs[maxSensIndex]) / 2.0;

    // Return the result
    return ComprehensiveAnalysisResult(
      metabolismCategory: metabolismCategory,
      metabolismProbabilities: {
        for (int i = 0; i < metabolismCategories.length; i++)
          metabolismCategories[i]: metabolismProbs[i],
      },
      sensitivityLevel: sensitivityLevel,
      sensitivityProbabilities: {
        for (int i = 0; i < sensitivityCategories.length; i++)
          sensitivityCategories[i]: sensitivityProbs[i],
      },
      compositeScore: compositeScore,
      confidence: confidence,
      cyp1a2Genotype: genotypeData['rs762551']!.textGenotype,
      cyp1a2Impact:
          _getImpactFromGenotype(genotypeData['rs762551']!.textGenotype),
      ahrGenotype: genotypeData['rs2066853']!.textGenotype,
      ahrImpact:
          _getAhrImpactFromGenotype(genotypeData['rs2066853']!.textGenotype),
      adora2aGenotype: genotypeData['rs5751876']!.textGenotype,
      adora2aImpact: _getAdora2aImpactFromGenotype(
          genotypeData['rs5751876']!.textGenotype),
    );
  }

  String _getImpactFromGenotype(String genotype) => switch (genotype) {
        'C/C' => 'Slow metabolism: reduced enzyme activity',
        'A/C' => 'Medium metabolism: normal enzyme activity',
        'A/A' => 'Fast metabolism: increased enzyme activity',
        _ => 'Unknown impact'
      };

  String _getAhrImpactFromGenotype(String genotype) => switch (genotype) {
        'G/G' => 'High inducibility: enhanced response to inducers',
        'G/A' => 'Moderate inducibility: normal response to inducers',
        'A/A' => 'Low inducibility: reduced responsiveness to inducers',
        _ => 'Unknown impact'
      };

  String _getAdora2aImpactFromGenotype(String genotype) => switch (genotype) {
        'T/T' => 'High sensitivity: stronger response to caffeine',
        'C/T' => 'Moderate sensitivity: balanced response to caffeine',
        'C/C' => 'Low sensitivity: reduced response to caffeine',
        _ => 'Unknown impact'
      };
}
