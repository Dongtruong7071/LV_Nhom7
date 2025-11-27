import 'product.dart';
import 'product_variant.dart';

class OrderItem {
  final int id;
  final int orderId;
  final int productId;
  final int? variantId;
  final int quantity;
  final double price;
  final Product? product;
  final ProductVariant? variant;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    this.variantId,
    required this.quantity,
    required this.price,
    this.product,
    this.variant,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      variantId: json['variant_id'],
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      product: json['product'] != null ? Product.fromJson(json['product']) : null,
      variant: json['variant'] != null ? ProductVariant.fromJson(json['variant']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'product_id': productId,
      'variant_id': variantId,
      'quantity': quantity,
      'price': price,
      'product': product?.toJson(),
      'variant': variant?.toJson(),
    };
  }
}
