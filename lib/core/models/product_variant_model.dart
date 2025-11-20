class ProductVariant {
  final int id;
  final int productId;
  final String? name; // "50ml", "Màu 01"
  final double price;
  final int stock;
  final String? imageUrl;

  ProductVariant({
    required this.id,
    required this.productId,
    this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['id'],
      productId: json['product_id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'price': price,
      'stock': stock,
      'image_url': imageUrl,
    };
  }
}