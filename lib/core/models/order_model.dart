import 'order_item_model.dart';

class Order {
  final int id;
  final int userId;
  final double totalAmount;
  final String status;
  final String shippingAddress;
  final DateTime? createdAt;
  final List<OrderItem>? items;

  Order({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    this.createdAt,
    this.items,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: double.parse(json['total_amount'].toString()),
      status: json['status'],
      shippingAddress: json['shipping_address'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      items: (json['items'] as List?)?.map((i) => OrderItem.fromJson(i)).toList(),
    );
  }
}
