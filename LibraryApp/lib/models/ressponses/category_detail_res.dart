

// lib/data/models/category_model.dart

class CategoryDetailRes {
  String? categoryId;
  String? categoryName;
  String? description;
  String? storageLocation;

  CategoryDetailRes({
    this.categoryId,
    this.categoryName,
    this.description,
    this.storageLocation,
  });

  factory CategoryDetailRes.fromJson(Map<String, dynamic> json) => CategoryDetailRes(
    categoryId: json['categoryId'],
    categoryName: json['categoryName'],
    description: json['description'],
    storageLocation: json['storageLocation'],
  );

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'description': description,
    'storageLocation': storageLocation,
  };
}