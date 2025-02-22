import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/data/user_repository.dart';
import 'package:caffedict/features/personalization/controllers/user_controller.dart';
import 'package:caffedict/features/personalization/models/user_model.dart';
import 'package:caffedict/navigation.dart';
import 'package:caffedict/util/helpers/loaders.dart';
import 'package:caffedict/util/helpers/loading_dialog.dart';
import 'package:caffedict/util/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // Variables
  final email = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final password = TextEditingController();
  final hidePassword = true.obs;
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  // Loading state
  var isLoading = false.obs;

  // Register
  void signup() async {
    try {
      LoadingDialog.show();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw 'No internet connection. Please check your network settings.';
      }

      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      final newUser = UserModel(
        id: userCredential.user!.id,
        firstname: firstname.text.trim(),
        lastname: lastname.text.trim(),
        email: email.text.trim(),
        profilePicture: '',
      );

      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserRecord(newUser);

      JBLoaders.successSnackBar(
        title: 'Success',
        message: 'Your account has been created successfully',
      );

      Get.offAll(() => Navigation(isGuestUser: false));
    } catch (e) {
      JBLoaders.errorSnackBar(
        title: 'Registration Failed',
        message: e.toString(),
      );
    } finally {
      LoadingDialog.hide();
    }
  }

  // Google Sign In
  void googleSignIn() async {
    try {
      LoadingDialog.show();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw 'No internet connection. Please check your network settings.';
      }

      final userCredentials =
          await AuthenticationRepository.instance.loginWithGoogle();

      if (userCredentials.user == null) {
        throw 'Failed to get user information';
      }

      await userController.saveUserRecord(userCredentials);

      Get.offAll(() => const Navigation(isGuestUser: false));

      JBLoaders.successSnackBar(
        title: 'Welcome',
        message: 'Successfully signed in with Google',
      );
    } catch (e) {
      JBLoaders.errorSnackBar(
        title: 'Sign In Failed',
        message: e.toString(),
      );
    } finally {
      LoadingDialog.hide();
    }
  }
}
