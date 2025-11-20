import 'package:dio/dio.dart';
import '../models/category_model.dart';
import 'dio_client.dart';

class CategoryApi {
  final Dio _dio = DioClient.dio;

  // ---------- Tạo category ----------
  Future<Category> createCategory(Map<String, dynamic> data) async {
    final response = await _dio.post("/categories", data: data);
    return Category.fromJson(response.data);
  }

  // ---------- Lấy danh sách ----------
  Future<List<Category>> getCategories() async {
    final response = await _dio.get("/categories");
    return (response.data as List)
        .map((c) => Category.fromJson(c))
        .toList();
  }

  // ---------- Lấy chi tiết ----------
  Future<Category> getCategoryDetail(int categoryId) async {
    final response = await _dio.get("/categories/$categoryId");
    return Category.fromJson(response.data);
  }

  // ---------- Cập nhật ----------
  Future<Category> updateCategory(int categoryId, Map<String, dynamic> data) async {
    final response = await _dio.put(
      "/categories/$categoryId",
      data: data,
    );

    return Category.fromJson(response.data);
  }

  // ---------- Xóa ----------
  Future<bool> deleteCategory(int categoryId) async {
    final response = await _dio.delete("/categories/$categoryId");
    return response.statusCode == 200;
  }
}
