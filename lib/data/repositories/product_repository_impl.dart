import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product> getProductDetail(int id) {
    return remoteDataSource.getProductDetail(id);
  }

  @override
  Future<List<Product>> getProducts({
    int skip = 0,
    int limit = 20,
    String? search,
    int? brandId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? inStock,
  }) {
    return remoteDataSource.getProducts(
      skip: skip,
      limit: limit,
      search: search,
      brandId: brandId,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      inStock: inStock,
    );
  }

 
}
