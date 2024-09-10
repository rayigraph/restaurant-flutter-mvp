class Order {
  final String uid;
  final String orderDate;
  final String status;

  Order({
    required this.uid,
    required this.orderDate,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      uid: json['uid'],
      orderDate: json['order_date'],
      status: json['status'],
    );
  }
}