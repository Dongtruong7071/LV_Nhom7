import 'package:dio/dio.dart';
import 'package:ungdungbanmypham/core/api/dio_client.dart';
import 'package:ungdungbanmypham/domain/entities/product_variant.dart';

class ProductVariantRemoteDataSource {
  final Dio _dio = DioClient.dio;

 

  Future<List<ProductVariant>> getVariants({
    int? productId,
    int skip = 0,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      "/variants",
      queryParameters: {
        if (productId != null) "product_id": productId,
        "skip": skip,
        "limit": limit,
      },
    );

    return (response.data as List).map((v) => ProductVariant.fromJson(v)).toList();
  }

  Future<ProductVariant> getVariantDetail(int variantId) async {
    final response = await _dio.get("/variants/$variantId");
    return ProductVariant.fromJson(response.data);
  }

  Future<ProductVariant> updateVariant(
    int variantId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dio.put("/variants/$variantId", data: data);
    return ProductVariant.fromJson(response.data);
  }


}

