import 'order_item.dart';

class Order {
  final int id;
  final int userId;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final List<OrderItem> items;

  Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    required this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List<dynamic>?;
    List<OrderItem> items = itemsList?.map((i) => OrderItem.fromJson(i)).toList() ?? [];

    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      shippingAddress: json['shipping_address'],
      items: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'shipping_address': shippingAddress,
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}
