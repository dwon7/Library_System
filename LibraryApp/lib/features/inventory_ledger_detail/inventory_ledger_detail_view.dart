import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:library_app/common/widgets/app_header.dart';

import '../../common/widgets/app_toast.dart';
import '../../models/ressponses/inventory_ledger_detail_res.dart';
import '../../models/enum/ledger_type.dart';
import 'inventory_ledger_detail_controller.dart';

class InventoryLedgerDetailView
    extends GetView<InventoryLedgerDetailController> {
  const InventoryLedgerDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: "Chi tiết phiếu kho",
        icon: Icons.delete_outline_outlined,
        onTap: () => _showDeleteDialog(context),
      ),

      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final l = controller.ledger.value;
              if (l == null) return const SizedBox.shrink();
              return _buildContent(l);
            }),
          ),
          _buildPrintButton(context),
        ],
      ),
    );
  }

  Widget _buildPrintButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 10 + MediaQuery.of(context).viewPadding.bottom,
        top: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => AppToast.show("Tính năng đang phát triển"),
        child: const Text(
          "In phiếu",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildContent(InventoryLedgerDetailRes l) {
    final type = LedgerType.fromValue(l.ledgerType);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: type.color.withOpacity(0.15),
                // borderRadius: BorderRadius.circular(20),
                border: Border.all(color: type.color.withOpacity(0.4)),
              ),
              child: Center(
                child: Text(
                  type.label,
                  style: TextStyle(
                    color: type.color,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildRow("Mã phiếu", l.ledgerId),
          _buildDivider(),
          _buildRow("Ngày giao dịch", l.transactionDate),
          _buildDivider(),
          _buildRow("Nhân viên", l.staffInCharge),
          _buildDivider(),
          _buildRow("Đối tác", l.partner?.partnerName),
          _buildDivider(),
          _buildRow("Mã số thuế/MSSV", l.partner?.taxOrStudentId),
          _buildDivider(),
          _buildRow(
            "Tổng tiền",
            l.grandTotal != null ? "${l.grandTotal} đ" : null,
          ),
          _buildDivider(),
          _buildRow("Ghi chú", l.notes),

          if (l.ledgerDetails != null && l.ledgerDetails!.isNotEmpty) ...[
            _buildSectionTitle("Chi tiết phiếu"),
            ...l.ledgerDetails!.map((d) => _buildLedgerDetail(d, l.ledgerDetails!.indexOf(d))),
          ],
        ],
      ),
    );
  }

  Widget _buildLedgerDetail(LedgerDetail d, int index) {
    return Obx(() {
      final bookDetail = controller.bookDetails.value?[index];
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow("Mã sách", d.bookId),
            const SizedBox(height: 4),
            _buildRow("Tên sách", bookDetail?.title ?? ""),
            const SizedBox(height: 4),
            _buildRow("Nhà xuất bản", bookDetail?.publisher ?? ""),
            const SizedBox(height: 4),
            _buildRow("Đơn giá", d.unitPrice?.toString()),
            const SizedBox(height: 4),
            _buildRow("Số lượng", d.quantity?.toString()),
            const SizedBox(height: 4),
            _buildRow("Thành tiền", d.totalAmount?.toString()),
          ],
        ),
      );

    });
  }

  Widget _buildRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "—",
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      // Ngăn người dùng tắt dialog khi bấm ra ngoài vùng trống
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red),
              SizedBox(width: 8),
              Text('Xác nhận xóa'),
            ],
          ),
          content: const Text('Bạn có chắc chắn muốn xoá bản ghi này?'),
          actions: <Widget>[
            // NÚT KHÔNG: Style nhẹ nhàng, viền xám, chữ xám
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[400]!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                // Đóng dialog và trả về giá trị false
                Navigator.of(context).pop(false);
              },
              child: const Text('Không'),
            ),

            // NÚT ĐỒNG Ý: Style nổi bật, nền đỏ, chữ trắng để cảnh báo
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                // Đóng dialog và trả về giá trị true
                Navigator.of(context).pop(true);
              },
              child: const Text('Đồng ý'),
            ),
          ],
        );
      },
    ).then((value) {
      // Xử lý kết quả sau khi dialog đóng
      if (value == true) {
        // Thực hiện hàm xóa bản ghi của bạn ở đây
        print("Người dùng đã chọn: ĐỒNG Ý XOÁ");
      } else {
        print("Người dùng đã chọn: KHÔNG XOÁ");
      }
    });
  }
}
