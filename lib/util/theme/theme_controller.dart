import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get instance => Get.find();

  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // Get theme mode from storage, if not found use system theme
  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;

  // Get current theme status
  bool get isDarkMode => _loadTheme();

  // Load theme from storage
  bool _loadTheme() => _storage.read(_key) ?? Get.isPlatformDarkMode;

  // Save and change theme
  void toggleTheme() {
    Get.changeThemeMode(_loadTheme() ? ThemeMode.light : ThemeMode.dark);
    _storage.write(_key, !_loadTheme());
    update();
  }
}
