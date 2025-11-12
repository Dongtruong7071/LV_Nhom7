import 'brand_model.dart';
import 'category_model.dart';

class Product {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String? imageUrl;
  final String? ingredients;
  final String? usageInstructions;
  final String? instructions;
  final String? origin;
  final Brand? brand;
  final Category? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.ingredients,
    this.usageInstructions,
    this.instructions,
    this.origin,
    this.brand,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'],
      ingredients: json['ingredients'],
      usageInstructions: json['usage_instructions'],
      instructions: json['instructions'],
      origin: json['origin'],
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
    );
  }
}
