// collections_overview.md


# THIẾT KẾ CẤU TRÚC CÁC BỘ SƯU TẬP (JSON) - HỆ THỐNG QUẢN LÝ THƯ VIỆN

Dưới đây là cấu trúc chi tiết của toàn bộ 6 bộ sưu tập (Collections) đã được chuẩn hóa tên trường sang tiếng Anh (camelCase), bổ sung kiểu dữ liệu và chú thích nghiêm ngặt từng dòng dựa theo nghiệp vụ quản lý thư viện của bạn.

---

###  Sách (books)
{
  // Mã ID tự sinh của tài liệu: ObjectId
  "_id": ObjectId("66741abcf123456789abcdef"),
  
  // Mã quản lý sách của thư viện: String
  "bookId": "MS-2026-01",
  
  // Tên tài liệu/đầu sách: String
  "title": "Giáo trình Cơ sở dữ liệu nâng cao",
  
  // Áp dụng LINK: Tham chiếu đến danh mục phân loại sách: ObjectId
  "categoryId": ObjectId("66744abcdef1234567890001"),
  
  // Năm xuất bản: int
  "publicationYear": 2025,
  
  // Nhà xuất bản: String
  "publisher": "NXB Bách Khoa",
  
  // Danh sách các tác giả tham gia viết sách (Mối quan hệ 1 - Nhiều dạng EMBED)
  "authors": [
    {
      // Họ và tên tác giả: String
      "fullName": "Lương Thị Hồng Lan",
      // Học hàm/Học vị của tác giả: String
      "degree": "Tiến sĩ"
    }
  ],
  
  // Loại hình tài liệu học liệu: String (Ví dụ: "Physical" hoặc "Digital")
  "documentType": "Physical",
  
  // Thuộc tính riêng của Sách giấy (Chỉ xuất hiện khi documentType là "Physical")
  "physicalInfo": {
    // Vị trí kho lưu trữ sách: String
    "warehouseLocation": "Khu A - Tầng 2",
    // Mã số kệ sách: String
    "shelfId": "KE-CNTT-04",
    // Tổng số lượng sách nhập về kho: int
    "totalQuantity": 15
  },
  
  // Thuộc tính riêng của Học liệu số (Chỉ xuất hiện khi documentType là "Digital")
  "digitalInfo": {
    // Định dạng tệp tin học liệu số: String (Ví dụ: "pdf", "epub")
    "fileFormat": "pdf",
    // Kích thước tệp tin (Đơn vị MB): String
    "fileSizeMb": "24.5",
    // Đường dẫn tải tài liệu trực tuyến: String
    "downloadUrl": "[https://thuvien.edu.vn/download/bigdata2026.pdf](https://thuvien.edu.vn/download/bigdata2026.pdf)",
    // Tổng số lượt tải xuống: int
    "downloadCount": 1000
  }
}



### Độc giả (users)
{
  // Mã ID tự sinh của độc giả: ObjectId
  "_id": ObjectId("66742cdba987654321fedcba"),
  
  // Mã số sinh viên/độc giả: String
  "userId": "2016700051",
  
  // Họ và tên độc giả: String
  "fullName": "Nguyễn Văn A",
  
  // Địa chỉ email độc giả: String
  "email": "nva@haui.edu.vn",
  
  // Chuyên ngành học tập: String
  "major": "CNTT",
  
  // Số điện thoại liên lạc: String
  "phoneNumber": "0123456789",
  
  // Tổng số lượt đã mượn sách từ trước đến nay: int
  "totalBorrowCount": 32
}



### Phiếu mượn trả (borrow_cards)
{
  // Mã ID tự sinh của phiếu mượn trả: ObjectId
  "_id": ObjectId("66743edff321654987abcdef"),
  
  // Mã quản lý phiếu mượn: String
  "cardId": "PM-2026-99999",
  
  // Áp dụng LINK: Tham chiếu tới ID của độc giả trong collection users: ObjectId
  "userId": ObjectId("66742cdba987654321fedcba"),
  
  // Ngày thực hiện mượn sách: String (Định dạng YYYY-MM-DD)
  "borrowDate": "2026-06-15",
  
  // Ngày hẹn trả sách muộn nhất: String (Định dạng YYYY-MM-DD)
  "dueDate": "2026-06-17",
  
  // Mảng chứa danh sách các sách được mượn cụ thể trong phiếu này
  "borrowDetails": [
    {
      // Áp dụng LINK: Tham chiếu tới ID của đầu sách trong collection books: ObjectId
      "bookId": ObjectId("66741abcf123456789abcdef"),
      // Số lượng cuốn sách mượn: int
      "quantity": 1,
      // Tình trạng sách lúc mượn: String
      "bookCondition": "Mới"
    }
  ],
  
  // Trạng thái phiếu mượn hiện tại: String (Ví dụ: "Đã trả sách", "Đang mượn")
  "status": "Đã trả sách"
}



