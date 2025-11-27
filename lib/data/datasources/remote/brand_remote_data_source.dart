import 'package:dio/dio.dart';
import 'package:ungdungbanmypham/core/api/dio_client.dart';
import 'package:ungdungbanmypham/domain/entities/brand.dart';

class BrandRemoteDataSource {
  final Dio _dio = DioClient.dio;

  

  Future<List<Brand>> getBrands() async {
    final response = await _dio.get("/brands");
    return (response.data as List).map((b) => Brand.fromJson(b)).toList();
  }

  Future<Brand> getBrandDetail(int brandId) async {
    final response = await _dio.get("/brands/$brandId");
    return Brand.fromJson(response.data);
  }


}
