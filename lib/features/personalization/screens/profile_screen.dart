import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/features/authentication/screens/login_screen.dart';
import 'package:caffedict/features/personalization/screens/about_caffedict.dart';
import 'package:caffedict/features/personalization/screens/edit_profile.dart';
import 'package:caffedict/features/personalization/screens/help_support.dart';
import 'package:caffedict/features/personalization/screens/privacy_policy.dart';
import 'package:caffedict/features/personalization/screens/privacy_security.dart';
import 'package:caffedict/features/personalization/screens/profile_widgets/profile_card.dart';
import 'package:caffedict/features/personalization/screens/profile_widgets/setting_builds.dart';
import 'package:caffedict/features/personalization/screens/profile_widgets/setting_section.dart';
import 'package:caffedict/features/personalization/screens/terms_service.dart';
import 'package:caffedict/util/constants/colors.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:caffedict/util/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.isGuestUser});

  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.primaryLight,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Image and Basic Info
                    ProfileCard(
                      isDarkMode: isDarkMode,
                      isGuestUser: isGuestUser,
                    ),
                  ],
                ),
              ),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: Column(
                  children: [
                    // Account Settings Section
                    SettingSection(
                        context: context,
                        title: 'Account Settings',
                        children: [
                          // Edit Profile
                          SettingBuilds.buildTile(
                            context,
                            isGuestUser ? Iconsax.lock : Iconsax.profile_circle,
                            'Edit Profile',
                            onTap: isGuestUser
                                ? () {}
                                : () => Get.to(() => EditProfileScreen(
                                      isGuestUser: isGuestUser,
                                    )),
                          ),

                          // Privacy & Security
                          SettingBuilds.buildTile(
                            context,
                            isGuestUser ? Iconsax.lock : Iconsax.security,
                            'Privacy & Security',
                            onTap: isGuestUser
                                ? () {}
                                : () =>
                                    Get.to(() => const PrivacySecurityScreen()),
                          ),
                        ]),

                    const SizedBox(height: Sizes.spaceBtwSections),

                    // App Settings Section
                    SettingSection(
                        context: context,
                        title: 'App Settings',
                        children: [
                          // Dark Mode
                          GetBuilder<ThemeController>(
                            builder: (controller) => SettingBuilds.buildTile(
                              context,
                              controller.isDarkMode
                                  ? Iconsax.moon
                                  : Iconsax.sun_1,
                              'Dark Mode',
                              trailing: Switch(
                                value: controller.isDarkMode,
                                onChanged: (value) {
                                  controller.toggleTheme();
                                },
                              ),
                            ),
                          ),
                        ]),

                    const SizedBox(height: Sizes.spaceBtwSections),

                    // Support & About Section
                    SettingSection(
                        context: context,
                        title: 'Support & About',
                        children: [
                          // About
                          SettingBuilds.buildTile(
                            context,
                            Iconsax.info_circle,
                            'About Caffedict',
                            onTap: () => Get.to(() => const AboutScreen()),
                          ),

                          // Help & Support
                          SettingBuilds.buildTile(
                            context,
                            Iconsax.message_question,
                            'Help & Support',
                            onTap: () =>
                                Get.to(() => const HelpSupportScreen()),
                          ),

                          // Terms of Service
                          SettingBuilds.buildTile(
                            context,
                            Iconsax.document,
                            'Terms of Service',
                            onTap: () =>
                                Get.to(() => const TermsServiceScreen()),
                          ),

                          // Privacy Policy
                          SettingBuilds.buildTile(
                            context,
                            Iconsax.shield,
                            'Privacy Policy',
                            onTap: () =>
                                Get.to(() => const PrivacyPolicyScreen()),
                          ),
                        ]),

                    const SizedBox(height: Sizes.spaceBtwSections),

                    // Sign Out Button for logged-in users
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Sizes.defaultSpace),
                        child: OutlinedButton.icon(
                          onPressed: () {
                            isGuestUser
                                ? Get.offAll(() => const LoginScreen())
                                : Get.put(AuthenticationRepository().logout());
                          },
                          icon: const Icon(Iconsax.logout),
                          label: Text(isGuestUser ? 'Sign In' : 'Sign Out'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
