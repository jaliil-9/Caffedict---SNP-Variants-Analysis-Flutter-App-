import 'package:caffedict/util/helpers/loaders.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PrivacySecurityController extends GetxController {
  static PrivacySecurityController get instance => Get.find();

  final supabase = Supabase.instance.client;

  // Change Password
  Future<void> changePassword(String newPassword) async {
    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));
      Get.back();
      JBLoaders.successSnackBar(
        title: 'Success',
        message: 'Password updated successfully',
      );
    } catch (e) {
      JBLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to update password',
      );
    }
  }

  // Delete Analysis History
  Future<void> deleteAnalysisHistory() async {
    try {
      await supabase
          .from('analysis_history')
          .delete()
          .eq('user_id', supabase.auth.currentUser!.id);
      Get.back();
      JBLoaders.successSnackBar(
        title: 'Success',
        message: 'Analysis data deleted successfully',
      );
    } catch (e) {
      JBLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to delete analysis data',
      );
    }
  }

  // Show Change Password Dialog
  Future<void> showChangePasswordDialog(BuildContext context) async {
    final TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'New Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a new password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                changePassword(passwordController.text);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Show Delete Data Dialog
  Future<void> showDeleteDataDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Analysis History'),
        content: const Text(
            'This will permanently delete all your analysis history. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => deleteAnalysisHistory(),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
