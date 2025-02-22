import 'package:caffedict/features/personalization/controllers/user_controller.dart';
import 'package:caffedict/util/constants/colors.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key, required this.isGuestUser});

  final bool isGuestUser;
  final controller = Get.put(UserController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Profile Image Section
                Obx(
                  () => Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(60),
                            border: Border.all(
                              color: isDarkMode
                                  ? AppColors.backgroundDark
                                  : AppColors.backgroundLight,
                              width: 4,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: controller.user.value.profilePicture.isEmpty
                                ? const Icon(Iconsax.user, size: 50)
                                : Image.network(
                                    controller.user.value.profilePicture,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Iconsax.user, size: 50),
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => controller.uploadUserProfilePicture(),
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: const Icon(
                                Iconsax.camera,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwSections),

                // Form Fields
                Obx(
                  () => TextFormField(
                    initialValue: controller.user.value.firstname,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      controller.user.value.firstname = value ?? '';
                    },
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwItems),

                Obx(
                  () => TextFormField(
                    initialValue: controller.user.value.lastname,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Iconsax.user),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      controller.user.value.lastname = value ?? '';
                    },
                  ),
                ),

                const SizedBox(height: Sizes.spaceBtwSections * 2),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        await controller.updateUserProfile();
                      }
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
