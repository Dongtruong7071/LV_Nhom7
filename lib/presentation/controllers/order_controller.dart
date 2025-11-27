import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../data/datasources/remote/order_remote_data_source.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  late final OrderRepository _repository;

  OrderController() {
    _repository = OrderRepositoryImpl(
      remoteDataSource: OrderRemoteDataSource(),
    );
  }

  var orders = <Order>[].obs;
  var isLoading = false.obs;
  var isCreating = false.obs;
  var error = Rx<String?>(null);
  var updatingOrderId = Rx<int?>(null);

  final statuses = const [
    'pending',
    'paid',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      error.value = null;

      final token = await _getToken();
      if (token == null) return;

      final data = await _repository.getOrders(authToken: token);
      data.sort((a, b) => b.id.compareTo(a.id));
      orders.assignAll(data);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Order?> createOrder({
    required String shippingAddress,
    required List<CartItem> cartItems,
  }) async {
    if (cartItems.isEmpty) return null;

    try {
      isCreating.value = true;
      final token = await _getToken();
      if (token == null) return null;

      final payload = {
        "total_amount": cartItems.fold<double>(
          0,
          (sum, item) => sum + item.totalPrice,
        ),
        "status": "pending",
        "shipping_address": shippingAddress,
        "items": cartItems
            .map(
              (item) => {
                "product_id": item.product.id,
                "variant_id": item.variant?.id,
                "quantity": item.quantity,
                "price": item.unitPrice,
              },
            )
            .toList(),
      };

      final order = await _repository.createOrder(payload, authToken: token);
      orders.insert(0, order);
      return order;
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tạo đơn hàng");
      return null;
    } finally {
      isCreating.value = false;
    }
  }

  Future<Order?> updateOrderStatus(int orderId, String status) async {
    try {
      updatingOrderId.value = orderId;
      final token = await _getToken();
      if (token == null) return null;

      final order = await _repository.updateOrder(orderId, {
        "status": status,
      }, authToken: token);

      final index = orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        orders[index] = order;
        orders.refresh();
      }
      return order;
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể cập nhật trạng thái");
      return null;
    } finally {
      updatingOrderId.value = null;
    }
  }

  Future<String?> _getToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar("Thông báo", "Vui lòng đăng nhập để tiếp tục");
      return null;
    }
    return user.getIdToken();
  }
}
