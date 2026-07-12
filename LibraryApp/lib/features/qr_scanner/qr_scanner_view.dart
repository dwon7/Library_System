import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';
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
                // Phần thông báo
                Positioned(
                    child: child,
                ),

                // 1. Camera Scanner (vẫn giữ nguyên)
                MobileScanner(
                  onDetect: (capture) {
                    // Action xử lý sau
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
                      onPressed: () {
                        // Action nhập mã thủ công
                      },
                      icon: const Icon(Icons.keyboard),
                      label: const Text(
                        'Nhập mã/tên sách',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 4,
                      ),
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
            child: const Center(
              child: Text(
                'Di chuyển camera vào vùng mã QR/Barcode của sách',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
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