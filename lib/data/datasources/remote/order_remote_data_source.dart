import 'package:dio/dio.dart';
import 'package:ungdungbanmypham/core/api/dio_client.dart';
import 'package:ungdungbanmypham/domain/entities/order.dart';

class OrderRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Options? _options(String? token) {
    if (token == null) return null;
    return Options(headers: {"Authorization": "Bearer $token"});
  }

  Future<Order> createOrder(
    Map<String, dynamic> data, {
    required String authToken,
  }) async {
    final response = await _dio.post(
      "/orders",
      data: data,
      options: _options(authToken),
    );
    return Order.fromJson(response.data);
  }

  Future<List<Order>> getOrders({
    int skip = 0,
    int limit = 100,
    String? status,
    required String authToken,
  }) async {
    final response = await _dio.get(
      "/orders",
      queryParameters: {
        "skip": skip,
        "limit": limit,
        if (status != null) "status": status,
      },
      options: _options(authToken),
    );

    return (response.data as List).map((o) => Order.fromJson(o)).toList();
  }

  Future<Order> getOrderDetail(int orderId, {required String authToken}) async {
    final response = await _dio.get(
      "/orders/$orderId",
      options: _options(authToken),
    );
    return Order.fromJson(response.data);
  }

  Future<Order> updateOrder(
    int orderId,
    Map<String, dynamic> data, {
    required String authToken,
  }) async {
    final response = await _dio.put(
      "/orders/$orderId",
      data: data,
      options: _options(authToken),
    );
    return Order.fromJson(response.data);
  }
}

