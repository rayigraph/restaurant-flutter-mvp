class Item {
  final String itemId;
  final String itemName;
  final String itemImage;
  final String itemPrice;
  final String itemSupplier;

  Item({
    required this.itemId,
    required this.itemName,
    required this.itemImage,
    required this.itemPrice,
    required this.itemSupplier,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      itemId: json['uid'],
      itemName: json['item_name'],
      itemImage: json['item_image'],
      itemPrice: json['unit_price'],
      itemSupplier: json['supplier_id'],
    );
  }
}