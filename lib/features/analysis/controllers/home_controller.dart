import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late PageController educationCardController;
  final currentPage = 0.obs;

  @override
  void onInit() {
    super.onInit();
    educationCardController = PageController();
  }

  @override
  void onClose() {
    educationCardController.dispose();
    super.onClose();
  }

  void updateCurrentPage(int page) {
    currentPage.value = page;
  }
}
