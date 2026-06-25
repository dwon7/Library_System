import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:library_app/routes/app_pages.dart';

import 'home_provider.dart';

class HomeController extends GetxController {
  final HomeProvider provider;
  HomeController(this.provider);

  var currentTabIndex = 0.obs;

  // Khai báo 5 khóa điều hướng tương ứng cho 5 Tab riêng biệt
  final Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(), // Tab Tổng quan (Lưới các menu phụ hoặc dashboard chung)
    1: GlobalKey<NavigatorState>(), // Tab Sách
    2: GlobalKey<NavigatorState>(), // Tab Mượn sách
    3: GlobalKey<NavigatorState>(), // Tab Kiểm kê
    4: GlobalKey<NavigatorState>(), // Tab Nhập/Xuất
  };

  void updateTab(int newIndex) {
    currentTabIndex.value = newIndex;
  }

  // Hàm trả về chuỗi Route Key tương ứng với từng Tab định danh trong AppPages
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