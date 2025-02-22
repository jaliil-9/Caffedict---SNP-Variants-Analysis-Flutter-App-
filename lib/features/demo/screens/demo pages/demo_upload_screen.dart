import 'package:caffedict/features/demo/controllers/demo_analysis_controller.dart';
import 'package:caffedict/features/demo/models/demo_analysis_model.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DemoUploadPage extends StatelessWidget {
  DemoUploadPage({super.key});

  final DemoAnalysisController controller = Get.put(DemoAnalysisController());
  final RxString selectedSampleId = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Demo DNA Sample Analysis",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              "Select a DNA sample to analyze caffeine metabolism genotype. Each sample represents different genetic variants of the CYP1A2 gene.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            SizedBox(
              height: 430,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Samples",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      Expanded(
                        child: ListView.separated(
                          itemCount: predefinedSamples.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final sample = predefinedSamples[index];
                            return Obx(() => _buildSampleTile(
                                  context,
                                  sample,
                                  isSelected:
                                      selectedSampleId.value == sample.id,
                                  onTap: () =>
                                      selectedSampleId.value = sample.id,
                                ));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwSections),

            // Analysis Button
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton.icon(
                    onPressed: selectedSampleId.value.isEmpty
                        ? null
                        : () => controller.analyzeSample(
                            context, selectedSampleId.value),
                    icon: Icon(
                      Iconsax.microscope,
                      color: selectedSampleId.value.isEmpty
                          ? Theme.of(context).disabledColor
                          : Colors.white,
                    ),
                    label: const Text("Analyze Sample"),
                  )),
            ),
            const SizedBox(height: Sizes.spaceBtwSections * 3),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleTile(BuildContext context, DNASample sample,
      {required bool isSelected, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      selected: isSelected,
      selectedTileColor:
          Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: isSelected
            ? BorderSide(color: Theme.of(context).colorScheme.primary)
            : BorderSide.none,
      ),
      leading: Icon(
        isSelected ? Iconsax.tick_circle : Iconsax.document_text,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        sample.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(sample.description),
    );
  }
}
