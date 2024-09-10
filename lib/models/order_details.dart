class OrderDetails {
  final String uid;
  final String totalPrice;
  final String OrderDate;

  OrderDetails({
    required this.uid,
    required this.totalPrice,
    required this.OrderDate,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    return OrderDetails(
      uid: json['uid'],
      totalPrice: json['total_price'],
      OrderDate: json['order_date'],
    );
  }
}