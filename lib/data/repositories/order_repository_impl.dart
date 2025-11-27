import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Order> createOrder(
    Map<String, dynamic> body, {
    required String authToken,
  }) {
    return remoteDataSource.createOrder(body, authToken: authToken);
  }

  @override
  Future<Order> getOrderDetail(int id, {required String authToken}) {
    return remoteDataSource.getOrderDetail(id, authToken: authToken);
  }

  @override
  Future<List<Order>> getOrders({
    int skip = 0,
    int limit = 100,
    String? status,
    required String authToken,
  }) {
    return remoteDataSource.getOrders(
      skip: skip,
      limit: limit,
      status: status,
      authToken: authToken,
    );
  }

  @override
  Future<Order> updateOrder(
    int id,
    Map<String, dynamic> body, {
    required String authToken,
  }) {
    return remoteDataSource.updateOrder(
      id,
      body,
      authToken: authToken,
    );
  }
}

