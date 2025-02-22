import 'package:caffedict/features/authentication/controllers/onboarding_controller.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        children: [
          // Horizontal scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: [
              // Page 1
              Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  children: [
                    Image(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      image: AssetImage('assets/onboarding/onboarding_1.png'),
                    ),
                    Text(
                      'Where Code Meets Genetics',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    Text(
                      'Experience the intersection of AI and genetics through SNP variants analysis',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Page 2
              Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  children: [
                    Image(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      image: AssetImage('assets/onboarding/onboarding_2.png'),
                    ),
                    Text(
                      'Powered by Data Science',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    Text(
                      'Using machine learning to analyze CYP1A2 and other genes variations and predict your caffeine metabolism profile',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Page 3
              Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  children: [
                    Image(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.6,
                      image: AssetImage('assets/onboarding/onboarding_3.png'),
                    ),
                    Text(
                      'Explore & Understand',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    Text(
                      'Learn the science behind genetic variations using modern technology',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),

          // Skip button
          Positioned(
              top: kToolbarHeight,
              right: Sizes.defaultSpace,
              child: TextButton(
                  onPressed: () => controller.skipPage(),
                  child: const Text('Skip'))),

          // Dot navigation indicator
          Positioned(
              bottom: kBottomNavigationBarHeight + 80,
              left: MediaQuery.of(context).size.width / 2 - 50,
              child: SmoothPageIndicator(
                  controller: controller.pageController,
                  onDotClicked: controller.dotNavigationClick,
                  count: 3,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Theme.of(context).disabledColor,
                    dotHeight: 8,
                    spacing: 10,
                  ))),

          // Next button
          Positioned(
            bottom: kBottomNavigationBarHeight,
            left: 0,
            right: 0,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Sizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () => controller.nextPage(), child: Text('Next')),
            ),
          )
        ],
      ),
    );
  }
}
