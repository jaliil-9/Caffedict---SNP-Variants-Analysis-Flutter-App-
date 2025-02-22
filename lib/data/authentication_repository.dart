import 'package:caffedict/features/authentication/screens/auth_gate_screen.dart';
import 'package:caffedict/features/authentication/screens/login_screen.dart';
import 'package:caffedict/features/authentication/screens/onboarding_screen.dart';
import 'package:caffedict/navigation.dart';
import 'package:caffedict/util/helpers/loaders.dart';
import 'package:caffedict/util/helpers/loading_dialog.dart';
import 'package:caffedict/util/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:caffedict/util/helpers/supabase_error_handler.dart';
import 'package:caffedict/util/constants/auth_constants.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Supabase instance
  final supabase = Supabase.instance.client;
  final deviceStorage = GetStorage();

  // Get current user
  User? get authUser => supabase.auth.currentUser;

  @override
  void onReady() {
    // Remove Splash Screen
    FlutterNativeSplash.remove();

    // Redirect to the Appropriate Screen
    screenRedirect();
  }

  screenRedirect() async {
    final user = supabase.auth.currentUser;
    if (user != null) {
      await JLocalStorage.init(user.id);
      Get.offAll(() => const Navigation(
            isGuestUser: false,
          )); // If user is logged-in, gets redirected to navigation menu
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() =>
              const AuthGateScreen()) // If it's user's first time, goes to Onboarding
          : Get.offAll(
              () => const OnboardingScreen()); // If it's not, goes to auth gate
    }
  }

  // Register
  Future<AuthResponse> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw 'Registration failed. Please try again.';
      }

      return response;
    } catch (e) {
      throw SupabaseErrorHandler.getMessage(e);
    }
  }

  // Login
  Future<AuthResponse> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      final response = await supabase.auth
          .signInWithPassword(email: email, password: password);

      if (response.session == null) {
        throw 'Unable to establish session. Please try again.';
      }

      return response;
    } catch (e) {
      throw SupabaseErrorHandler.getMessage(e);
    }
  }

  Future<AuthResponse> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      signInOption: SignInOption.standard,
      serverClientId: AuthConstants.googleClientId,
      forceCodeForRefreshToken: true,
    );

    try {
      // Check if there's an existing sign in
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign In cancelled by user';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'Could not obtain Google ID token';
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
        nonce: null, // Let Supabase handle nonce
      );

      if (response.session == null) {
        throw 'Failed to establish Supabase session';
      }

      return response;
    } catch (e) {
      print('Google Sign In Error Details: $e');

      try {
        await googleSignIn.signOut();
      } catch (signOutError) {
        print('Sign out error: $signOutError');
      }

      if (e.toString().contains('audience')) {
        throw 'Authentication configuration error. Please contact support.';
      } else if (e.toString().contains('network')) {
        throw 'Network error occurred. Please check your internet connection.';
      } else if (e.toString().contains('cancelled')) {
        throw 'Sign in was cancelled';
      } else if (e.toString().contains('token')) {
        throw 'Authentication failed. Please try again.';
      } else {
        throw 'Failed to sign in with Google: ${e.toString()}';
      }
    }
  }

  // Reset Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw "Something went wrong, please try again";
    }
  }

  // Logout with confirmation
  Future<void> logout() async {
    // Show confirmation dialog first
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    // Only proceed with logout if user confirmed
    if (shouldLogout == true) {
      try {
        // Show loading dialog
        LoadingDialog.show();

        await supabase.auth.signOut();
        Get.offAll(() => const LoginScreen());
      } catch (e) {
        // Show error to user
        JBLoaders.errorSnackBar(
            title: 'Error', message: "Something went wrong, please try again");
      } finally {
        // Hide loading dialog
        LoadingDialog.hide();
      }
    }
  }

  // Re-authenticate
  Future<void> reAuthenticateWithEmailAndPassword(
      String email, String password) async {
    try {
      await loginWithEmailAndPassword(email, password);
    } catch (e) {
      throw "Re-authentication failed: $e";
    }
  }

  // Delete Account
  Future<void> deleteAccount() async {
    try {
      if (authUser == null) {
        throw "No authenticated user found";
      }

      // First delete user data and auth record using RPC
      await supabase.rpc('delete_user');

      // Force sign out
      await supabase.auth.signOut();

      JBLoaders.successSnackBar(
          title: 'Done..',
          message: 'Ypur account has been removed successfully');

      Get.offAll(() => const LoginScreen());
    } catch (e) {
      throw "Account deletion failed: $e";
    }
  }
}
