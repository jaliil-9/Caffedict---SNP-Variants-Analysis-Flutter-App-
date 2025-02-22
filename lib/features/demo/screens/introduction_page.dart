import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';

class IntroductionPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const IntroductionPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,
              height: 400, width: MediaQuery.of(context).size.width),
          const SizedBox(height: Sizes.spaceBtwSections),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Sizes.spaceBtwItems),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 150),
        ],
      ),
    );
  }
}
