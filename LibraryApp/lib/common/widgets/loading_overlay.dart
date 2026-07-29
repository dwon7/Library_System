import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Overlay loading toàn màn hình, KHÔNG dùng Get.dialog()/Get.back() vì những
/// hàm đó đẩy/pop trên Navigator route stack — nếu gọi đúng lúc tab đang
/// chuyển (1 controller bị huỷ, 1 controller khác được tạo cùng lúc), Get.back()
/// có thể pop nhầm route khác và overlay bị kẹt vĩnh viễn trên màn hình dù code
/// vẫn chạy "thành công". Chèn OverlayEntry trực tiếp là thao tác cây widget đơn
/// thuần, không phụ thuộc route stack nên tránh được lỗi lệch này.
class LoadingOverlay {
  static int _pendingCount = 0;
  static OverlayEntry? _entry;

  static void show() {
    _pendingCount++;
    if (kDebugMode) debugPrint('[LoadingOverlay] show() -> pendingCount=$_pendingCount');
    if (_pendingCount > 1) return;

    final overlayContext = Get.overlayContext;
    if (overlayContext == null) return;
    final overlay = Overlay.of(overlayContext, rootOverlay: true);

    _entry = OverlayEntry(
      builder: (_) => PopScope(
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
    );
    overlay.insert(_entry!);
  }

  static void hide() {
    if (kDebugMode) {
      debugPrint('[LoadingOverlay] hide() called, pendingCount(before)=$_pendingCount, hasEntry=${_entry != null}');
    }
    if (_pendingCount == 0) return;
    _pendingCount--;
    if (_pendingCount > 0) return;
    _entry?.remove();
    _entry = null;
    if (kDebugMode) debugPrint('[LoadingOverlay] entry removed');
  }
}
