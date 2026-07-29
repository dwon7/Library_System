
import 'package:get/get.dart';
import 'package:library_app/features/qr_scanner/qr_scanner_provider.dart';
import 'package:library_app/models/enum/book_condition.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerController extends GetxController {
  final QrScannerProvider provider;
  final String auditId;

  QrScannerController(this.provider, {required this.auditId});

  final isShowMessage = false.obs;
  final message = "".obs;
  final canScan = true.obs;
  final scannedCount = 0.obs;
  final totalCount = 0.obs;
  final books = <BookDetailRes>[].obs;
  final selectedBook = Rx<BookDetailRes?>(null);
  final selectedCondition = BookCondition.usable.obs;

  late MobileScannerController cameraController;

  @override
  void onInit() {
    super.onInit();
    cameraController = MobileScannerController(
      formats: [BarcodeFormat.qrCode],
      detectionSpeed: DetectionSpeed.unrestricted,
    );
    ever(canScan, (value) {
      if (value == true) {
        isShowMessage.value = false;
      }
    });
  }

  void loadData() async {
    try {
      final result = await provider.getAuditStats(auditId);
      scannedCount.value = result[0];
      totalCount.value = result[1];
    } catch (_) {}
  }

  void getBooks() async {
    try {
      books.value = await provider.getBooks();
    } catch (_) {}
  }

  void updateBookStatus() async {
    final book = selectedBook.value;
    if (book == null || book.bookId == null) return;
    try {
      final success = await provider.updateBookStatus(
          auditId, book.bookId!, selectedCondition.value.value);
      if (success) {
        message.value = "Cập nhật thành công";
      } else {
        message.value = "Cập nhật thất bại";
      }
    } catch (_) {
      message.value = "Cập nhật thất bại";
    }
    isShowMessage.value = true;
  }

  void scanQR(String value) async {
    if (!canScan.value) return;

    canScan.value = false;

    try {
      print("value: $value , $auditId ");
      final result = await provider.scanQR(auditId, value);
      message.value = result == 1 ? "Quét thành công! \n Sách đã được cập nhật ở trạng thái Còn sử dung" : "Mã QR không hợp lệ";
      print('result scan: ${result.toString()}');
    } catch (_) {
      message.value = "Mã QR không hợp lệ";
    }

    isShowMessage.value = true;

    Future.delayed(const Duration(seconds: 3), () {
      canScan.value = true;
    });
  }
}