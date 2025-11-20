import 'brand_model.dart';
import 'category_model.dart';
import 'product_variant_model.dart';

class Product {
  final int id;
  final String name;
  final String? imageUrl;
  final String? ingredients;
  final String? usageInstructions;
  final String? instructions;
  final String? origin;
  final int? brandId;
  final int? categoryId;
  final Brand? brand;
  final Category? category;
  final List<ProductVariant> variants;

  Product({
    required this.id,
    required this.name,
    this.imageUrl,
    this.ingredients,
    this.usageInstructions,
    this.instructions,
    this.origin,
    this.brandId,
    this.categoryId,
    this.brand,
    this.category,
    required this.variants,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    var variantList = json['variants'] as List<dynamic>?;
    List<ProductVariant> variants = variantList
        ?.map((v) => ProductVariant.fromJson(v))
        .toList() ?? [];

    return Product(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      ingredients: json['ingredients'],
      usageInstructions: json['usage_instructions'],
      instructions: json['instructions'],
      origin: json['origin'],
      brandId: json['brand_id'],
      categoryId: json['category_id'],
      brand: json['brand'] != null ? Brand.fromJson(json['brand']) : null,
      category: json['category'] != null ? Category.fromJson(json['category']) : null,
      variants: variants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'ingredients': ingredients,
      'usage_instructions': usageInstructions,
      'instructions': instructions,
      'origin': origin,
      'brand_id': brandId,
      'category_id': categoryId,
      'brand': brand?.toJson(),
      'category': category?.toJson(),
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }
}
