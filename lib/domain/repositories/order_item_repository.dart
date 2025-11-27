import '../entities/order_item.dart';

abstract class OrderItemRepository {

  Future<List<OrderItem>> getOrderItems(int orderId);
}

