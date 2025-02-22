import 'package:caffedict/features/demo/screens/introduction_page.dart';
import 'package:caffedict/navigation.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../controllers/get_started_controller.dart';
import 'demo pages/demo_result_screen.dart';
import 'demo pages/demo_upload_screen.dart';

class GetStartedScreen extends StatelessWidget {
  GetStartedScreen({super.key});

  final GetStartedController controller = Get.put(GetStartedController());

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(''), automaticallyImplyLeading: true),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePage,
            children: [
              // Project Introduction Pages
              IntroductionPage(
                title: "SNPs and Metabolism",
                description:
                    "Single Nucleotide Polymorphisms (SNPs) can influence how our bodies process nutrients, drugs, and other substances, impacting metabolism.",
                image: isDarkMode
                    ? "assets/introduction/first_dark.png"
                    : "assets/introduction/first.png",
              ),
              IntroductionPage(
                title: "Genetics of Caffeine Metabolism",
                description:
                    "Your ability to metabolize caffeine is mainly controlled by the CYP1A2 gene. Variants of this gene determine whether you are a fast or slow caffeine metabolizer.",
                image: isDarkMode
                    ? "assets/introduction/second_dark.png"
                    : "assets/introduction/second.png",
              ),
              IntroductionPage(
                title: "How SNPs Affect Caffeine Processing",
                description:
                    "A common SNP, rs762551, influences CYP1A2 enzyme activity. People with the AA genotype metabolize caffeine faster, while those with the AC or CC genotypes metabolize it more slowly.",
                image: isDarkMode
                    ? "assets/introduction/third_dark.png"
                    : "assets/introduction/third.png",
              ),

              IntroductionPage(
                title: "AI-Powered SNP Analysis",
                description:
                    "Our machine learning model processes genetic data to detect SNP variations, assess their impact on metabolism, and provide a personalized analysis based on genotype.",
                image: isDarkMode
                    ? "assets/introduction/fourth_dark.png"
                    : "assets/introduction/fourth.png",
              ),

              // Interactive Demo Pages
              DemoUploadPage(),
              DemoResultsPage(),
            ],
          ),

          // Navigation Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: controller.currentPage > 0
                            ? () {
                                controller.pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : null,
                        child: Text('Back'),
                      ),
                      SmoothPageIndicator(
                        controller: controller.pageController,
                        count: 6,
                        effect: ExpandingDotsEffect(
                          activeDotColor: Theme.of(context).primaryColor,
                          dotColor: Theme.of(context).disabledColor,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 10,
                        ),
                      ),
                      TextButton(
                        onPressed: controller.currentPage < 5
                            ? () {
                                controller.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              }
                            : () async {
                                Get.dialog(
                                  AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const CircularProgressIndicator(),
                                        const SizedBox(
                                            height: Sizes.spaceBtwItems),
                                        const Text('Please wait...'),
                                      ],
                                    ),
                                  ),
                                  barrierDismissible: false,
                                );

                                // Add delay to show loading
                                await Future.delayed(
                                    const Duration(seconds: 2));

                                // Close dialog and navigate
                                Get.back(); // Close dialog
                                Get.off(() => Navigation(
                                    isGuestUser:
                                        true)); // Navigate and remove current screen
                              },
                        child:
                            Text(controller.currentPage == 5 ? 'Done' : 'Next'),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
