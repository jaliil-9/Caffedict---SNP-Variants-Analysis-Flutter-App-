import 'package:caffedict/features/authentication/controllers/register_controller.dart';
import 'package:caffedict/features/authentication/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../util/constants/sizes.dart';
import 'google_sign_in.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcoming message
            Text(
              "Hello there!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              "Nice to have you here!",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 50),

            // Fullname textfield
            Form(
              key: controller.signupFormKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: controller.firstname,
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            hintText: 'Enter your first name',
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: Sizes.spaceBtwItems,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: controller.lastname,
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            hintText: 'Enter your last name',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),

            // Email textfield
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
            ),

            const SizedBox(height: Sizes.spaceBtwItems),

            // Password textfield
            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  suffixIcon: IconButton(
                      onPressed: () => controller.hidePassword.value =
                          !controller.hidePassword.value,
                      icon: Icon(controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye)),
                ),
              ),
            ),

            const SizedBox(
              height: Sizes.spaceBtwItems,
            ),

            // Register button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.signup();
                },
                child: Text("Sign up"),
              ),
            ),

            const SizedBox(
              height: Sizes.spaceBtwItems,
            ),

            // Login option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already a member? ",
                ),
                GestureDetector(
                  onTap: () => Get.to(() => const LoginScreen()),
                  child: Text("Login now",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                )
              ],
            ),

            // Divider
            const SizedBox(height: Sizes.spaceBtwSections),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Text(
                    "Or",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Expanded(
                    child: Divider(
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  )
                ],
              ),
            ),

            // Google Sign in
            const SizedBox(height: Sizes.spaceBtwSections),
            GoogleSignInCard(onTap: () => controller.googleSignIn()),
          ],
        ),
      ),
    );
  }
}
