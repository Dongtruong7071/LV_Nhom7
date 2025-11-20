import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/consts/consts.dart';
import 'package:ungdungbanmypham/controller/brand_controller.dart';
import 'package:ungdungbanmypham/controller/category_controller.dart';
import 'package:ungdungbanmypham/widget_common/our_button.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final brandController = Get.put(BrandController());

    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
        child: Column(
          children: [

            10.heightBox,
                      brand
                          .text
                          .fontFamily(bold)
                          .size(18)
                          .color(darkFontGrey)
                          .makeCentered(),
                      15.heightBox,
            Expanded(
              child: Obx(() {
                if (brandController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                if (brandController.error.value != null) {
                  return "Không tải được thương hiệu"
                      .text
                      .color(redColor)
                      .makeCentered();
                }

                if (brandController.brands.isEmpty) {
                  return "Không có thương hiệu"
                      .text
                      .gray500
                      .makeCentered();
                }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: brandController.brands.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 130,
                        ),
                        itemBuilder: (context, index) {
                          final cat = brandController.brands[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  .size(13)
                                  .color(darkFontGrey)
                                  .align(TextAlign.center)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .roundedSM
                              .padding(const EdgeInsets.all(8))
                              .make();
                        },
                      ),

                      20.heightBox,
                    ],
                  ),
                );
              }),
            ),
            
            10.heightBox,
                      category
                          .text
                          .fontFamily(bold)
                          .size(18)
                          .color(darkFontGrey)
                          .makeCentered(),
                      15.heightBox,
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: redColor),
                  );
                }

                if (categoryController.error.value != null) {
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
                                  () => categoryController.fetchCategories(),
                                  redColor,
                                  whiteColor,
                                  "Thử lại",
                                ),
                              ],
                            ),
                          );
                        }

                if (categoryController.categories.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 80,
                                color: Colors.grey,
                              ),
                              10.heightBox,
                              "Chưa có danh mục".text.gray500.make(),
                            ],
                          ).centered();
                        }

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: categoryController.categories.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 130,
                        ),
                        itemBuilder: (context, index) {
                          final cat = categoryController.categories[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                  .size(13)
                                  .color(darkFontGrey)
                                  .align(TextAlign.center)
                                  .make(),
                            ],
                          )
                              .box
                              .white
                              .roundedSM
                              .padding(const EdgeInsets.all(8))
                              .make();
                        },
                      ),

                      20.heightBox,
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
