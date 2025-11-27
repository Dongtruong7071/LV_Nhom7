import '../../domain/entities/order_item.dart';
import '../../domain/repositories/order_item_repository.dart';
import '../datasources/remote/order_item_remote_data_source.dart';

class OrderItemRepositoryImpl implements OrderItemRepository {
  final OrderItemRemoteDataSource remoteDataSource;

  OrderItemRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrderItem>> getOrderItems(int orderId) {
    return remoteDataSource.getOrderItems(orderId);
  }
}

