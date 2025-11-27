import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/core/consts/strings.dart';
import 'package:ungdungbanmypham/presentation/controllers/brand_controller.dart';
import 'package:ungdungbanmypham/presentation/controllers/category_controller.dart';
import 'package:ungdungbanmypham/presentation/pages/product_screen/products_screen.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/brand_card.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/category_card.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/our_button.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../domain/entities/brand.dart';
import '../../../domain/entities/category.dart' as cat_entity;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _searchController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  Brand? _selectedBrand;
  cat_entity.Category? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  void _onSearchPressed() {
    double? minPrice;
    double? maxPrice;

    if (_minPriceController.text.trim().isNotEmpty) {
      minPrice = double.tryParse(_minPriceController.text.trim());
    }
    if (_maxPriceController.text.trim().isNotEmpty) {
      maxPrice = double.tryParse(_maxPriceController.text.trim());
    }

    Get.to(
      () => ProductsScreen(
        searchText: _searchController.text.trim().isEmpty
            ? null
            : _searchController.text.trim(),
        brandId: _selectedBrand?.id,
        categoryId: _selectedCategory?.id,
        minPrice: minPrice,
        maxPrice: maxPrice,
        title: "Kết quả tìm kiếm",
      ),
    );
  }

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
            Container(
              padding: const EdgeInsets.all(12),
              color: redColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: whiteColor,
                            hintText: searchAnything,
                            hintStyle: const TextStyle(
                              fontFamily: regular,
                              color: textfieldGrey,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: redColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      10.widthBox,
                      ourButton(_onSearchPressed, whiteColor, redColor, "Lọc"),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _minPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: whiteColor,
                            hintText: "Giá min",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      10.widthBox,
                      Expanded(
                        child: TextFormField(
                          controller: _maxPriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: whiteColor,
                            hintText: "Giá max",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.heightBox,
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final brands = brandController.brands;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<Brand>(
                              value: _selectedBrand,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              hint: const Text("Chọn thương hiệu"),
                              items: brands
                                  .map(
                                    (b) => DropdownMenuItem<Brand>(
                                      value: b,
                                      child: Text(b.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedBrand = value;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                      10.widthBox,
                      Expanded(
                        child: Obx(() {
                          final categories = categoryController.categories;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<cat_entity.Category>(
                              value: _selectedCategory,
                              isExpanded: true,
                              underline: const SizedBox.shrink(),
                              hint: const Text("Chọn danh mục"),
                              items: categories
                                  .map(
                                    (c) =>
                                        DropdownMenuItem<cat_entity.Category>(
                                          value: c,
                                          child: Text(c.name),
                                        ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            10.heightBox,
            brand.text
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
                  return "Không tải được thương hiệu".text
                      .color(redColor)
                      .makeCentered();
                }

                if (brandController.brands.isEmpty) {
                  return "Không có thương hiệu".text.gray500.makeCentered();
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
                              mainAxisExtent: 150,
                            ),
                        itemBuilder: (context, index) {
                          final b = brandController.brands[index];
                          return BrandCard(brand: b);
                        },
                      ),

                      20.heightBox,
                    ],
                  ),
                );
              }),
            ),

            10.heightBox,

            category.text
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
                        Icon(Icons.error_outline, size: 48, color: redColor),
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
                              mainAxisExtent: 150,
                            ),
                        itemBuilder: (context, index) {
                          final c = categoryController.categories[index];
                          return CategoryCard(category: c);
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
