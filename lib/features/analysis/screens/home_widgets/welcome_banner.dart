import 'package:caffedict/features/personalization/controllers/user_controller.dart';
import 'package:caffedict/features/personalization/screens/profile_screen.dart';
import 'package:caffedict/util/constants/colors.dart';
import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    super.key,
    required this.context,
    required this.isGuest,
  });

  final BuildContext context;
  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(UserController());

    return Container(
      padding: const EdgeInsets.fromLTRB(
        Sizes.defaultSpace,
        kToolbarHeight + Sizes.defaultSpace,
        Sizes.defaultSpace,
        Sizes.defaultSpace,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.surfaceDark : AppColors.primaryLight,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Caffedict',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.backgroundLight,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    isGuest
                        ? 'Guest User'
                        : '${controller.user.value.firstname}, How’s your day going?',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: isDarkMode
                            ? AppColors.primaryDark
                            : AppColors.backgroundLight,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.to(() => ProfileScreen(isGuestUser: isGuest)),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                  child: Obx(() {
                    final profilePicture = controller.user.value.profilePicture;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: profilePicture.isEmpty
                          ? const Image(
                              image: AssetImage("assets/user.jpg"),
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              profilePicture,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Iconsax.user, size: 40),
                            ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: Sizes.spaceBtwSections,
          ),
        ],
      ),
    );
  }
}
