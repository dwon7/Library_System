import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:library_app/common/widgets/app_toast.dart';
import 'package:library_app/core/api_client.dart';
import 'package:library_app/routes/app_pages.dart';
import 'login_provider.dart';

class LoginController extends GetxController {
  final LoginProvider provider;

  LoginController(this.provider);

  static const String isSaveUserKey = "isSaveUser";
  static const String accessTokenKey = "accessToken";
  static const String refreshTokenKey = "refreshToken";

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscurePassword = true.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _restoreSavedSession();
  }

  Future<void> _restoreSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(accessTokenKey);
    if (prefs.getBool(isSaveUserKey) == true && token != null) {
      Get.find<ApiClient>().setToken(token);
      rememberMe.value = true;
      Get.offAllNamed(AppPages.home);
    }
  }

  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login() async {
    final email = usernameController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      AppToast.show("Vui lòng nhập email và mật khẩu");
      return;
    }

    isLoading.value = true;
    final result = await provider.login(email, password);
    isLoading.value = false;

    if (result.success) {
      Get.find<ApiClient>().setToken(result.accessToken!);

      final prefs = await SharedPreferences.getInstance();
      if (rememberMe.value) {
        await prefs.setBool(isSaveUserKey, true);
        await prefs.setString(accessTokenKey, result.accessToken!);
        if (result.refreshToken != null) {
          await prefs.setString(refreshTokenKey, result.refreshToken!);
        }
      } else {
        await prefs.remove(isSaveUserKey);
        await prefs.remove(accessTokenKey);
        await prefs.remove(refreshTokenKey);
      }

      AppToast.show("Đăng nhập thành công");
      Get.offAllNamed(AppPages.home);
    } else {
      AppToast.show(result.errorMessage ?? "Đăng nhập thất bại");
      passwordController.clear();
    }
  }

  static Future<void> logout() async {
    Get.find<ApiClient>().clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(isSaveUserKey);
    await prefs.remove(accessTokenKey);
    await prefs.remove(refreshTokenKey);
    Get.offAllNamed(AppPages.login);
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
