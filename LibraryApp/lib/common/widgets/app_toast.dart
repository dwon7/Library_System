import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToast {
  static void show(String message) {
    Get.snackbar(
      "",
      "",
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      backgroundColor: Colors.black87,
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
