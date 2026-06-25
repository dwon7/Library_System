

// lib/data/models/category_model.dart

class CategoryDetailRes {
  String? id;
  String? categoryId;
  String? categoryName;
  String? description;
  String? storageLocation;

  CategoryDetailRes({
    this.id,
    this.categoryId,
    this.categoryName,
    this.description,
    this.storageLocation,
  });

  factory CategoryDetailRes.fromJson(Map<String, dynamic> json) => CategoryDetailRes(
    id: json['_id']?.toString(),
    categoryId: json['categoryId'],
    categoryName: json['categoryName'],
    description: json['description'],
    storageLocation: json['storageLocation'],
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'description': description,
    'storageLocation': storageLocation,
  };
}