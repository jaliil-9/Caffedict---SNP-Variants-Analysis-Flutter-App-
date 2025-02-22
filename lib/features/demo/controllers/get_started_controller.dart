import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetStartedController extends GetxController {
  static GetStartedController get instance => Get.find();
  final _currentPage = 0.obs;
  final _isIntroComplete = false.obs;
  final pageController = PageController();

  int get currentPage => _currentPage.value;
  bool get isIntroComplete => _isIntroComplete.value;

  void updatePage(int page) {
    _currentPage.value = page;
  }

  void nextPage() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void completeIntro() {
    _isIntroComplete.value = true;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
