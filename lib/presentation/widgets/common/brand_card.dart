// presentation/widgets/brand/brand_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/domain/entities/brand.dart';
import 'package:ungdungbanmypham/presentation/pages/product_screen/products_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class BrandCard extends StatelessWidget {
  final Brand brand;

  const BrandCard({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: lightGrey,
            borderRadius: BorderRadius.circular(40),
          ),
          child: ClipOval(
            child: (brand.logoUrl != null && brand.logoUrl!.isNotEmpty)
                ? Image.network(
                    brand.logoUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          color: redColor,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.business,
                      color: redColor,
                      size: 40,
                    ),
                  )
                : const Icon(
                    Icons.business,
                    color: redColor,
                    size: 40,
                  ),
          ),
        ),
        10.heightBox,
        Text(
          brand.name,
          style: const TextStyle(
            fontFamily: semibold,
            fontSize: 13,
            color: darkFontGrey,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    )
        .box
        .white
        .roundedSM
        .padding(const EdgeInsets.all(12))
        .make()
        .onTap(() {
      Get.to(() => ProductsScreen(
            brandId: brand.id,
            title: "Thương hiệu: ${brand.name}",
          ));
    });
  }
}