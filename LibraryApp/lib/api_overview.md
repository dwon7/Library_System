# Danh sách API — LibraryApp

> Tất cả API đều là fake, gọi `StorageService` (mock data in-memory), delay 200–800ms.

| # | API | Input | Output | Mô tả | Nơi dùng |
|---|---|---|---|---|---|
| 1 | `getBooks` | — | `Future<List<BookDetailRes>>` | Lấy toàn bộ danh sách sách | new_borrow_card, new_inventory_audit, new_inventory_ledger |
| 2 | `getUsers` | — | `Future<List<UserDetailRes>>` | Lấy toàn bộ danh sách độc giả | new_borrow_card |
| 3 | `getCategories` | — | `Future<List<CategoryEntity>>` | Lấy toàn bộ danh mục sách | books |
| 4 | `getBookById` | `String bookId` | `Future<BookDetailRes?>` | Lấy chi tiết 1 sách theo mã. `null` nếu không thấy | book_detail |
| 5 | `getBooksByCategoryId` | `String categoryId`, `String textSearch` | `Future<List<BookDetailEntity>>` | Lọc sách theo danh mục (`"-1"` = all) + từ khóa | books |
| 6 | `getBorrowCardById` | `String cardId` | `Future<BorrowCardDetailRes?>` | Lấy chi tiết 1 phiếu mượn theo mã | borrow_card_detail |
| 7 | `getUserName` | `String userId` | `String` (sync) | Lấy `fullName` độc giả theo userId. `""` nếu không thấy | borrow_card_detail |
| 8 | `getDueTodayCount` | — | `Future<int>` | Đếm số phiếu mượn đến hạn hôm nay | borrow_cards |
| 9 | `getCountByStatus` | `int status` | `Future<int>` | Đếm số item theo trạng thái. BorrowCard: 0=all,1=done,2=borrowing,3=overdue. Audit: 1=done,2=incomplete | borrow_cards, inventory_audits |
| 10 | `getCardsByStatus` | `int status` | `Future<List<BorrowCardDetailRes>>` | Lấy tối đa 4 phiếu mượn theo status, sắp xếp `borrowDate` giảm | borrow_cards |
| 11 | `getAuditsByStatus` | `int status` | `Future<List<InventoryAuditDetailRes>>` | Lấy tối đa 4 phiếu kiểm kê theo status, sắp xếp `auditDate` giảm | inventory_audits |
| 12 | `getLedgerById` | `String ledgerId` | `Future<InventoryLedgerDetailRes?>` | Lấy chi tiết 1 phiếu nhập/xuất theo mã | inventory_ledger_detail |
| 13 | `getCountByType` | `int type` | `Future<int>` | Đếm số phiếu theo loại: `1`=nhập kho, `2`=xuất kho | inventory_ledgers |
| 14 | `getLedgersByType` | `int type` | `Future<List<InventoryLedgerDetailRes>>` | Lấy tối đa 4 phiếu theo loại, sắp xếp `transactionDate` giảm | inventory_ledgers |
| 15 | `getBorrowCountByYear` | `int year` | `Future<List<MonthlyBorrowCount>>` | Đếm số phiếu mượn theo 12 tháng trong năm | dashboard |
| 16 | `getCategoryBorrowRatio` | `int month`, `int year` | `Future<List<CategoryRatio>>` | Tỉ lệ danh mục sách mượn trong tháng (mock) | dashboard |
| 17 | `getBorrowStatusRatio` | `int month`, `int year` | `Future<BorrowStatusRatio>` | Số phiếu theo 3 trạng thái: hoàn thành, đang mượn, quá hạn trong tháng | dashboard |
| 18 | `getTopBorrowers` | `int month`, `int year` | `Future<List<BorrowerStat>>` | Top 5 độc giả mượn nhiều nhất trong tháng | dashboard |
| 19 | `generateCardId` | — | `Future<String>` | Sinh mã phiếu mượn tự động `PM-XXX` | new_borrow_card |
| 20 | `generateAuditId` | — | `Future<String>` | Sinh mã phiếu kiểm kê tự động `KK-XXX` | new_inventory_audit |
| 21 | `generateLedgerId` | `int ledgerType` | `Future<String>` | Sinh mã phiếu nhập/xuất: `1`→`NK-XXX`, `2`→`XK-XXX` | new_inventory_ledger |
| 22 | `addBorrowCard` | `BorrowCardDetailRes card` | `Future<bool>` | Thêm phiếu mượn mới | new_borrow_card |
| 23 | `addAudit` | `InventoryAuditDetailRes audit` | `Future<bool>` | Thêm phiếu kiểm kê mới | new_inventory_audit |
| 24 | `addLedger` | `InventoryLedgerDetailRes ledger` | `Future<bool>` | Thêm phiếu nhập/xuất kho mới | new_inventory_ledger |

---

**Tổng: 24 API duy nhất** (đã deduplicate `getBooks` xuất hiện 3 lần, `getCountByStatus` xuất hiện 2 lần).

### Phân loại theo nghiệp vụ

| Nhóm | API |
|---|---|
| **Đọc danh sách** | `getBooks`, `getUsers`, `getCategories`, `getBooksByCategoryId`, `getCardsByStatus`, `getAuditsByStatus`, `getLedgersByType` |
| **Đọc chi tiết** | `getBookById`, `getBorrowCardById`, `getLedgerById` |
| **Thống kê / dashboard** | `getDueTodayCount`, `getCountByStatus`, `getCountByType`, `getBorrowCountByYear`, `getCategoryBorrowRatio`, `getBorrowStatusRatio`, `getTopBorrowers` |
| **Sinh mã** | `generateCardId`, `generateAuditId`, `generateLedgerId` |
| **Ghi** | `addBorrowCard`, `addAudit`, `addLedger` |
| **Helper** | `getUserName` |
