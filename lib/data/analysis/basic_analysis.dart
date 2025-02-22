import 'dart:async';
import 'dart:math';
import 'package:caffedict/data/analysis/vcf_processor.dart';
import 'package:caffedict/features/analysis/models/basic_analysis_result_model.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class BasicAnalysisRepository {
  Interpreter? _interpreter;
  final List<String> categories = ['Slow', 'Medium', 'Fast'];

  /// Initialize the interpreter if it's not already loaded.
  Future<Interpreter> get interpreter async {
    _interpreter ??=
        await Interpreter.fromAsset('assets/models/basic_model.tflite');
    return _interpreter!;
  }

  /// Scale the genotype value (0,1,2).
  double scaleBasic(int genotype) {
    return (genotype - 1) / 0.8165;
  }

  /// Run the analysis on the VCF file and return a result.
  Future<BasicAnalysisResult> analyze(String vcfPath) async {
    final model = await interpreter;
    final vcfProcessor = VCFProcessor();

    final genotypeData = await vcfProcessor.processForBasicModel(vcfPath);
    double inputValue = scaleBasic(genotypeData.numericGenotype);

    var input = [
      [inputValue]
    ];
    var output = List.generate(1, (_) => List.filled(3, 0.0));

    model.run(input, output);
    List<double> probabilities = output[0];

    int maxIndex =
        probabilities.indexWhere((p) => p == probabilities.reduce(max));
    String metabolismCategory = categories[maxIndex];
    double confidence = probabilities[maxIndex];

    String cyp1a2Impact = switch (genotypeData.textGenotype) {
      'C/C' => 'Slow metabolism: reduced enzyme activity',
      'A/C' => 'Medium metabolism: normal enzyme activity',
      'A/A' => 'Fast metabolism: increased enzyme activity',
      _ => 'Unknown impact'
    };

    return BasicAnalysisResult(
      metabolismCategory: metabolismCategory,
      probabilities: {
        for (int i = 0; i < categories.length; i++)
          categories[i]: probabilities[i],
      },
      confidence: confidence,
      cyp1a2Genotype: genotypeData.textGenotype,
      cyp1a2Impact: cyp1a2Impact,
    );
  }
}
