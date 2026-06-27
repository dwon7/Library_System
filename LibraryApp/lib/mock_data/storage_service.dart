

// lib/data/services/storage_service.dart
import 'package:get/get.dart';
import 'package:library_app/models/ressponses/book_detail_res.dart';
import 'package:library_app/models/ressponses/borrow_card_detail_res.dart';
import 'package:library_app/models/ressponses/user_detail_res.dart';

import '../models/ressponses/category_detail_res.dart';
import '../models/ressponses/inventory_audit_detail_res.dart';
import '../models/ressponses/inventory_ledger_detail_res.dart';

class StorageService extends GetxService {
  // Khởi tạo 6 danh sách RxList toàn cục
  final books = <BookDetailRes>[].obs;
  final users = <UserDetailRes>[].obs;
  final borrowCards = <BorrowCardDetailRes>[].obs;
  final categories = <CategoryDetailRes>[].obs;
  final inventoryLedgers = <InventoryLedgerDetailRes>[].obs;
  final inventoryAudits = <InventoryAuditDetailRes>[].obs;

  /// Hàm khởi tạo dữ liệu mẫu ban đầu (Mock Data) khi mở App
  Future<StorageService> init() async {
    // Thêm dữ liệu mẫu cho Categories
    categories.assignAll([
      CategoryDetailRes(categoryId: "DM-CNTT", categoryName: "Công nghệ thông tin"),
      CategoryDetailRes(categoryId: "DM-KT", categoryName: "Kinh tế & Quản trị"),
      CategoryDetailRes(categoryId: "DM-VH", categoryName: "Văn học"),
      CategoryDetailRes(categoryId: "DM-NN", categoryName: "Ngoại ngữ"),
    ]);

    // Thêm dữ liệu mẫu cho Books
    books.assignAll([
      BookDetailRes(bookId: "MS-01", publisher: "NXB Kim Đồng", title: "Lập trình Flutter & GetX", categoryId: "DM-CNTT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 10)),
      BookDetailRes(bookId: "MS-02", publisher: "NXB Giáo dục", title: "Cấu trúc dữ liệu & Giải thuật", categoryId: "DM-CNTT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 7)),
      BookDetailRes(bookId: "MS-03", publisher: "NXB Kim Đồng", title: "Lập trình Java cơ bản", categoryId: "DM-CNTT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 5)),
      BookDetailRes(bookId: "MS-04", publisher: "NXB Kim Đồng", title: "Python cho khoa học dữ liệu", categoryId: "DM-CNTT", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "PDF", fileSizeMb: "15.2", downloadCount: 230)),
      BookDetailRes(bookId: "MS-05", publisher: "NXB Giáo dục", title: "Nhập môn AI & Machine Learning", categoryId: "DM-CNTT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 8)),
      BookDetailRes(bookId: "MS-06", publisher: "NXB Kim Đồng", title: "Lập trình Dart từ A đến Z", categoryId: "DM-CNTT", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "EPUB", fileSizeMb: "8.7", downloadCount: 145)),
      BookDetailRes(bookId: "MS-07", publisher: "NXB Giáo dục", title: "Hệ điều hành Linux", categoryId: "DM-CNTT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 6)),
      BookDetailRes(bookId: "MS-08", publisher: "NXB Kim Đồng", title: "Kinh tế học vi mô", categoryId: "DM-KT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 12)),
      BookDetailRes(bookId: "MS-09", publisher: "NXB Kim Đồng", title: "Quản trị doanh nghiệp", categoryId: "DM-KT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 4)),
      BookDetailRes(bookId: "MS-10", publisher: "NXB Giáo dục", title: "Nguyên lý kế toán", categoryId: "DM-KT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 9)),
      BookDetailRes(bookId: "MS-11", publisher: "NXB Kim Đồng", title: "Marketing căn bản", categoryId: "DM-KT", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "PDF", fileSizeMb: "12.4", downloadCount: 312)),
      BookDetailRes(bookId: "MS-12", publisher: "NXB Kim Đồng", title: "Tài chính doanh nghiệp", categoryId: "DM-KT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 3)),
      BookDetailRes(bookId: "MS-13", publisher: "NXB Kim Đồng", title: "Khởi nghiệp đổi mới sáng tạo", categoryId: "DM-KT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 15)),
      BookDetailRes(bookId: "MS-14", publisher: "NXB Kim Đồng", title: "Thương mại điện tử", categoryId: "DM-KT", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "PDF", fileSizeMb: "20.1", downloadCount: 88)),
      BookDetailRes(bookId: "MS-15", publisher: "NXB Kim Đồng", title: "Truyện Kiều", categoryId: "DM-VH", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 20)),
      BookDetailRes(bookId: "MS-16", publisher: "NXB Giáo dục", title: "Tắt đèn", categoryId: "DM-VH", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 11)),
      BookDetailRes(bookId: "MS-17", publisher: "NXB Kim Đồng", title: "Số đỏ", categoryId: "DM-VH", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 8)),
      BookDetailRes(bookId: "MS-18", publisher: "NXB Kim Đồng", title: "Nhật ký Đặng Thùy Trâm", categoryId: "DM-VH", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 14)),
      BookDetailRes(bookId: "MS-19", publisher: "NXB Giáo dục", title: "Tôi thấy hoa vàng trên cỏ xanh", categoryId: "DM-VH", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 6)),
      BookDetailRes(bookId: "MS-20", publisher: "NXB Giáo dục", title: "Mắt biếc", categoryId: "DM-VH", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "EPUB", fileSizeMb: "3.2", downloadCount: 520)),
      BookDetailRes(bookId: "MS-21", publisher: "NXB Thời đại", title: "English Grammar In Use", categoryId: "DM-NN", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 25)),
      BookDetailRes(bookId: "MS-22", publisher: "NXB Kim Đồng", title: "TOEIC 990", categoryId: "DM-NN", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 18)),
      BookDetailRes(bookId: "MS-23", publisher: "NXB Giáo dục", title: "IELTS Cambridge 17", categoryId: "DM-NN", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 10)),
      BookDetailRes(bookId: "MS-24", publisher: "NXB Kim Đồng", title: "Tiếng Pháp giao tiếp", categoryId: "DM-NN", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "MP3", fileSizeMb: "45.6", downloadCount: 67)),
      BookDetailRes(bookId: "MS-25", publisher: "Thời đại", title: "Tiếng Nhật Minna no Nihongo", categoryId: "DM-NN", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 16)),
      BookDetailRes(bookId: "MS-26", publisher: "NXB Kim Đồng", title: "Anh văn chuyên ngành CNTT", categoryId: "DM-NN", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 5)),
      BookDetailRes(bookId: "MS-27", publisher: "NXB Thời đại", title: "Tiếng Hàn sơ cấp", categoryId: "DM-NN", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "PDF", fileSizeMb: "18.3", downloadCount: 198)),
      BookDetailRes(bookId: "MS-28", publisher: "NXB Thời đại", title: "React Native toàn tập", categoryId: "DM-CNTT", documentType: "Physical", physicalInfo: PhysicalInfo(totalQuantity: 7)),
      BookDetailRes(bookId: "MS-29", publisher: "NXB Thời đại", title: "Blockchain & Cryptocurrency", categoryId: "DM-CNTT", documentType: "Digital", digitalInfo: DigitalInfo(fileFormat: "PDF", fileSizeMb: "25.0", downloadCount: 410)),
    ]);

    // Thêm dữ liệu mẫu cho Users
    users.assignAll([
      UserDetailRes(userId: "ND-001", fullName: "Nguyễn Văn A", email: "a@lib.vn"),
      UserDetailRes(userId: "ND-002", fullName: "Trần Thị B", email: "b@lib.vn"),
      UserDetailRes(userId: "ND-003", fullName: "Lê Văn C", email: "c@lib.vn"),
      UserDetailRes(userId: "ND-004", fullName: "Phạm Thị D", email: "d@lib.vn"),
      UserDetailRes(userId: "ND-005", fullName: "Hoàng Văn E", email: "e@lib.vn"),
    ]);

    final today = DateTime.now().toIso8601String().substring(0, 10);
    final yesterday = DateTime.now().subtract(const Duration(days: 1)).toIso8601String().substring(0, 10);
    final tomorrow = DateTime.now().add(const Duration(days: 1)).toIso8601String().substring(0, 10);

    // Thêm dữ liệu mẫu cho BorrowCards
    borrowCards.assignAll([
      BorrowCardDetailRes(cardId: "PM-001", userId: "ND-001", borrowDate: yesterday, dueDate: today, status: 2,
          borrowDetails: [BorrowDetail(bookId: "MS-01", bookName: "Lập trình Flutter & GetX", quantity: 1), BorrowDetail(bookId: "MS-08", bookName: "Kinh tế học vi mô", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-002", userId: "ND-002", borrowDate: yesterday, dueDate: today, status: 2,
          borrowDetails: [BorrowDetail(bookId: "MS-15", bookName: "Truyện Kiều", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-003", userId: "ND-003", borrowDate: yesterday, dueDate: today, status: 1,
          borrowDetails: [BorrowDetail(bookId: "MS-21", bookName: "English Grammar In Use", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-004", userId: "ND-001", borrowDate: yesterday, dueDate: tomorrow, status: 1,
          borrowDetails: [BorrowDetail(bookId: "MS-02", bookName: "Cấu trúc dữ liệu & Giải thuật", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-005", userId: "ND-004", borrowDate: yesterday, dueDate: tomorrow, status: 2,
          borrowDetails: [BorrowDetail(bookId: "MS-09", bookName: "Quản trị doanh nghiệp", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-006", userId: "ND-002", borrowDate: yesterday, dueDate: yesterday, status: 3,
          borrowDetails: [BorrowDetail(bookId: "MS-16", bookName: "Tắt đèn", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-007", userId: "ND-005", borrowDate: yesterday, dueDate: yesterday, status: 3,
          borrowDetails: [BorrowDetail(bookId: "MS-22", bookName: "TOEIC 990", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-008", userId: "ND-003", borrowDate: yesterday, dueDate: tomorrow, status: 1,
          borrowDetails: [BorrowDetail(bookId: "MS-03", bookName: "Lập trình Java cơ bản", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-009", userId: "ND-004", borrowDate: yesterday, dueDate: today, status: 2,
          borrowDetails: [BorrowDetail(bookId: "MS-10", bookName: "Nguyên lý kế toán", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-010", userId: "ND-001", borrowDate: yesterday, dueDate: tomorrow, status: 1,
          borrowDetails: [BorrowDetail(bookId: "MS-04", bookName: "Python cho khoa học dữ liệu", quantity: 2)]),
      BorrowCardDetailRes(cardId: "PM-011", userId: "ND-005", borrowDate: yesterday, dueDate: yesterday, status: 3,
          borrowDetails: [BorrowDetail(bookId: "MS-17", bookName: "Số đỏ", quantity: 1)]),
      BorrowCardDetailRes(cardId: "PM-012", userId: "ND-002", borrowDate: yesterday, dueDate: today, status: 2,
          borrowDetails: [BorrowDetail(bookId: "MS-28", bookName: "React Native toàn tập", quantity: 1)]),
    ]);

    // Thêm dữ liệu mẫu cho InventoryLedgers
    inventoryLedgers.assignAll([
      InventoryLedgerDetailRes(ledgerId: "NK-001", ledgerType: 1, transactionDate: yesterday, staffInCharge: "NV01", partner: Partner(partnerName: "NXB Kim Đồng", taxOrStudentId: "0301234567"), grandTotal: 1500000,
      ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
        LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
        LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
        LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),],),
      InventoryLedgerDetailRes(ledgerId: "NK-002", ledgerType: 1, transactionDate: yesterday, staffInCharge: "NV02", partner: Partner(partnerName: "NXB Giáo Dục", taxOrStudentId: "0109876543"), grandTotal: 2300000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
        LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
        LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
        LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "NK-003", ledgerType: 1, transactionDate: today, staffInCharge: "NV01", partner: Partner(partnerName: "NXB Trẻ", taxOrStudentId: "0305551212"), grandTotal: 800000,ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
        LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
        LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
        LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "NK-004", ledgerType: 1, transactionDate: today, staffInCharge: "NV03", partner: Partner(partnerName: "NXB Kim Đồng", taxOrStudentId: "0301234567"), grandTotal: 4200000,ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
        LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
        LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
        LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "NK-005", ledgerType: 1, transactionDate: tomorrow, staffInCharge: "NV02", partner: Partner(partnerName: "NXB Tổng Hợp", taxOrStudentId: "0203334445"), grandTotal: 950000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
      LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
      LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
      LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "XK-001", ledgerType: 2, transactionDate: yesterday, staffInCharge: "NV01", partner: Partner(partnerName: "SV Nguyễn Văn A", taxOrStudentId: "SV001"), grandTotal: 200000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
    LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
    LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
    LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "XK-002", ledgerType: 2, transactionDate: yesterday, staffInCharge: "NV03", partner: Partner(partnerName: "SV Trần Thị B", taxOrStudentId: "SV002"), grandTotal: 350000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
    LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
    LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
    LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "XK-003", ledgerType: 2, transactionDate: today, staffInCharge: "NV02", partner: Partner(partnerName: "Khoa CNTT", taxOrStudentId: "KH001"), grandTotal: 1200000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
    LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
    LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
    LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "XK-004", ledgerType: 2, transactionDate: today, staffInCharge: "NV01", partner: Partner(partnerName: "SV Lê Văn C", taxOrStudentId: "SV003"), grandTotal: 180000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
    LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
    LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
    LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "XK-005", ledgerType: 2, transactionDate: tomorrow, staffInCharge: "NV03", partner: Partner(partnerName: "Phòng Đào Tạo", taxOrStudentId: "DT001"), grandTotal: 2500000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
    LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
    LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
    LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
      InventoryLedgerDetailRes(ledgerId: "XK-006", ledgerType: 2, transactionDate: tomorrow, staffInCharge: "NV02", partner: Partner(partnerName: "SV Phạm Thị D", taxOrStudentId: "SV004"), grandTotal: 550000, ledgerDetails: [LedgerDetail(bookId: "MS-24", quantity: 3, unitPrice: 20000, totalAmount: 60000,),
    LedgerDetail(bookId: "MS-21", quantity: 5, unitPrice: 40000, totalAmount: 200000,),
    LedgerDetail(bookId: "MS-28", quantity: 10, unitPrice: 5000, totalAmount: 50000,),
    LedgerDetail(bookId: "MS-29", quantity: 20, unitPrice: 25000, totalAmount: 500000,),]),
    ]);

    // Thêm dữ liệu mẫu cho InventoryAudits
    inventoryAudits.assignAll([
      InventoryAuditDetailRes(auditId: "KK-001", auditDate: yesterday, status: 1, totalAuditedQuantity: 250, auditBoard: [AuditBoardMember(fullName: "Nguyễn Văn A", role: "Trưởng ban"), AuditBoardMember(fullName: "Trần Thị B", role: "Ủy viên")], notes: "Đúng số liệu"),
      // InventoryAuditDetailRes(auditId: "KK-002", auditDate: yesterday, status: 2, totalAuditedQuantity: 0, auditBoard: [AuditBoardMember(fullName: "Lê Văn C", role: "Trưởng ban"), AuditBoardMember(fullName: "Phạm Thị D", role: "Ủy viên")]),
      InventoryAuditDetailRes(auditId: "KK-003", auditDate: today, status: 1, totalAuditedQuantity: 180, auditBoard: [AuditBoardMember(fullName: "Hoàng Văn E", role: "Trưởng ban"), AuditBoardMember(fullName: "Nguyễn Văn A", role: "Ủy viên")], notes: "Thiếu 2 cuốn"),
      InventoryAuditDetailRes(auditId: "KK-004", auditDate: today, status: 2, totalAuditedQuantity: 0, auditBoard: [AuditBoardMember(fullName: "Trần Thị B", role: "Trưởng ban")]),
      InventoryAuditDetailRes(auditId: "KK-005", auditDate: today, status: 1, totalAuditedQuantity: 320, auditBoard: [AuditBoardMember(fullName: "Phạm Thị D", role: "Trưởng ban"), AuditBoardMember(fullName: "Hoàng Văn E", role: "Ủy viên"), AuditBoardMember(fullName: "Lê Văn C", role: "Ủy viên")]),
      // InventoryAuditDetailRes(auditId: "KK-006", auditDate: tomorrow, status: 2, totalAuditedQuantity: 0, auditBoard: [AuditBoardMember(fullName: "Nguyễn Văn A", role: "Trưởng ban")]),
    ]);

    return this;
  }

  // ===========================================================================
  // CÁC HÀM TIỆN ÍCH ADD / UPDATE / DELETE CHO TOÀN BỘ 6 LIST
  // ===========================================================================

  // 1. QUẢN LÝ SÁCH (BOOKS)
  void addBook(BookDetailRes item) => books.add(item);
  void updateBook(BookDetailRes item) {
    int index = books.indexWhere((element) => element.bookId == item.bookId);
    if (index != -1) books[index] = item;
  }
  void deleteBook(String bookId) => books.removeWhere((element) => element.bookId == bookId);

  // 2. QUẢN LÝ DANH MỤC (CATEGORIES)
  void addCategory(CategoryDetailRes item) => categories.add(item);
  void updateCategory(CategoryDetailRes item) {
    int index = categories.indexWhere((element) => element.categoryId == item.categoryId);
    if (index != -1) categories[index] = item;
  }
  void deleteCategory(String categoryId) => categories.removeWhere((element) => element.categoryId == categoryId);

  // 3. QUẢN LÝ ĐỘC GIẢ (USERS)
  void addUser(UserDetailRes item) => users.add(item);
  void updateUser(UserDetailRes item) {
    int index = users.indexWhere((element) => element.userId == item.userId);
    if (index != -1) users[index] = item;
  }
  void deleteUser(String userId) => users.removeWhere((element) => element.userId == userId);

  // 4. PHIẾU MƯỢN TRẢ (BORROW CARDS)
  void addBorrowCard(BorrowCardDetailRes item) => borrowCards.add(item);
  void updateBorrowCard(BorrowCardDetailRes item) {
    int index = borrowCards.indexWhere((element) => element.cardId == item.cardId);
    if (index != -1) borrowCards[index] = item;
  }

  // 5. NHẬP XUẤT KHO (LEDGERS)
  void addLedger(InventoryLedgerDetailRes item) => inventoryLedgers.add(item);

  // 6. KIỂM KÊ (AUDITS)
  void addAudit(InventoryAuditDetailRes item) => inventoryAudits.add(item);
}