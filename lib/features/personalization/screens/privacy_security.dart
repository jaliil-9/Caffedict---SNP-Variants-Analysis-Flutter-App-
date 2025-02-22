import 'package:caffedict/features/personalization/controllers/privacy_security_controller.dart';
import 'package:caffedict/features/personalization/controllers/user_controller.dart';
import 'package:caffedict/features/personalization/screens/profile_widgets/setting_builds.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final privacyController = Get.put(PrivacySecurityController());
    final userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            // Data Protection Section
            SettingBuilds.buildSection(
              context,
              'Data Protection',
              [
                SettingBuilds.buildTile(
                  context,
                  Iconsax.trash,
                  'Delete My Data',
                  subtitle: 'Delete your analysis data',
                  onTap: () => privacyController.showDeleteDataDialog(context),
                ),
              ],
            ),

            const SizedBox(height: Sizes.spaceBtwSections),

            // Account Security Section
            SettingBuilds.buildSection(
              context,
              'Account Security',
              [
                SettingBuilds.buildTile(
                  context,
                  Iconsax.password_check,
                  'Change Password',
                  onTap: () =>
                      privacyController.showChangePasswordDialog(context),
                ),
                SettingBuilds.buildTile(
                  context,
                  Iconsax.user_remove,
                  'Delete Account',
                  onTap: () => userController.deleteAccountWarning(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
