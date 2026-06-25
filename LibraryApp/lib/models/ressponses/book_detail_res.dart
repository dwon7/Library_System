

class BookDetailRes {
  String? id;
  String? bookId;
  String? title;
  String? categoryId;
  int? publicationYear;
  String? publisher;
  List<Author>? authors;
  String? documentType; // "Physical" hoặc "Digital"
  PhysicalInfo? physicalInfo;
  DigitalInfo? digitalInfo;

  BookDetailRes({
    this.id,
    this.bookId,
    this.title,
    this.categoryId,
    this.publicationYear,
    this.publisher,
    this.authors,
    this.documentType,
    this.physicalInfo,
    this.digitalInfo,
  });

  factory BookDetailRes.fromJson(Map<String, dynamic> json) => BookDetailRes(
    id: json['_id']?.toString(),
    bookId: json['bookId'],
    title: json['title'],
    categoryId: json['categoryId']?.toString(),
    publicationYear: json['publicationYear'],
    publisher: json['publisher'],
    authors: json['authors'] != null
        ? List<Author>.from(json['authors'].map((x) => Author.fromJson(x)))
        : null,
    documentType: json['documentType'],
    physicalInfo: json['physicalInfo'] != null
        ? PhysicalInfo.fromJson(json['physicalInfo'])
        : null,
    digitalInfo: json['digitalInfo'] != null
        ? DigitalInfo.fromJson(json['digitalInfo'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    if (id != null) '_id': id,
    'bookId': bookId,
    'title': title,
    'categoryId': categoryId,
    'publicationYear': publicationYear,
    'publisher': publisher,
    'authors': authors?.map((x) => x.toJson()).toList(),
    'documentType': documentType,
    if (physicalInfo != null) 'physicalInfo': physicalInfo!.toJson(),
    if (digitalInfo != null) 'digitalInfo': digitalInfo!.toJson(),
  };
}

class Author {
  String? fullName;
  String? degree;

  Author({this.fullName, this.degree});

  factory Author.fromJson(Map<String, dynamic> json) => Author(
    fullName: json['fullName'],
    degree: json['degree'],
  );

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'degree': degree,
  };
}

class PhysicalInfo {
  String? warehouseLocation;
  String? shelfId;
  int? totalQuantity;

  PhysicalInfo({this.warehouseLocation, this.shelfId, this.totalQuantity});

  factory PhysicalInfo.fromJson(Map<String, dynamic> json) => PhysicalInfo(
    warehouseLocation: json['warehouseLocation'],
    shelfId: json['shelfId'],
    totalQuantity: json['totalQuantity'],
  );

  Map<String, dynamic> toJson() => {
    'warehouseLocation': warehouseLocation,
    'shelfId': shelfId,
    'totalQuantity': totalQuantity,
  };
}

class DigitalInfo {
  String? fileFormat;
  String? fileSizeMb;
  String? downloadUrl;
  int? downloadCount;

  DigitalInfo({this.fileFormat, this.fileSizeMb, this.downloadUrl, this.downloadCount});

  factory DigitalInfo.fromJson(Map<String, dynamic> json) => DigitalInfo(
    fileFormat: json['fileFormat'],
    fileSizeMb: json['fileSizeMb'],
    downloadUrl: json['downloadUrl'],
    downloadCount: json['downloadCount'],
  );

  Map<String, dynamic> toJson() => {
    'fileFormat': fileFormat,
    'fileSizeMb': fileSizeMb,
    'downloadUrl': downloadUrl,
    'downloadCount': downloadCount,
  };
}