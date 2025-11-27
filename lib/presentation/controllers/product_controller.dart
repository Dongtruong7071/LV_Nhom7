import 'package:get/get.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../data/datasources/remote/product_remote_data_source.dart';

class ProductController extends GetxController {

  late final ProductRepository _repository;

  ProductController() {
    _repository = ProductRepositoryImpl(remoteDataSource: ProductRemoteDataSource());
  }

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

      final data = await _repository.getProducts(skip: skip, limit: limit);
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

      final product = await _repository.getProductDetail(id);
      selectedProduct.value = product;
    } catch (e) {
      error.value = e.toString();
      print('Error fetching product detail: $e');
    } finally {
      isLoading.value = false;
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