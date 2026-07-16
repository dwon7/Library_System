import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/routes/app_pages.dart';
import 'login_provider.dart';

class LoginController extends GetxController {
  final LoginProvider provider;

  LoginController(this.provider);

  static const String isSaveUserKey = "isSaveUser";

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkSavedUser();
  }

  void _checkSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(isSaveUserKey) == true) {
      Get.offAllNamed(AppPages.home);
    }
  }

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    final result = await provider.login(usernameController.text.trim(), passwordController.text);
    if (result == 1) {
      if (rememberMe.value) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(isSaveUserKey, true);
      }
      AppToast.show("Đăng nhập thành công");
      Get.offAllNamed(AppPages.home);
    } else {
      AppToast.show("Đăng nhập thất bại");
      passwordController.clear();
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
