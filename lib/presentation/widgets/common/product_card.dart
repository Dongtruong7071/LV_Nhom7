import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/domain/entities/product.dart';
import 'package:ungdungbanmypham/presentation/pages/product_screen/product_detail_screen.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/our_button.dart';
import 'package:velocity_x/velocity_x.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final hasVariant = product.variants.isNotEmpty;

    final double? minPrice = hasVariant
        ? product.variants.map((v) => v.price).reduce((a, b) => a < b ? a : b)
        : null;

    final priceText = minPrice != null ? "${minPrice.toInt()}đ" : "Liên hệ";
    final bool inStock = hasVariant && product.variants.any((v) => v.stock > 0);

    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                ? Image.network(
                    product.imageUrl!,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      imgP2,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Image.asset(
                    imgP2,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: semibold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  4.heightBox,

                  // Giá
                  Text(
                    priceText,
                    style: const TextStyle(
                      color: redColor,
                      fontFamily: bold,
                      fontSize: 16,
                    ),
                  ),

                  4.heightBox,

                  // Trạng thái tồn kho
                  Row(
                    children: [
                      Icon(
                        Icons.inventory,
                        size: 14,
                        color: inStock ? Colors.green : Colors.red,
                      ),
                      4.widthBox,
                      Text(
                        inStock ? 'Còn hàng' : 'Hết hàng',
                        style: TextStyle(
                          fontSize: 12,
                          color: inStock ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Nút xem chi tiết
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
            child: SizedBox(
              width: double.infinity,
              child: ourButton(
                () {
                  Get.to(() => ProductDetailScreen(product: product));
                },
                redColor,
                whiteColor,
                "Xem chi tiết",
              ),
            ),
          ),
        ],
      ),
    ).onTap(() {
      Get.to(() => ProductDetailScreen(product: product));
    });
  }
}
