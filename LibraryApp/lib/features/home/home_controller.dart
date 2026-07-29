import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart'; // 1. Thêm import này

import 'home_provider.dart';

class HomeController extends GetxController {
  final HomeProvider provider;
  HomeController(this.provider);

  var currentTabIndex = 0.obs;

  // Khai báo các khóa điều hướng
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
    3: GlobalKey<NavigatorState>(),
    4: GlobalKey<NavigatorState>(),
  };

  @override
  void onReady() {
    super.onReady();
    // Gọi hàm kiểm tra và yêu cầu quyền ngay khi Home vừa hiển thị xong
    // checkAndRequestPermissions();
  }

  Future<void> checkAndRequestPermissions() async {
    // 1. Kiểm tra trạng thái hiện tại
    PermissionStatus status = await Permission.camera.status;

    print("DEBUG: Trạng thái Camera hiện tại: $status");

    // 2. Nếu chưa từng yêu cầu (denied) hoặc bị từ chối thông thường, hãy yêu cầu ngay
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    // 3. Nếu sau khi yêu cầu mà người dùng vẫn từ chối vĩnh viễn (hoặc tắt trong Cài đặt)
    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    }
  }

  /// Dialog thông báo yêu cầu người dùng mở cài đặt thủ công
  void _showSettingsDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'Yêu cầu quyền truy cập',
          style: TextStyle(fontFamily: 'sora', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Ứng dụng cần quyền Camera để quét mã vạch/QR của sách hoặc phiếu mượn. Vui lòng cấp quyền trong Cài đặt thiết bị của bạn.',
          style: TextStyle(fontFamily: 'sora'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Để sau',
              style: TextStyle(color: Colors.grey, fontFamily: 'sora'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings(); // Mở cài đặt hệ thống của app
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text(
              'Mở Cài Đặt',
              style: TextStyle(color: Colors.white, fontFamily: 'sora'),
            ),
          ),
        ],
      ),
      barrierDismissible: false, // Bắt buộc người dùng tương tác với Dialog
    );
  }

  void updateTab(int newIndex) {
    currentTabIndex.value = newIndex;
  }

  String getRouteNameByTab(int index) {
    switch (index) {
      case 0:
        return AppPages.dashboard;
      case 1:
        return AppPages.books;
      case 2:
        return AppPages.borrowCards;
      case 3:
        return AppPages.inventoryAudits;
      case 4:
        return AppPages.inventoryLedgers;
      default:
        return AppPages.dashboard;
    }
  }
}