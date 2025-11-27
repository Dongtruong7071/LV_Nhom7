import 'package:dio/dio.dart';
import 'package:ungdungbanmypham/core/api/dio_client.dart';
import 'package:ungdungbanmypham/domain/entities/order_item.dart';

class OrderItemRemoteDataSource {
  final Dio _dio = DioClient.dio;



  Future<List<OrderItem>> getOrderItems(int orderId) async {
    final response = await _dio.get("/order_items/$orderId");
    return (response.data as List).map((i) => OrderItem.fromJson(i)).toList();
  }
}

