import 'package:caffedict/util/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:caffedict/features/personalization/controllers/user_controller.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.isDarkMode,
    required this.isGuestUser,
  });

  final bool isDarkMode;
  final bool isGuestUser;

  @override
  Widget build(BuildContext context) {
    // Only initialize the controller if not in guest mode
    final controller = isGuestUser ? null : Get.put(UserController());

    return Column(
      children: [
        // Profile Picture
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          child: isGuestUser
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage("assets/user.jpg"),
                    fit: BoxFit.cover,
                  ),
                )
              : Obx(() {
                  final profilePicture = controller!.user.value.profilePicture;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: profilePicture.isEmpty
                        ? const Image(
                            image: AssetImage("assets/user.jpg"),
                            fit: BoxFit.cover)
                        : Image.network(
                            profilePicture,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Iconsax.user, size: 40),
                          ),
                  );
                }),
        ),
        const SizedBox(height: Sizes.defaultSpace),

        // User Name
        isGuestUser
            ? Text(
                'Guest User',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.apply(color: Colors.white),
              )
            : Obx(
                () => Text(
                  controller!.user.value.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.apply(color: Colors.white),
                ),
              ),

        const SizedBox(height: 4),

        // User Email
        isGuestUser
            ? Text(
                'guest@caffedict.com',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.apply(color: Colors.white70),
              )
            : Obx(
                () => Text(
                  controller!.user.value.email,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.apply(color: Colors.white70),
                ),
              ),
      ],
    );
  }
}
