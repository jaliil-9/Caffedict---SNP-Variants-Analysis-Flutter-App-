import 'package:caffedict/features/authentication/controllers/login_controller.dart';
import 'package:caffedict/features/authentication/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../util/constants/sizes.dart';
import 'google_sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Welcoming message
            Text('Welcome!', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: Sizes.spaceBtwItems),
            Text(
              'You have been missed!',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: Sizes.spaceBtwSections),

            // Email textfield
            Form(
              key: controller.loginFormKey,
              child: Column(
                children: [
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

                  // Remember me & Forgot Password
                  Row(
                    children: [
                      Row(
                        children: [
                          Transform.translate(
                            offset: const Offset(-12, 0),
                            child: Obx(
                              () => Checkbox(
                                value: controller.rememberMe.value,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (value) => controller.rememberMe
                                    .value = !controller.rememberMe.value,
                              ),
                            ),
                          ),
                          Transform.translate(
                              offset: const Offset(-16, 0),
                              child: Text('Remember me')),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {}, // => const ForgetPasswordScreen()),
                        child: Text(
                          'Forgot password',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: Sizes.spaceBtwItems,
                  ),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.signIn();
                      },
                      child: Text('Sign In'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: Sizes.spaceBtwItems,
            ),

            // Register option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member? '),
                GestureDetector(
                  onTap: () => Get.to(() => const RegisterScreen()),
                  child: Text('Register now',
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
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Text(
                    'Or',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),
                  Expanded(
                    child: Divider(
                      // ignore: deprecated_member_use
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  )
                ],
              ),
            ),

            // Google Sign in
            const SizedBox(height: Sizes.spaceBtwSections),
            Flexible(
              child: GoogleSignInCard(onTap: () => controller.googleSignIn()),
            )
          ],
        ),
      ),
    );
  }
}
