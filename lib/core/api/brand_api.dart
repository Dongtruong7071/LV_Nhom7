import 'package:dio/dio.dart';
import '../models/brand_model.dart';
import 'dio_client.dart';

class BrandApi {
  final Dio _dio = DioClient.dio;

  // ---------- Tạo brand ----------
  Future<Brand> createBrand(Map<String, dynamic> data) async {
    final response = await _dio.post("/brands", data: data);
    return Brand.fromJson(response.data);
  }

  // ---------- Lấy danh sách ----------
  Future<List<Brand>> getBrands() async {
    final response = await _dio.get("/brands");
    return (response.data as List)
        .map((b) => Brand.fromJson(b))
        .toList();
  }

  // ---------- Lấy chi tiết ----------
  Future<Brand> getBrandDetail(int brandId) async {
    final response = await _dio.get("/brands/$brandId");
    return Brand.fromJson(response.data);
  }

  // ---------- Cập nhật ----------
  Future<Brand> updateBrand(int brandId, Map<String, dynamic> data) async {
    final response = await _dio.put(
      "/brands/$brandId",
      data: data,
    );

    return Brand.fromJson(response.data);
  }

  // ---------- Xóa ----------
  Future<bool> deleteBrand(int brandId) async {
    final response = await _dio.delete("/brands/$brandId");
    return response.statusCode == 200;
  }
}
