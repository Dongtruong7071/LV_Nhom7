import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/consts/consts.dart';
import 'package:ungdungbanmypham/consts/lists.dart';
import 'package:ungdungbanmypham/controller/product_controller.dart';
import 'package:ungdungbanmypham/widget_common/bg_widget.dart';
import 'package:ungdungbanmypham/widget_common/our_button.dart';
import 'package:ungdungbanmypham/widget_common/product_card.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Khởi tạo controller
    final productController = Get.put(ProductController());

    return bgWidget(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Header + Search
              Container(
                padding: const EdgeInsets.all(12),
                color: redColor,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
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
                      icon: const Icon(Icons.shopping_cart_outlined, color: whiteColor),
                      onPressed: () {
                        // Get.to(() => CartScreen());
                      },
                    ),
                  ],
                ),
              ),

              // Nội dung cuộn
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Swiper Banner
                      VxSwiper.builder(
                        aspectRatio: 16 / 7,
                        autoPlay: true,
                        height: 180,
                        enlargeCenterPage: true,
                        itemCount: sliderlists.length,
                        itemBuilder: (context, index) {
                          return Image.asset(
                            sliderlists[index],
                            fit: BoxFit.cover,
                          )
                              .box
                              .rounded
                              .clip(Clip.antiAlias)
                              .margin(const EdgeInsets.symmetric(horizontal: 8))
                              .make();
                        },
                      ),

                      20.heightBox,

                      // Danh mục nổi bật
                      10.heightBox,
                      "Danh mục nổi bật".text.fontFamily(bold).size(18).color(darkFontGrey).makeCentered(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            6,
                            (index) => Column(
                              children: [
                                // Image.asset(
                                //   categoryImages[index],
                                //   width: 60,
                                //   height: 60,
                                //   fit: BoxFit.cover,
                                // ).box.roundedFull.clip(Clip.antiAlias).make(),
                                60.heightBox,
                                60.widthBox,
                                8.heightBox,
                                categoryNames[index].text.size(12).color(darkFontGrey).make(),
                              ],
                            ).box.white.roundedSM.padding(const EdgeInsets.all(8)).margin(const EdgeInsets.symmetric(horizontal: 4)).make(),
                          ),
                        ),
                      ),

                      20.heightBox,

                      // Flash Sale
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
                            "FLASH SALE".text.white.fontFamily(bold).size(16).make(),
                            const Spacer(),
                            "Xem tất cả".text.white.make(),
                            const Icon(Icons.arrow_forward_ios, color: whiteColor, size: 16),
                          ],
                        ),
                      ),

                      15.heightBox,

                      // Tất cả sản phẩm
                      "Tất cả sản phẩm".text.fontFamily(bold).size(18).color(darkFontGrey).makeCentered(),
                      10.heightBox,

                      // Danh sách sản phẩm
                      Obx(() {
                        if (productController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator(color: redColor));
                        }

                        if (productController.error.value != null) {
                          return Center(
                            child: Column(
                              children: [
                                "Lỗi tải dữ liệu".text.red500.make(),
                                10.heightBox,
                                ourButton(() {
                                  productController.fetchProducts();
                                }, redColor, whiteColor, "Thử lại"),
                              ],
                            ),
                          );
                        }

                        if (productController.products.isEmpty) {
                          return "Không có sản phẩm".text.gray500.makeCentered();
                        }

                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: productController.products.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            mainAxisExtent: 260,
                          ),
                          itemBuilder: (context, index) {
                            final product = productController.products[index];
                            return ProductCard(product: product);
                          },
                        ).paddingSymmetric(horizontal: 12);
                      }),

                      20.heightBox,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}