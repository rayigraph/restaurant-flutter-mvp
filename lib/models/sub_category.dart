class SubCategory {
  final String uid;
  final String subCategoryName;
  final String subCategoryImage;

  SubCategory({
    required this.uid,
    required this.subCategoryName,
    required this.subCategoryImage,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      uid: json['uid'],
      subCategoryName: json['sub_category_name'],
      subCategoryImage: json['sub_category_image'],
    );
  }
}