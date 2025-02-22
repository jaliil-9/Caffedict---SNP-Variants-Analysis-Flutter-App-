import 'package:caffedict/features/analysis/controllers/home_controller.dart';
import 'package:caffedict/features/analysis/screens/home_widgets/educational_card.dart';
import 'package:caffedict/features/analysis/screens/home_widgets/latest_analysis_card.dart';
import 'package:caffedict/features/analysis/screens/home_widgets/quick_action_grid.dart';
import 'package:caffedict/features/analysis/screens/home_widgets/welcome_banner.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../util/constants/sizes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.isGuestUser});

  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Banner
              WelcomeBanner(context: context, isGuest: isGuestUser),

              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(-30),
                    topRight: Radius.circular(-30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.defaultSpace),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: Sizes.spaceBtwSections,
                      ),
                      // Quick Actions Section
                      Text(
                        'Quick Actions',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      QuickActionGrid(
                        context: context,
                        isGuestUser: isGuestUser,
                      ),

                      const SizedBox(height: Sizes.spaceBtwSections),

                      // Educational Cards Section
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Learn About SNPs',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            SmoothPageIndicator(
                              controller: controller.educationCardController,
                              count: 3,
                              effect: ExpandingDotsEffect(
                                activeDotColor: Theme.of(context).primaryColor,
                                dotColor: Theme.of(context).disabledColor,
                                dotHeight: 8,
                                dotWidth: 8,
                                spacing: 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      SizedBox(
                        height: 220,
                        child: PageView(
                          controller: controller.educationCardController,
                          onPageChanged: controller.updateCurrentPage,
                          children: [
                            EducationalCard(
                              context: context,
                              title: 'What are SNPs?',
                              description:
                                  'Single Nucleotide Polymorphisms (SNPs) are variations in your DNA that can influence traits. Learn more about SNPs on the NHGRI website.',
                              icon: Icons.science,
                              learnMoreUrl:
                                  'https://www.genome.gov/genetics-glossary/Single-Nucleotide-Polymorphisms-SNPs',
                            ),
                            EducationalCard(
                              context: context,
                              title: 'Caffeine & Genetics',
                              description:
                                  'Your genetic makeup influences how quickly you metabolize caffeine through the CYP1A2 enzyme. Discover the research behind caffeine metabolism.',
                              icon: Iconsax.coffee,
                              learnMoreUrl:
                                  'https://europepmc.org/article/MED/16522833',
                            ),
                            EducationalCard(
                              context: context,
                              title: 'Understanding Results',
                              description:
                                  'Learn how to interpret your genetic analysis results and make informed decisions about caffeine consumption.',
                              icon: Iconsax.chart4,
                              learnMoreUrl:
                                  'https://medlineplus.gov/genetics/understanding/testing/interpretingresults/',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: Sizes.spaceBtwSections),

                      // Latest Analysis Section
                      Text(
                        'Latest Analysis',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceBtwItems),
                      LatestAnalysisCard(
                        context: context,
                        isGuestUser: isGuestUser,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
