import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/domain/entities/order.dart';
import 'package:ungdungbanmypham/presentation/controllers/cart_controller.dart';
import 'package:ungdungbanmypham/presentation/controllers/order_controller.dart';
import 'package:ungdungbanmypham/presentation/controllers/user_controller.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/our_button.dart';
import 'package:velocity_x/velocity_x.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController(), permanent: true);
    final orderController = Get.put(OrderController(), permanent: true);
    final userController = Get.put(UserController(), permanent: true);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: lightGrey,
        body: SafeArea(
          child: Column(
            children: [
              "Giỏ hàng & đơn mua".text
                  .fontFamily(bold)
                  .size(18)
                  .color(darkFontGrey)
                  .makeCentered(),
              12.heightBox,
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const TabBar(
                  indicatorColor: redColor,
                  labelColor: redColor,
                  unselectedLabelColor: darkFontGrey,
                  labelStyle: TextStyle(fontFamily: semibold),
                  tabs: [
                    Tab(icon: Icon(Icons.shopping_cart), text: "Giỏ hàng"),
                    Tab(icon: Icon(Icons.receipt), text: "Đơn hàng"),
                  ],
                ),
              ),
              12.heightBox,
              Expanded(
                child: TabBarView(
                  children: [
                    _CartTab(
                      cartController: cartController,
                      userController: userController,
                      orderController: orderController,
                    ),
                    _OrdersTab(orderController: orderController),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartTab extends StatelessWidget {
  final CartController cartController;
  final UserController userController;
  final OrderController orderController;

  const _CartTab({
    required this.cartController,
    required this.userController,
    required this.orderController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (cartController.items.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 56,
              color: textfieldGrey,
            ),
            12.heightBox,
            "Giỏ hàng của bạn đang trống".text
                .color(textfieldGrey)
                .makeCentered(),
          ],
        );
      }

      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cartController.items.length,
              separatorBuilder: (_, __) => 10.heightBox,
              itemBuilder: (context, index) {
                final item = cartController.items[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: lightGrey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(imgP2, fit: BoxFit.cover),
                      ),
                      12.widthBox,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            item.product.name.text
                                .fontFamily(semibold)
                                .size(14)
                                .make(),
                            if (item.variant != null)
                              "Phiên bản: ${item.variant!.name ?? "#${item.variant!.id}"}"
                                  .text
                                  .size(12)
                                  .color(textfieldGrey)
                                  .make(),
                            8.heightBox,
                            "${item.unitPrice.toStringAsFixed(0)}đ".text
                                .color(redColor)
                                .fontFamily(bold)
                                .make(),
                            8.heightBox,
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      cartController.decreaseQuantity(item),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                '${item.quantity}'.text.fontFamily(bold).make(),
                                IconButton(
                                  onPressed: () =>
                                      cartController.increaseQuantity(item),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () =>
                                      cartController.removeItem(item),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: redColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Tạm tính".text
                        .fontFamily(semibold)
                        .color(textfieldGrey)
                        .make(),
                    "${cartController.total.toStringAsFixed(0)}đ".text
                        .fontFamily(bold)
                        .color(redColor)
                        .size(18)
                        .make(),
                  ],
                ),
                12.heightBox,
                Obx(() {
                  if (orderController.isCreating.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: redColor),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ourButton(
                      () => _showCheckoutSheet(
                        context,
                        cartController,
                        userController,
                        orderController,
                      ),
                      redColor,
                      whiteColor,
                      "Đặt hàng",
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      );
    });
  }

  void _showCheckoutSheet(
    BuildContext context,
    CartController cartController,
    UserController userController,
    OrderController orderController,
  ) {
    final savedAddress = userController.addressController.text.trim();
    final manualController = TextEditingController();

    AddressOption selectedOption = savedAddress.isNotEmpty
        ? AddressOption.saved
        : AddressOption.manual;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  "Chọn địa chỉ giao hàng".text
                      .fontFamily(bold)
                      .size(18)
                      .color(darkFontGrey)
                      .make(),
                  12.heightBox,
                  if (savedAddress.isNotEmpty)
                    RadioListTile<AddressOption>(
                      value: AddressOption.saved,
                      groupValue: selectedOption,
                      onChanged: (val) => setState(() {
                        selectedOption = val!;
                      }),
                      title: "Dùng địa chỉ đã lưu".text.make(),
                      subtitle: savedAddress.text.gray500.make(),
                    ),
                  RadioListTile<AddressOption>(
                    value: AddressOption.manual,
                    groupValue: selectedOption,
                    onChanged: (val) => setState(() {
                      selectedOption = val!;
                    }),
                    title: "Nhập địa chỉ mới".text.make(),
                  ),
                  if (selectedOption == AddressOption.manual)
                    TextField(
                      controller: manualController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Nhập địa chỉ giao hàng",
                        filled: true,
                        fillColor: lightGrey,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  20.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: ourButton(
                      () async {
                        final address = selectedOption == AddressOption.saved
                            ? savedAddress
                            : manualController.text.trim();

                        if (address.isEmpty) {
                          Get.snackbar("Thông báo", "Vui lòng nhập địa chỉ");
                          return;
                        }

                        Navigator.of(ctx).pop();
                        final order = await orderController.createOrder(
                          shippingAddress: address,
                          cartItems: cartController.items.toList(),
                        );
                        if (order != null) {
                          cartController.clearCart();
                          Get.snackbar(
                            "Thành công",
                            "Đã tạo đơn hàng #${order.id}",
                          );
                        }
                      },
                      redColor,
                      whiteColor,
                      "Xác nhận đặt hàng",
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

enum AddressOption { saved, manual }

class _OrdersTab extends StatelessWidget {
  final OrderController orderController;

  const _OrdersTab({required this.orderController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (orderController.isLoading.value) {
        return const Center(child: CircularProgressIndicator(color: redColor));
      }

      if (orderController.orders.isEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long, size: 56, color: textfieldGrey),
            12.heightBox,
            "Bạn chưa có đơn hàng nào".text.color(textfieldGrey).makeCentered(),
          ],
        );
      }

      return RefreshIndicator(
        color: redColor,
        onRefresh: () => orderController.fetchOrders(),
        child: ListView.separated(
          itemCount: orderController.orders.length,
          separatorBuilder: (_, __) => 10.heightBox,
          itemBuilder: (context, index) {
            final order = orderController.orders[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      "Đơn #${order.id}".text
                          .fontFamily(bold)
                          .size(16)
                          .color(darkFontGrey)
                          .make(),
                      _statusChip(order.status),
                    ],
                  ),
                  6.heightBox,
                  "Địa chỉ: ${order.shippingAddress}".text
                      .size(13)
                      .color(textfieldGrey)
                      .make(),
                  6.heightBox,
                  "Tổng: ${order.totalAmount.toStringAsFixed(0)}đ".text
                      .fontFamily(bold)
                      .color(redColor)
                      .make(),
                  12.heightBox,
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _showOrderDetail(context, order),
                        child: "Xem chi tiết".text.color(redColor).make(),
                      ),
                      const Spacer(),
                      Obx(() {
                        final isUpdating =
                            orderController.updatingOrderId.value == order.id;

                        // Only show payment button if order is pending
                        if (order.status == 'pending') {
                          return TextButton(
                            onPressed: isUpdating
                                ? null
                                : () => _showPaymentOptions(
                                    context,
                                    order,
                                    orderController,
                                  ),
                            child: isUpdating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: redColor,
                                    ),
                                  )
                                : "Thanh toán".text
                                      .color(redColor)
                                      .fontFamily(bold)
                                      .make(),
                          );
                        }

                        // For other statuses, maybe show nothing or just text
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _statusChip(String status) {
    Color bg = Colors.grey.shade200;
    Color text = darkFontGrey;

    switch (status) {
      case 'paid':
        bg = Colors.blue.shade50;
        text = Colors.blue;
        break;
      case 'shipped':
        bg = Colors.orange.shade50;
        text = Colors.orange;
        break;
      case 'delivered':
        bg = Colors.green.shade50;
        text = Colors.green;
        break;
      case 'cancelled':
        bg = Colors.red.shade50;
        text = Colors.red;
        break;
      default:
        bg = Colors.grey.shade200;
        text = darkFontGrey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: status.text.color(text).fontFamily(semibold).size(12).make(),
    );
  }

  void _showOrderDetail(BuildContext context, Order order) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Chi tiết đơn #${order.id}".text.fontFamily(bold).size(18).make(),
              12.heightBox,
              ...order.items.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: (item.product?.name ?? "Sản phẩm #${item.productId}")
                      .text
                      .fontFamily(semibold)
                      .make(),
                  subtitle:
                      "x${item.quantity} • ${item.price.toStringAsFixed(0)}đ"
                          .text
                          .color(textfieldGrey)
                          .make(),
                  trailing: (item.quantity * item.price)
                      .toStringAsFixed(0)
                      .text
                      .color(redColor)
                      .fontFamily(bold)
                      .make(),
                ),
              ),
              12.heightBox,
              "Tổng cộng: ${order.totalAmount.toStringAsFixed(0)}đ".text
                  .fontFamily(bold)
                  .color(redColor)
                  .make(),
            ],
          ),
        );
      },
    );
  }

  void _showPaymentOptions(
    BuildContext context,
    Order order,
    OrderController controller,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "Chọn phương thức thanh toán".text
                  .fontFamily(bold)
                  .size(18)
                  .make(),
              12.heightBox,
              ListTile(
                leading: const Icon(Icons.payment, color: redColor),
                title: "Thanh toán Online".text.fontFamily(semibold).make(),
                subtitle: "Thanh toán ngay qua thẻ/ví điện tử".text
                    .size(12)
                    .make(),
                onTap: () async {
                  Navigator.of(ctx).pop();
                  // Simulate online payment success -> update to paid
                  await controller.updateOrderStatus(order.id, 'paid');
                  Get.snackbar(
                    "Thành công",
                    "Thanh toán thành công đơn hàng #${order.id}",
                    backgroundColor: Colors.green,
                    colorText: whiteColor,
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.local_shipping, color: darkFontGrey),
                title: "Thanh toán khi nhận hàng (COD)".text
                    .fontFamily(semibold)
                    .make(),
                subtitle: "Thanh toán tiền mặt khi nhận hàng".text
                    .size(12)
                    .make(),
                onTap: () {
                  Navigator.of(ctx).pop();
                  Get.snackbar(
                    "Đã chọn COD",
                    "Vui lòng chuẩn bị tiền mặt khi nhận hàng",
                    backgroundColor: redColor,
                    colorText: whiteColor,
                  );
                },
              ),
              20.heightBox,
            ],
          ),
        );
      },
    );
  }
}
