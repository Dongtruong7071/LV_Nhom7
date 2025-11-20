import '../api/product_api.dart';
import '../models/product_model.dart';

class ProductService {
  final ProductApi api = ProductApi();

  Future<List<Product>> loadProducts() => api.getProducts();

  Future<Product> loadProductDetail(int id) => api.getProductDetail(id);

  Future<Product> createProduct(Map<String, dynamic> body) =>
      api.createProduct(body);

  Future<Product> updateProduct(int id, Map<String, dynamic> body) =>
      api.updateProduct(id, body);

  Future<bool> deleteProduct(int id) => api.deleteProduct(id);
}
