class Supplier {
  final String uid;
  final String supplierName;
  final String supplierImage;

  Supplier({
    required this.uid,
    required this.supplierName,
    required this.supplierImage,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      uid: json['uid'],
      supplierName: json['supplier_name'],
      supplierImage: json['supplier_image'],
    );
  }
}