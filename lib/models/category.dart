class Category {
  final String uid;
  final String categoryName;
  final String categoryImage;

  Category({
    required this.uid,
    required this.categoryName,
    required this.categoryImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      uid: json['uid'],
      categoryName: json['category_name'],
      categoryImage: json['category_image'],
    );
  }
}