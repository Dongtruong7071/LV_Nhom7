import 'package:dio/dio.dart';
import '../models/product_model.dart';
import 'dio_client.dart';
import 'endpoints.dart';

class ProductApiService {
  final Dio _dio;

  ProductApiService() : _dio = DioClient().dio;

  // GET: Lấy danh sách sản phẩm
  Future<List<Product>> getProducts({
    int skip = 0,
    int limit = 20,
    String? search,
    int? brandId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final response = await _dio.get('http://127.0.0.1:8000/products/', queryParameters: {
        'skip': skip,
        'limit': limit,
        if (search != null) 'search': search,
        if (brandId != null) 'brand_id': brandId,
        if (categoryId != null) 'category_id': categoryId,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
      });

      final List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // GET: Lấy 1 sản phẩm
  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productById(id));
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST: Tạo sản phẩm (admin)
  Future<Product> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _dio.post(ApiEndpoints.products, data: productData);
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT: Cập nhật sản phẩm (admin)
  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final response = await _dio.put(ApiEndpoints.productById(id), data: productData);
      return Product.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE: Xóa sản phẩm (admin)
  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete(ApiEndpoints.productById(id));
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data['detail'] ?? 'Lỗi không xác định';
    }
    return e.message ?? 'Lỗi kết nối';
  }
}