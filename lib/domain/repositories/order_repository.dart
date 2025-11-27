import '../entities/order.dart';

abstract class OrderRepository {
  Future<List<Order>> getOrders({
    int skip = 0,
    int limit = 100,
    String? status,
    required String authToken,
  });

  Future<Order> getOrderDetail(int id, {required String authToken});

  Future<Order> createOrder(
    Map<String, dynamic> body, {
    required String authToken,
  });

  Future<Order> updateOrder(
    int id,
    Map<String, dynamic> body, {
    required String authToken,
  });
}

