import 'package:caffedict/features/authentication/screens/register_screen.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuestAnalysisScreen extends StatelessWidget {
  const GuestAnalysisScreen({
    super.key,
    required this.context,
    this.title = 'Analysis',
  });

  final BuildContext context;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).disabledColor,
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                'Feature Locked',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceBtwItems),
              Text(
                'Sign up to access further analysis options and track your results over time.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Sizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => RegisterScreen());
                  },
                  child: Text('Sign Up Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
