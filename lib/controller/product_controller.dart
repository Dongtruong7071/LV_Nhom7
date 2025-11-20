import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/models/product_model.dart';
import 'package:ungdungbanmypham/core/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _productService = ProductService();

  var isLoading = false.obs;
  var products = <Product>[].obs;
  var selectedProduct = Rx<Product?>(null);
  var error = Rx<String?>(null);
  var allProducts = <Product>[]; 
   @override
  void onInit() {
    super.onInit();
    fetchProducts(); 
  }

  Future<void> fetchProducts({int skip = 0, int limit = 20}) async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await _productService.loadProducts();
      products.assignAll(data);
      allProducts = List<Product>.from(data);
    } catch (e) {
      error.value = e.toString();
      print('Error fetching products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchProductDetail(int id) async {
    try {
      isLoading.value = true;
      error.value = null;

      final product = await _productService.loadProductDetail(id);
      selectedProduct.value = product;
    } catch (e) {
      error.value = e.toString();
      print('Error fetching product detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      final created = await _productService.createProduct(product.toJson());
      products.add(created);
      allProducts.add(created);
      return true;
    } catch (e) {
      error.value = e.toString();
      print("Create product error: $e");
      return false;
    }
  }

  Future<bool> updateProduct(int id, Product product) async {
    try {
      final updated = await _productService.updateProduct(id, product.toJson());
      int index = products.indexWhere((p) => p.id == id);
      if (index != -1) products[index] = updated;

      int allIndex = allProducts.indexWhere((p) => p.id == id);
      if (allIndex != -1) allProducts[allIndex] = updated;

      return true;
    } catch (e) {
      error.value = e.toString();
      print("Update product error: $e");
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _productService.deleteProduct(id);
      products.removeWhere((p) => p.id == id);
      allProducts.removeWhere((p) => p.id == id);
      return true;
    } catch (e) {
      error.value = e.toString();
      print("Delete product error: $e");
      return false;
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      products.assignAll(allProducts);
    } else {
      final filtered = allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      products.assignAll(filtered);
    }
  }
}