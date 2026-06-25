

class BorrowCardDetailRes {
  String? id;
  String? cardId;
  String? userId; // Link ID độc giả
  String? borrowDate;
  String? dueDate;
  int? status; // 1: hoàn thành, 2: đang mượn, 3: quá hạn
  List<BorrowDetail>? borrowDetails;
  String? statusName; // computed: name for display
  String? userName;  // resolved from users

  BorrowCardDetailRes({
    this.id,
    this.cardId,
    this.userId,
    this.userName,
    this.borrowDate,
    this.dueDate,
    this.borrowDetails,
    this.status,
  });

  factory BorrowCardDetailRes.fromJson(Map<String, dynamic> json) => BorrowCardDetailRes(
    id: json['_id']?.toString(),
    cardId: json['cardId'],
    userId: json['userId']?.toString(),
    userName: json['userName'],
    borrowDate: json['borrowDate'],
    dueDate: json['dueDate'],
    borrowDetails: json['borrowDetails'] != null
        ? List<BorrowDetail>.from(json['borrowDetails'].map((x) => BorrowDetail.fromJson(x)))
        : null,
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'cardId': cardId,
    'userId': userId,
    'userName': userName,
    'borrowDate': borrowDate,
    'dueDate': dueDate,
    'borrowDetails': borrowDetails?.map((x) => x.toJson()).toList(),
    'status': status,
  };
}

class BorrowDetail {
  String? bookId;
  String? bookName;
  double? bookPrice;
  int? quantity;

  BorrowDetail({this.bookId, this.bookName, this.bookPrice, this.quantity});

  factory BorrowDetail.fromJson(Map<String, dynamic> json) => BorrowDetail(
    bookId: json['bookId']?.toString(),
    bookName: json['bookName'],
    bookPrice: (json['bookPrice'] as num?)?.toDouble(),
    quantity: json['quantity'],
  );

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'bookName': bookName,
    'bookPrice': bookPrice,
    'quantity': quantity,
  };
}