### Danh mục sách (categories)
{
  // Mã ID tự sinh của danh mục: ObjectId
  "_id": ObjectId("66744abcdef1234567890001"),
  
  // Mã quản lý danh mục: String
  "categoryId": "DM-CNTT",
  
  // Tên danh mục: String
  "categoryName": "Công nghệ thông tin",
  
  // Mô tả chi tiết về danh mục: String
  "description": "Sách, giáo trình và tài liệu nghiên cứu về khoa học máy tính, phần mềm",
  
  // Vị trí khu vực lưu trữ vật lý của danh mục này: String
  "storageLocation": "Khu vực tầng 2 - Dãy kệ số 4"
}


### Phiếu nhập/xuất kho (inventory_ledgers)
{
  // Mã ID tự sinh của giao dịch kho: ObjectId
  "_id": ObjectId("66745abcdef1234567890002"),
  
  // Mã quản lý phiếu nhập xuất kho: String
  "ledgerId": "PNX-2026-0012",
  
  // Loại phiếu kho: int - 1: Nhập kho (Mua thêm sách), 2: Xuất kho (Bán sách cho SV)
  "ledgerType": 1,
  
  // Thời gian thực hiện giao dịch kho: String hoặc Date ISO
  "transactionDate": "2026-06-20T08:30:00Z",
  
  // Họ tên cán bộ phụ trách xử lý kho: String
  "staffInCharge": "Nguyễn Văn Kho",
  
  // Thông tin đối tác (Đa hình: Có thể là Nhà cung cấp hoặc Sinh viên mua sách)
  "partner": {
    // Tên của nhà cung cấp hoặc tên sinh viên: String
    "partnerName": "Nhà sách Giáo Dục Hà Nội",
    // Mã số thuế (nếu nhập) hoặc Mã số sinh viên (nếu xuất bán): String
    "taxOrStudentId": "0101234567"
  },
  
  // Mảng chứa danh sách chi tiết các loại sách được biến động kho
  "ledgerDetails": [
    {
      // Áp dụng LINK: Tham chiếu tới ID của sách trong collection books: ObjectId
      "bookId": ObjectId("66741abcf123456789abcdef"),
      // Số lượng sách giao dịch: int
      "quantity": 50,
      // Đơn giá của từng cuốn: int
      "unitPrice": 85000,
      // Thành tiền của dòng hàng này (quantity * unitPrice): int
      "totalAmount": 4250000
    }
  ],
  
  // Tổng số tiền của toàn bộ hóa đơn/phiếu: int
  "grandTotal": 4250000,
  
  // Ghi chú thêm về phiếu nhập/xuất này: String
  "notes": "Nhập bổ sung học liệu cho năm học mới"
}


### Phiếu kiểm kê sách (inventory_audits)
{
  // Mã ID tự sinh của phiếu kiểm kê: ObjectId
  "_id": ObjectId("66746abcdef1234567890003"),
  
  // Mã quản lý phiếu kiểm kê: String
  "auditId": "KK-2026-T06",
  
  // Ngày thực hiện hoạt động kiểm kê: String (Định dạng YYYY-MM-DD)
  "auditDate": "2026-06-24",
  
  // Danh sách các thành viên tham gia hội đồng kiểm đếm kho
  "auditBoard": [
    {
      // Họ tên thành viên: String
      "fullName": "Lương Thị Hồng Lan",
      // Vai trò trong hội đồng kiểm kê: String (Ví dụ: "Trưởng ban", "Ủy viên")
      "role": "Trưởng ban"
    },
    {
      // Họ tên thành viên: String
      "fullName": "Nguyễn Văn Kho",
      // Vai trò trong hội đồng kiểm kê: String
      "role": "Ủy viên"
    }
  ],
  
  // Trạng thái xử lý của phiếu kiểm kê: int - 1: Đã hoàn thành, 2: Chưa hoàn thành
  "status": 1,
  
  // Mảng chi tiết kết quả đếm thực tế và phân loại tình trạng sách tại quầy kệ
  "auditDetails": [
    {
      // Áp dụng LINK: Tham chiếu tới ID của đầu sách trong collection books: ObjectId
      "bookId": ObjectId("66741abcf123456789abcdef"),
      // Số lượng kiểm đếm thực tế của tình trạng này: int
      "quantity": 14,
      // Tình trạng sách: int - 1: còn sử dụng, 2: rách, nát, 3: mất
      "conditionType": 1
    },
    {
      // Áp dụng LINK: Tham chiếu tới ID của đầu sách trong collection books: ObjectId
      "bookId": ObjectId("66741abcf123456789abcdef"),
      // Số lượng sách bị hỏng: int
      "quantity": 1,
      // Tình trạng sách: int - 1: còn sử dụng, 2: rách, nát, 3: mất
      "conditionType": 2
    }
  ],
  
  // Tổng số lượng kiểm kê: int
  "totalAuditedQuantity": 15,
  
  // Ghi chú hoặc đề xuất xử lý sau kiểm kê: String
  "notes": "Kiểm kê định kỳ kho sách Công nghệ thông tin quý 2"
}



