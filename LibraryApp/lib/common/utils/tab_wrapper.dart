// lib/modules/home/widgets/getx_tab_wrapper.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXTabWrapper<T extends GetxController> extends StatefulWidget {
  // Thay thế InstanceParamBuilder bằng InstanceBuilderCallback chuẩn GetX mới
  final InstanceBuilderCallback<T> controllerBuilder;
  final Widget child;

  const GetXTabWrapper({
    super.key,
    required this.controllerBuilder,
    required this.child,
  });

  @override
  State<GetXTabWrapper<T>> createState() => _GetXTabWrapperState<T>();
}

// Lưu ý: Sửa luôn tên class State cho đồng bộ với tên class chính ở trên
class _GetXTabWrapperState<T extends GetxController> extends State<GetXTabWrapper<T>> {
  bool _isInitialized = false;

  @override
  Widget build(BuildContext context) {
    // Chỉ khi Tab này được hiển thị lần đầu tiên, Controller và Provider mới được init vào bộ nhớ
    if (!_isInitialized) {
      Get.put(widget.controllerBuilder());
      _isInitialized = true;
    }
    return widget.child;
  }

  @override
  void dispose() {
    // Xóa Controller khỏi RAM khi màn hình HomeView chứa Tab bị đóng hoàn toàn
    Get.delete<T>();
    super.dispose();
  }
}