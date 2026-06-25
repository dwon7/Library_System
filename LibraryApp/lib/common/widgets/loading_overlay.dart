import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static bool _isShowing = false;

  static void show() {
    if (_isShowing) return;
    _isShowing = true;
    Get.dialog(
      PopScope(
        canPop: false,
        child: Stack(
          children: [
            const ModalBarrier(
              dismissible: false,
              color: Colors.transparent,
            ),
            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      useSafeArea: false,
    );
  }

  static void hide() {
    if (!_isShowing) return;
    _isShowing = false;
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}