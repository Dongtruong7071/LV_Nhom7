import 'package:get/get.dart';

import '../../domain/entities/product.dart';
import '../../domain/entities/product_variant.dart';

class CartItem {
  final Product product;
  final ProductVariant? variant;
  int quantity;

  CartItem({
    required this.product,
    this.variant,
    this.quantity = 1,
  });

  double get unitPrice {
    if (variant != null) return variant!.price;
    if (product.variants.isNotEmpty) {
      return product.variants.first.price;
    }
    return 0;
  }

  double get totalPrice => unitPrice * quantity;
}

class CartController extends GetxController {
  var items = <CartItem>[].obs;

  void addProduct(Product product,
      {ProductVariant? variant, int quantity = 1}) {
    final index = items.indexWhere((item) =>
        item.product.id == product.id && item.variant?.id == variant?.id);

    if (index == -1) {
      items.add(CartItem(product: product, variant: variant, quantity: quantity));
    } else {
      items[index].quantity += quantity;
      items.refresh();
    }

    Get.snackbar("Giỏ hàng", "Đã thêm sản phẩm vào giỏ");
  }

  void removeItem(CartItem item) {
    items.remove(item);
  }

  void increaseQuantity(CartItem item) {
    item.quantity += 1;
    items.refresh();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity == 1) {
      removeItem(item);
    } else {
      item.quantity -= 1;
      items.refresh();
    }
  }

  double get total {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void clearCart() {
    items.clear();
  }
}


