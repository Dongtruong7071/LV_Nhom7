// presentation/widgets/category/category_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/domain/entities/category.dart' as cat_entity;
import 'package:ungdungbanmypham/presentation/pages/product_screen/products_screen.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryCard extends StatelessWidget {
  final cat_entity.Category category;

  const CategoryCard({super.key, required this.category});

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
            child: const Icon(Icons.category, color: redColor, size: 40),
            // child: (category.imageUrl != null && category.imageUrl!.isNotEmpty)
            //     ? Image.network(
            //         category.imageUrl!,
            //         width: 80,
            //         height: 80,
            //         fit: BoxFit.cover,
            //         errorBuilder: (_, __, ___) => const Icon(Icons.category, color: redColor, size: 40),
            //       )
            //     : const Icon(Icons.category, color: redColor, size: 40),
          ),
        ),
        10.heightBox,
        Text(
          category.name,
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
    ).box.white.roundedSM.padding(const EdgeInsets.all(12)).make().onTap(() {
      Get.to(
        () => ProductsScreen(
          categoryId: category.id,
          title: "Danh mục: ${category.name}",
        ),
      );
    });
  }
}
