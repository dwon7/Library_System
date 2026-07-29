import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';
import 'package:library_app/models/enum/book_condition.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import 'package:library_app/routes/app_pages.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

// Giả định bạn đã tạo file controller
import 'qr_scanner_controller.dart';

class QrScannerView extends GetView<QrScannerController> {
  const QrScannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(title: "Kiểm kê sách"),
      body: Column(
        children: [
          // --- PHẦN 1: QR SCANNER ---
          Expanded(
            child: Stack(
              children: [

                // 1. Camera Scanner (vẫn giữ nguyên)
                MobileScanner(
                  controller:controller.cameraController,
                  onDetect: (capture) {
                    final barcode = capture.barcodes.firstOrNull;
                    if (barcode != null && barcode.rawValue != null) {
                      controller.scanQR(barcode.rawValue!);
                    }
                  },
                ),

                // 2. Lớp phủ Overlay (TỐI SUNG QUANH, CÓ KHUNG 4 GÓC TRẮNG MỚI)
                const _ScannerOverlayWithCorners(),

                // 3. Nút bấm cố định (vẫn giữ nguyên)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _showManualEntryDialog(),
                      icon: const Icon(Icons.keyboard),
                      label: const Text(
                        'Nhập mã/tên sách',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                ),

                // Phần thông báo dạng toast
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Obx(
                        () => Container(
                      height: 50,
                      color: controller.isShowMessage.value
                          ? Colors.black54
                          : Colors.transparent,
                      alignment: Alignment.center,
                      child: controller.isShowMessage.value
                          ? Text(
                        controller.message.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                          : const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- PHẦN 2: FOOTER ---
          Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -3),
                  blurRadius: 5,
                )
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Obx(() => Text(
                  '${controller.scannedCount.value}/${controller.totalCount.value}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    final auditId = Get.arguments as String? ?? '';
                    Get.toNamed(AppPages.inventoryAuditDetail,
                        arguments: auditId);
                  },
                  child: const Text(
                    'Xem chi tiết >',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntryDialog() {
    controller.getBooks();
    controller.selectedBook.value = null;
    controller.selectedCondition.value = BookCondition.usable;

    Get.dialog(
      AlertDialog(
        title: const Text("Kiểm kê thủ công"),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(() => DropdownButtonFormField<BookDetailRes>(
                    value: controller.selectedBook.value,
                    decoration: const InputDecoration(
                      labelText: "Tên/mã sách",
                      border: OutlineInputBorder(),
                    ),
                    items: controller.books
                        .map((b) => DropdownMenuItem(
                              value: b,
                              child: Text(b.title ?? b.bookCode ?? ""),
                            ))
                        .toList(),
                    onChanged: (val) =>
                        controller.selectedBook.value = val,
                  )),
              const SizedBox(height: 12),
              Obx(() => DropdownButtonFormField<BookCondition>(
                    value: controller.selectedCondition.value,
                    decoration: const InputDecoration(
                      labelText: "Trạng thái sách",
                      border: OutlineInputBorder(),
                    ),
                    items: BookCondition.values
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.label),
                            ))
                        .toList(),
                    onChanged: (val) =>
                        controller.selectedCondition.value = val!,
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Huỷ"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateBookStatus();
              Get.back();
            },
            child: const Text("Cập nhật"),
          ),
        ],
      ),
    );
  }
}

// Widget lớp phủ mới, kết hợp làm tối và vẽ 4 góc trắng
class _ScannerOverlayWithCorners extends StatelessWidget {
  const _ScannerOverlayWithCorners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Màu tối xung quanh khung quét
        final overlayColor = Colors.black.withOpacity(0.65);
        // Kích thước khung quét (70% chiều rộng)
        final scanAreaSize = constraints.maxWidth * 0.8;

        return Stack(
          children: [
            // A. Lớp phủ làm tối (Đục lỗ ở giữa)
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                overlayColor,
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      backgroundBlendMode: BlendMode.dstOut,
                    ),
                  ),
                  Center(
                    child: Container(
                      height: scanAreaSize,
                      width: scanAreaSize,
                      decoration: BoxDecoration(
                        color: Colors.black, // Trong suốt ở giữa
                        borderRadius: BorderRadius.circular(16), // Bo nhẹ lỗ đục
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // B. Vẽ 4 góc trắng (Sử dụng CustomPaint)
            Center(
              child: SizedBox(
                height: scanAreaSize,
                width: scanAreaSize,
                child: CustomPaint(
                  painter: _ScannerCornerPainter(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// CustomPainter để vẽ 4 góc bo tròn màu trắng
class _ScannerCornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // TẤT CẢ LÀ MÀU TRẮNG
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0; // Độ dày của góc

    final cornerLength = size.width * 0.15; // Chiều dài mỗi góc (15% chiều rộng)
    final radius = 16.0; // Bán kính bo tròn góc

    final path = Path();

    // --- Góc trên bên trái ---
    path.moveTo(0, cornerLength);
    path.lineTo(0, radius);
    path.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
    );
    path.lineTo(cornerLength, 0);

    // --- Góc trên bên phải ---
    path.moveTo(size.width - cornerLength, 0);
    path.lineTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(size.width, cornerLength);

    // --- Góc dưới bên phải ---
    path.moveTo(size.width, size.width - cornerLength);
    path.lineTo(size.width, size.width - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.width),
      radius: Radius.circular(radius),
    );
    path.lineTo(size.width - cornerLength, size.width);

    // --- Góc dưới bên trái ---
    path.moveTo(cornerLength, size.width);
    path.lineTo(radius, size.width);
    path.arcToPoint(
      Offset(0, size.width - radius),
      radius: Radius.circular(radius),
    );
    path.lineTo(0, size.width - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}