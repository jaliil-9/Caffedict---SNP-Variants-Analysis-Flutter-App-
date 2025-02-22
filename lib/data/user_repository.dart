import 'dart:io';
import 'package:caffedict/data/authentication_repository.dart';
import 'package:caffedict/features/personalization/models/user_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final supabase = Supabase.instance.client;

  // Save or update user record
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await supabase.from('Users').upsert(user.toJson());
    } on PostgrestException catch (e) {
      throw "Database error: ${e.message}";
    } catch (e) {
      throw "Failed to save user: ${e.toString()}";
    }
  }

  // Fetch user details
  Future<UserModel> fetchUserDetails() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) throw "User not authenticated";

      final data =
          await supabase.from('Users').select().eq('id', userId).single();

      return UserModel.fromJson(data);
    } on PostgrestException catch (e) {
      throw "Database error: ${e.message}";
    } catch (e) {
      throw "Failed to fetch user details: ${e.toString()}";
    }
  }

  // Update user details
  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      await supabase.from('Users').update({
        'firstname': updateUser.firstname,
        'lastname': updateUser.lastname,
      }).eq('id', updateUser.id);
    } catch (e) {
      throw "Failed to update user: ${e.toString()}";
    }
  }

  // Update a single field in the user record
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.id;
      if (userId == null) throw "User not authenticated";

      await supabase
          .from('Users')
          .update(json)
          .eq('id', userId)
          .select()
          .single();
    } catch (e) {
      throw "Failed to update field: ${e.toString()}";
    }
  }

  // Remove user record
  Future<void> removeUserRecord(String userId) async {
    try {
      await supabase.from('Users').delete().eq('id', userId);
    } on PostgrestException catch (e) {
      throw "Database error: ${e.message}";
    } catch (e) {
      throw "Failed to delete user: ${e.toString()}";
    }
  }

  // Upload profile image to Supabase Storage
  Future<String> uploadImage(String path, XFile image,
      {String? oldImageUrl}) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';
      final File file = File(image.path);
      const String bucketName = 'profile_images';

      // Upload new image
      await supabase.storage.from(bucketName).upload(
            fileName,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true,
            ),
          );

      // Delete old image if it exists
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        try {
          final oldFileName = oldImageUrl.split('/').last;
          await supabase.storage.from(bucketName).remove([oldFileName]);
        } catch (_) {
          // Ignore errors when deleting old image
        }
      }

      // Get and return the public URL
      return supabase.storage.from(bucketName).getPublicUrl(fileName);
    } catch (e) {
      throw "Failed to upload image: ${e.toString()}";
    }
  }
}
