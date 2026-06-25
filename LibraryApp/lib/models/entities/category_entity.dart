


// lib/data/entities/category_entity.dart

import '../ressponses/category_detail_res.dart'; // Import lớp CategoryModel đã tạo trước đó

class CategoryEntity {
  final String? categoryId;
  final String? categoryName;

  CategoryEntity({
    this.categoryId,
    this.categoryName,
  });

  /// Hàm Factory Mapper: Chuyển đổi từ CategoryModel sang CategoryEntity
  factory CategoryEntity.fromModel(CategoryDetailRes model) {
    return CategoryEntity(
      categoryId: model.categoryId,
      categoryName: model.categoryName,
    );
  }

  /// Hàm chuyển đổi ngược lại Map nếu cần xử lý cục bộ
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
    };
  }
}