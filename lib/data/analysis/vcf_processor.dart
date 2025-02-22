import 'dart:io';

class GenotypeData {
  final String rawGenotype; // "0/1"
  final int numericGenotype; // 0, 1, 2
  final String textGenotype; // "A/C"

  GenotypeData({
    required this.rawGenotype,
    required this.numericGenotype,
    required this.textGenotype,
  });
}

class VCFProcessor {
  final Map<String, Map<String, dynamic>> targetVariants = {
    'rs762551': {
      'gene': 'CYP1A2',
      'ref': 'A',
      'alt': 'C',
      'position': 75041917
    },
    'rs2066853': {'gene': 'AHR', 'ref': 'G', 'alt': 'A', 'position': 17379110},
    'rs5751876': {
      'gene': 'ADORA2A',
      'ref': 'C',
      'alt': 'T',
      'position': 23169743
    },
  };

  String getTextGenotype(String rawGenotype, String ref, String alt) {
    switch (rawGenotype) {
      case '0/0':
        return '$ref/$ref';
      case '1/1':
        return '$alt/$alt';
      case '0/1':
      case '1/0':
        return '$ref/$alt';
      default:
        return 'Unknown';
    }
  }

  Future<GenotypeData?> extractVariantFromVcf(
    String vcfPath,
    int targetPos,
    String targetRef,
    String targetAlt,
  ) async {
    try {
      final file = File(vcfPath);
      final lines = await file.readAsLines();

      for (var line in lines) {
        if (line.startsWith('#')) continue;

        final fields = line.split('\t');
        final pos = int.tryParse(fields[1]);

        if (pos == targetPos) {
          final ref = fields[3];
          final alt = fields[4];

          if (ref == targetRef && alt.contains(targetAlt)) {
            final rawGenotype = fields[9].split(':')[0];
            int numericGenotype;

            switch (rawGenotype) {
              case '0/0':
                numericGenotype = 0;
                break;
              case '1/1':
                numericGenotype = 2;
                break;
              case '0/1':
              case '1/0':
                numericGenotype = 1;
                break;
              default:
                return null;
            }

            return GenotypeData(
              rawGenotype: rawGenotype,
              numericGenotype: numericGenotype,
              textGenotype: getTextGenotype(rawGenotype, targetRef, targetAlt),
            );
          }
        }
      }
      print('Warning: Variant at position $targetPos not found in $vcfPath');
      return null;
    } catch (e) {
      print('Error processing VCF file $vcfPath: $e');
      return null;
    }
  }

  Future<GenotypeData> processForBasicModel(String vcfPath) async {
    final variantInfo = targetVariants['rs762551']!;
    final genotypeData = await extractVariantFromVcf(
      vcfPath,
      variantInfo['position'],
      variantInfo['ref'],
      variantInfo['alt'],
    );

    // Default to heterozygous if not found
    return genotypeData ??
        GenotypeData(
          rawGenotype: '0/1',
          numericGenotype: 1,
          textGenotype: '${variantInfo['ref']}/${variantInfo['alt']}',
        );
  }

  Future<Map<String, GenotypeData>> processForComprehensiveModel(
      Map<String, String> vcfPaths) async {
    Map<String, GenotypeData> variants = {};

    for (var entry in targetVariants.entries) {
      final rsId = entry.key;
      final info = entry.value;
      final vcfPath = vcfPaths[info['gene']];

      if (vcfPath != null) {
        final genotypeData = await extractVariantFromVcf(
          vcfPath,
          info['position'],
          info['ref'],
          info['alt'],
        );

        variants[rsId] = genotypeData ??
            GenotypeData(
              rawGenotype: '0/1',
              numericGenotype: 1,
              textGenotype: '${info['ref']}/${info['alt']}',
            );
      } else {
        variants[rsId] = GenotypeData(
          rawGenotype: '0/1',
          numericGenotype: 1,
          textGenotype: '${info['ref']}/${info['alt']}',
        );
      }
    }

    return variants;
  }
}
