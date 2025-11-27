import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/consts/consts.dart';
import 'package:ungdungbanmypham/domain/entities/product.dart';
import 'package:ungdungbanmypham/domain/entities/product_variant.dart';
import 'package:ungdungbanmypham/presentation/controllers/cart_controller.dart';
import 'package:ungdungbanmypham/presentation/controllers/home_controller.dart';
import 'package:ungdungbanmypham/presentation/widgets/common/our_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedVariantIndex = 0;
  int _quantity = 1;
  late final CartController cartController;

  @override
  void initState() {
    super.initState();
    cartController = Get.put(CartController(), permanent: true);
    if (widget.product.variants.isEmpty) {
      _selectedVariantIndex = -1;
    }
  }

  ProductVariant? get _selectedVariant {
    if (widget.product.variants.isEmpty || _selectedVariantIndex < 0) {
      return null;
    }
    return widget.product.variants[_selectedVariantIndex];
  }

  void _changeVariant(int index) {
    setState(() {
      _selectedVariantIndex = index;
      _quantity = 1;
    });
  }

  void _updateQuantity(int delta) {
    final variant = _selectedVariant;
    int maxQty = variant?.stock ?? 99;
    if (maxQty <= 0) maxQty = 99;

    var newQty = _quantity + delta;
    if (newQty < 1) newQty = 1;
    if (newQty > maxQty) newQty = maxQty;

    setState(() {
      _quantity = newQty;
    });
  }

  Widget _buildInfoTile(String title, String? value, {IconData? icon}) {
    final displayValue = (value == null || value.isEmpty) ? "Đang cập nhật" : value;
    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: redColor,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(fontFamily: semibold, fontSize: 14),
      ),
      subtitle: Text(
        displayValue,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget _buildVariantDetailCard(ProductVariant variant) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (variant.name != null && variant.name!.isNotEmpty)
            Text(
              variant.name!,
              style: const TextStyle(fontFamily: semibold, fontSize: 16),
            ),
          if (variant.name != null && variant.name!.isNotEmpty) 6.heightBox,
          Row(
            children: [
              const Icon(Icons.attach_money, size: 18, color: redColor),
              6.widthBox,
              "${variant.price.toInt()}đ"
                  .text
                  .color(redColor)
                  .fontFamily(bold)
                  .size(18)
                  .make(),
            ],
          ),
          8.heightBox,
          Row(
            children: [
              const Icon(Icons.inventory_2, size: 18, color: darkFontGrey),
              6.widthBox,
              "Kho: ${variant.stock}".text.size(14).make(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantSelector() {
    if (widget.product.variants.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Phiên bản"
            .text
            .fontFamily(semibold)
            .size(16)
            .color(darkFontGrey)
            .make(),
        8.heightBox,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              widget.product.variants.length,
              (index) {
                final variant = widget.product.variants[index];
                final bool isSelected = index == _selectedVariantIndex;
                return GestureDetector(
                  onTap: () => _changeVariant(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? redColor : whiteColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected ? redColor : textfieldGrey,
                      ),
                    ),
                    child: Text(
                      variant.name ?? "Phiên bản ${index + 1}",
                      style: TextStyle(
                        color: isSelected ? whiteColor : darkFontGrey,
                        fontFamily: semibold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(ProductVariant? variant) {
    final bool outOfStock = variant != null && variant.stock == 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Số lượng".text.fontFamily(semibold).size(16).make(),
        8.heightBox,
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _updateQuantity(-1),
                    icon: const Icon(Icons.remove),
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontFamily: semibold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _updateQuantity(1),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            12.widthBox,
            if (variant != null)
              Text(
                outOfStock ? "Hết hàng" : "Kho còn: ${variant.stock}",
                style: TextStyle(
                  color: outOfStock ? Colors.red : textfieldGrey,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ourButton(
            () {
              cartController.addProduct(
                widget.product,
                variant: _selectedVariant,
                quantity: _quantity,
              );
            },
            whiteColor,
            redColor,
            "Thêm giỏ hàng",
          ),
        ),
        12.widthBox,
        Expanded(
          child: ourButton(
            () {
              cartController.addProduct(
                widget.product,
                variant: _selectedVariant,
                quantity: _quantity,
              );
              try {
                final homeController = Get.find<HomeController>();
                homeController.changeIndex(2);
              } catch (_) {}
              Get.snackbar("Giỏ hàng", "Hãy hoàn tất thanh toán trong giỏ hàng");
            },
            redColor,
            whiteColor,
            "Mua ngay",
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final featuredImage = widget.product.imageUrl;

    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: redColor,
        foregroundColor: whiteColor,
        title: Text(
          widget.product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontFamily: semibold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: featuredImage != null && featuredImage.isNotEmpty
                      ? Image.network(
                          featuredImage,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            imgP2,
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          imgP2,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              20.heightBox,
              _buildVariantSelector(),
              if (_selectedVariant != null) ...[
                12.heightBox,
                _buildVariantDetailCard(_selectedVariant!),
              ],
              16.heightBox,
              Text(
                widget.product.name,
                style: const TextStyle(
                  fontFamily: bold,
                  fontSize: 20,
                  color: darkFontGrey,
                ),
              ),
              6.heightBox,
              if (widget.product.brand?.name != null)
                "Thương hiệu: ${widget.product.brand!.name}"
                    .text
                    .color(darkFontGrey)
                    .make(),
              14.heightBox,
              Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildInfoTile(
                      "Danh mục",
                      widget.product.category?.name,
                      icon: Icons.category,
                    ),
                    _buildInfoTile(
                      "Xuất xứ",
                      widget.product.origin,
                      icon: Icons.public,
                    ),
                    _buildInfoTile(
                      "Thành phần",
                      widget.product.ingredients,
                      icon: Icons.science,
                    ),
                  ],
                ),
              ),
              16.heightBox,
              if (widget.product.usageInstructions != null &&
                  widget.product.usageInstructions!.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Hướng dẫn sử dụng"
                          .text
                          .fontFamily(semibold)
                          .size(16)
                          .make(),
                      8.heightBox,
                      widget.product.usageInstructions!.text.make(),
                    ],
                  ),
                ),
              if (widget.product.instructions != null &&
                  widget.product.instructions!.isNotEmpty) ...[
                16.heightBox,
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "Lưu ý"
                          .text
                          .fontFamily(semibold)
                          .size(16)
                          .make(),
                      8.heightBox,
                      widget.product.instructions!.text.make(),
                    ],
                  ),
                ),
              ],
              16.heightBox,
              _buildQuantitySelector(_selectedVariant),
              20.heightBox,
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }
}


