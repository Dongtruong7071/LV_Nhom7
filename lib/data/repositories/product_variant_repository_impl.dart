import '../../domain/entities/product_variant.dart';
import '../../domain/repositories/product_variant_repository.dart';
import '../datasources/remote/product_variant_remote_data_source.dart';

class ProductVariantRepositoryImpl implements ProductVariantRepository {
  final ProductVariantRemoteDataSource remoteDataSource;

  ProductVariantRepositoryImpl({required this.remoteDataSource});


  @override
  Future<ProductVariant> getVariantDetail(int id) {
    return remoteDataSource.getVariantDetail(id);
  }

  @override
  Future<List<ProductVariant>> getVariants({
    int? productId,
    int skip = 0,
    int limit = 20,
  }) {
    return remoteDataSource.getVariants(
      productId: productId,
      skip: skip,
      limit: limit,
    );
  }

  @override
  Future<ProductVariant> updateVariant(int id, Map<String, dynamic> body) {
    return remoteDataSource.updateVariant(id, body);
  }
}

