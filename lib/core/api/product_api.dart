import 'package:dio/dio.dart';
import '../models/product_model.dart';
import 'dio_client.dart';

class ProductApi {
  final Dio _dio = DioClient.dio;


  Future<Product> createProduct(Map<String, dynamic> data) async {
    final response = await _dio.post("/products", data: data);
    return Product.fromJson(response.data);
  }


  Future<List<Product>> getProducts({
    int skip = 0,
    int limit = 20,
    String? search,
    int? brandId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) async {
    final response = await _dio.get(
      "/products",
      queryParameters: {
        "skip": skip,
        "limit": limit,
        if (search != null) "search": search,
        if (brandId != null) "brand_id": brandId,
        if (categoryId != null) "category_id": categoryId,
        if (minPrice != null) "min_price": minPrice,
        if (maxPrice != null) "max_price": maxPrice,
        if (inStock != null) "in_stock": inStock,
      },
    );

    return (response.data as List)
        .map((p) => Product.fromJson(p))
        .toList();
  }


  Future<Product> getProductDetail(int productId) async {
    final response = await _dio.get("/products/$productId");
    return Product.fromJson(response.data);
  }


  Future<Product> updateProduct(
      int productId, Map<String, dynamic> data) async {
    final response = await _dio.put(
      "/products/$productId",
      data: data,
    );

    return Product.fromJson(response.data);
  }


  Future<bool> deleteProduct(int productId) async {
    final response = await _dio.delete("/products/$productId");
    return response.statusCode == 200;
  }
}
