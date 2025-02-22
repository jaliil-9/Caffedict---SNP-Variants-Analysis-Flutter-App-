import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/features/personalization/controllers/user_controller.dart';
import 'package:caffedict/navigation.dart';
import 'package:caffedict/util/helpers/loaders.dart';
import 'package:caffedict/util/helpers/loading_dialog.dart';
import 'package:caffedict/util/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());

  // Loading state
  var isLoading = false.obs;

  @override
  void onInit() {
    email.text = localStorage.read('remember_me_email') ?? '';
    password.text = localStorage.read('remember_me_password') ?? '';
    super.onInit();
  }

  void signIn() async {
    try {
      if (!loginFormKey.currentState!.validate()) return;

      // Show loading
      LoadingDialog.show();

      // Check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        throw 'No internet connection. Please check your network settings.';
      }

      // Save data if rememberMe is checked
      if (rememberMe.value) {
        localStorage.write('remember_me_email', email.text.trim());
        localStorage.write('remember_me_password', password.text.trim());
      } else {
        localStorage.remove('remember_me_email');
        localStorage.remove('remember_me_password');
      }

      // Login user
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Redirect to Home Page
      Get.offAll(() => const Navigation(
            isGuestUser: false,
          ));

      JBLoaders.successSnackBar(
        title: 'Success',
        message: 'Welcome back!',
      );
    } catch (e) {
      // Show error to user
      JBLoaders.errorSnackBar(
        title: 'Login Failed',
        message: e.toString(),
      );
    } finally {
      // Hide loading after login attempt
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
