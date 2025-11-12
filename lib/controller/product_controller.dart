import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/api/product_api_service.dart';
import 'package:ungdungbanmypham/core/models/product_model.dart';

class ProductController extends GetxController {
  final ProductApiService _apiService = ProductApiService();

  var products = <Product>[].obs;
  var isLoading = true.obs;
  var error = RxnString();

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts({
    String? search,
    int? brandId,
    int? categoryId,
  }) async {
    try {
      isLoading(true);
      final data = await _apiService.getProducts(
        search: search,
        brandId: brandId,
        categoryId: categoryId,
      );
      products.assignAll(data);
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading(false);
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      fetchProducts();
    } else {
      fetchProducts(search: query);
    }
  }
}