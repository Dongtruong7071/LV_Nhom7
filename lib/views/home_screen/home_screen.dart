import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/consts/consts.dart';
import 'package:ungdungbanmypham/controller/category_controller.dart';
import 'package:ungdungbanmypham/controller/product_controller.dart';
import 'package:ungdungbanmypham/widget_common/our_button.dart';
import 'package:ungdungbanmypham/widget_common/product_card.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    final productController = Get.put(ProductController());
    final categoryController = Get.put(CategoryController());


    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(child: Column(
        children: [
              // === SEARCH BAR + CART ===
              Container(
                padding: const EdgeInsets.all(12),
                color: redColor,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          // Tìm kiếm realtime
                          productController.searchProducts(value);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: whiteColor,
                          hintText: searchAnything,
                          hintStyle: const TextStyle(
                            fontFamily: regular,
                            color: textfieldGrey,
                          ),
                          prefixIcon: const Icon(Icons.search, color: redColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    10.widthBox,
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: whiteColor,
                      ),
                      onPressed: () {
                        // Get.to(() => CartScreen());
                      },
                    ),
                  ],
                ),
              ),

              // === NỘI DUNG CUỘN ===
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      10.heightBox,

                      // === SWIPER BANNER ===
                      // VxSwiper.builder(
                      //   aspectRatio: 16 / 7,
                      //   autoPlay: true,
                      //   height: 180,
                      //   enlargeCenterPage: true,
                      //   itemCount: sliderlists.length,
                      //   itemBuilder: (context, index) {
                      //     return Image.asset(
                      //           sliderlists[index],
                      //           fit: BoxFit.cover,
                      //         ).box.rounded
                      //         .clip(Clip.antiAlias)
                      //         .margin(const EdgeInsets.symmetric(horizontal: 8))
                      //         .make();
                      //   },
                      // ),

                      20.heightBox,

                      // === DANH MỤC NỔI BẬT ===
"Danh mục nổi bật".text
    .fontFamily(bold)
    .size(18)
    .color(darkFontGrey)
    .makeCentered(),
10.heightBox,

Obx(() {
  if (categoryController.isLoading.value) {
    return const Center(
      child: CircularProgressIndicator(color: redColor),
    );
  }

  if (categoryController.error.value != null) {
    return "Không tải được danh mục"
        .text
        .color(redColor)
        .makeCentered();
  }

  if (categoryController.categories.isEmpty) {
    return "Không có danh mục"
        .text
        .gray500
        .makeCentered();
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: categoryController.categories.map((cat) {
        return Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: lightGrey,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.category, color: redColor),
            ),
            8.heightBox,
            cat.name.text
                .size(12)
                .color(darkFontGrey)
                .align(TextAlign.center)
                .make(),
          ],
        )
            .box
            .white
            .roundedSM
            .padding(const EdgeInsets.all(8))
            .margin(const EdgeInsets.symmetric(horizontal: 4))
            .make();
      }).toList(),
    ),
  );
}),


                      20.heightBox,

                      // === FLASH SALE ===
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: redColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            "FLASH SALE".text.white
                                .fontFamily(bold)
                                .size(16)
                                .make(),
                            const Spacer(),
                            "Xem tất cả".text.white.make(),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: whiteColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ).onTap(() {
                        // Get.to(() => FlashSaleScreen());
                      }),

                      15.heightBox,

                      // === TẤT CẢ SẢN PHẨM ===
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          "Tất cả sản phẩm".text
                              .fontFamily(bold)
                              .size(18)
                              .color(darkFontGrey)
                              .make(),
                          TextButton(
                            onPressed: () {
                              productController.fetchProducts();
                            },
                            child: "Làm mới".text.color(redColor).make(),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 16),

                      10.heightBox,

                      // === DANH SÁCH SẢN PHẨM ===
                      Obx(() {
                        if (productController.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(color: redColor),
                          );
                        }

                        if (productController.error.value != null) {
                          return Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 48,
                                  color: redColor,
                                ),
                                10.heightBox,
                                "Không tải được dữ liệu".text.red500.make(),
                                10.heightBox,
                                ourButton(
                                  () => productController.fetchProducts(),
                                  redColor,
                                  whiteColor,
                                  "Thử lại",
                                ),
                              ],
                            ),
                          );
                        }

                        if (productController.products.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              10.heightBox,
                              "Chưa có sản phẩm".text.gray500.make(),
                            ],
                          ).centered();
                        }

                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productController.products.length,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                mainAxisExtent: 280,
                              ),
                          itemBuilder: (context, index) {
                            final product = productController.products[index];
                            return ProductCard(product: product);
                          },
                        );
                      }),

                      30.heightBox,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
