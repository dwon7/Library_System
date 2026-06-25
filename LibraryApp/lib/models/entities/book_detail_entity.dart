import '../ressponses/book_detail_res.dart';

class BookDetailEntity {
  final String? bookId;
  final String? title;
  final String? categoryId;
  final String? documentType;
  final int totalQuantity;
  final String? fileFormat;
  final double bookPrice;

  BookDetailEntity({
    this.bookId,
    this.title,
    this.categoryId,
    this.documentType,
    required this.totalQuantity,
    this.fileFormat,
    this.bookPrice = 0,
  });

  factory BookDetailEntity.fromModel(BookDetailRes model) {
    return BookDetailEntity(
      bookId: model.bookId,
      title: model.title,
      categoryId: model.categoryId,
      documentType: model.documentType,
      totalQuantity: model.physicalInfo?.totalQuantity ?? 0,
      fileFormat: model.digitalInfo?.fileFormat,
      bookPrice: (model.physicalInfo?.totalQuantity ?? 0) * 50000.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'title': title,
      'categoryId': categoryId,
      'documentType': documentType,
      'totalQuantity': totalQuantity,
      'fileFormat': fileFormat,
      'bookPrice': bookPrice,
    };
  }
}
