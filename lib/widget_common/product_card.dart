import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/consts/consts.dart';
import 'package:ungdungbanmypham/core/models/product_model.dart';
import 'package:ungdungbanmypham/widget_common/our_button.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Hình ảnh
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: product.imageUrl != null
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

          8.heightBox,

          // Tên + giá
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                product.name.text.fontFamily(semibold).size(14).maxLines(2).ellipsis.make(),
                4.heightBox,
                "${product.price.toStringAsFixed(0)}đ".text.color(redColor).fontFamily(bold).size(16).make(),
              ],
            ),
          ),

          const Spacer(),

          // Nút thêm vào giỏ
          SizedBox(
            width: double.infinity,
            child: ourButton(
              () {
                // Get.to(() => ProductDetailScreen(product: product));
              },
              redColor,
              whiteColor,
              "Xem chi tiết",
            ).marginSymmetric(horizontal: 8, vertical: 8),
          ),
        ],
      ),
    ).onTap(() {
      // Get.to(() => ProductDetailScreen(product: product));
    });
  }
}