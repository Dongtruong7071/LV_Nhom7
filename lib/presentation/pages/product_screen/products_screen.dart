import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/colors.dart';
import 'package:ungdungbanmypham/presentation/controllers/product_controller.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/product_card.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../domain/entities/product.dart';

class ProductsScreen extends StatelessWidget {
  final String? searchText;
  final int? brandId;
  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final String? title;

  const ProductsScreen({
    super.key,
    this.searchText,
    this.brandId,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.title,
  });

  List<Product> _filterProducts(ProductController controller) {
    final all = controller.allProducts;

    return all.where((p) {
      if (searchText != null && searchText!.trim().isNotEmpty) {
        final q = searchText!.toLowerCase();
        if (!p.name.toLowerCase().contains(q)) {
          return false;
        }
      }

      if (brandId != null && p.brandId != brandId) {
        return false;
      }

      if (categoryId != null && p.categoryId != categoryId) {
        return false;
      }

     
      if (minPrice != null || maxPrice != null) {
        if (p.variants.isEmpty) return false;

        final prices = p.variants.map((v) => v.price).toList();
        final productMinPrice =
            prices.reduce((value, element) => value < element ? value : element);

        if (minPrice != null && productMinPrice < minPrice!) return false;
        if (maxPrice != null && productMinPrice > maxPrice!) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    ProductController productController;
    try {
      productController = Get.find<ProductController>();
    } catch (_) {
      final c = Get.put(ProductController());
      productController = c;
    }

    final products = _filterProducts(productController);

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: redColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: products.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  10.heightBox,
                  "Không tìm thấy sản phẩm phù hợp".text.gray500.make(),
                ],
              ).centered()
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    10.heightBox,
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        mainAxisExtent: 280,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    ),
                    20.heightBox,
                  ],
                ),
              ),
      ),
    );
  }
}


