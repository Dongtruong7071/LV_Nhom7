import 'package:dio/dio.dart';
import 'package:ungdungbanmypham/core/api/dio_client.dart';
import 'package:ungdungbanmypham/domain/entities/category.dart';

class CategoryRemoteDataSource {
  final Dio _dio = DioClient.dio;



  Future<List<Category>> getCategories() async {
    final response = await _dio.get("/categories");
    return (response.data as List).map((c) => Category.fromJson(c)).toList();
  }

  Future<Category> getCategoryDetail(int categoryId) async {
    final response = await _dio.get("/categories/$categoryId");
    return Category.fromJson(response.data);
  }

 
}
