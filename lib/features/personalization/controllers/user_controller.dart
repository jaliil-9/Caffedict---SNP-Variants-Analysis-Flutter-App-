import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/data/user_repository.dart';
import 'package:caffedict/features/authentication/screens/login_screen.dart';
import 'package:caffedict/features/personalization/models/user_model.dart';
import 'package:caffedict/util/helpers/loaders.dart';
import 'package:caffedict/util/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:caffedict/features/personalization/screens/re_auth_user_screen.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;
  final isLoading = false.obs;

  final hidePassword = false.obs;
  final verufyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  // Fetch user record from Supabase
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // Save user record from any registratoin provider
  Future<void> saveUserRecord(AuthResponse? authResponse) async {
    try {
      await fetchUserRecord();

      if (user.value.id.isEmpty && authResponse != null) {
        final supabaseUser = authResponse.user;
        final nameParts =
            UserModel.nameParts(supabaseUser?.userMetadata?['full_name'] ?? '');

        final newUser = UserModel(
          id: supabaseUser!.id,
          email: supabaseUser.email ?? '',
          firstname: nameParts.isNotEmpty ? nameParts[0] : '',
          lastname: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          profilePicture: supabaseUser.userMetadata?['avatar_url'] ?? '',
        );

        await userRepository.saveUserRecord(newUser);
      }
    } catch (e) {
      // Handle error
    }
  }

  // Update user profile
  Future<void> updateUserProfile() async {
    try {
      await userRepository.updateUserDetails(user.value);
      Get.back();
      JBLoaders.successSnackBar(
        title: 'Success',
        message: 'Profile updated successfully',
      );
    } catch (e) {
      JBLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to update profile',
      );
    }
  }

  // Delete Account warning
  void deleteAccountWarning() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(16),
      title: "Delete Account",
      middleText: "Are you sure you want to delete your account?",
      confirm: TextButton(
          onPressed: () async => deleteUserAccount(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          )),
      cancel: TextButton(
          onPressed: () => Navigator.of(Get.overlayContext!).pop(),
          child: const Text(
            'Cancel',
          )),
      confirmTextColor: Colors.white,
    );
  }

  // Delete Account
  Future<void> deleteUserAccount() async {
    try {
      final auth = AuthenticationRepository.instance;
      final user = Supabase.instance.client.auth.currentUser;
      final provider = user?.appMetadata['provider'] ?? '';

      if (provider.isNotEmpty) {
        Get.back(); // Close the warning dialog
        if (provider == 'google') {
          await auth.loginWithGoogle();
          await auth.deleteAccount();
        } else if (provider == 'email') {
          Get.to(() => const ReAuthUserScreen());
        }
      } else {
        throw 'Unable to determine authentication provider';
      }
    } catch (e) {
      JBLoaders.warningSnackBar(
          title: "Account not deleted",
          message: "Something went wrong while deleting your account: $e");
    }
  }

  // Re-authenticate user before account deletion
  Future<void> reAuthenticateEmailPasswordUser() async {
    if (reAuthFormKey.currentState!.validate()) {
      try {
        // Check internet connection
        final isConnected = await NetworkManager.instance.isConnected();
        if (!isConnected) {
          return;
        }

        // Re-authenticate then delete account
        await AuthenticationRepository.instance
            .reAuthenticateWithEmailAndPassword(
                verufyEmail.text, verifyPassword.text);

        await AuthenticationRepository.instance.deleteAccount();

        // Move to login screen
        Get.offAll(() => const LoginScreen());
      } catch (e) {
        JBLoaders.warningSnackBar(
            title: "Re-Authentication Failed", message: "Error: $e");
      }
    } else {
      return;
    }
  }

  // Upload profile image
  Future<void> uploadUserProfilePicture() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 70,
          maxHeight: 512,
          maxWidth: 512);

      if (image != null) {
        isLoading.value = true;

        // Get image URL from storage upload
        final imageUrl = await userRepository.uploadImage(
            "Users/Images/Profile/", image,
            oldImageUrl: user.value.profilePicture);

        // Update the profilePicture in database
        await userRepository.updateSingleField({
          'profilePicture': imageUrl,
        });

        // Update local user model
        user.value.profilePicture = imageUrl;
        user.refresh();

        JBLoaders.successSnackBar(
            title: "Success", message: "Profile picture updated successfully");
      }
    } catch (e) {
      JBLoaders.errorSnackBar(
          title: "Error",
          message: "Failed to update profile picture: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
