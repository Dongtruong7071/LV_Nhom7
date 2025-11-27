import '../entities/product.dart';

abstract class ProductRepository {
  
  Future<List<Product>> getProducts({
    int skip = 0,
    int limit = 20,
    String? search,
    int? brandId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  });

  Future<Product> getProductDetail(int id);

}
