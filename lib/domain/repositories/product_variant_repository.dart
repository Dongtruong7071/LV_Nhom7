import '../entities/product_variant.dart';

abstract class ProductVariantRepository {
  Future<List<ProductVariant>> getVariants({
    int? productId,
    int skip = 0,
    int limit = 20,
  });

  Future<ProductVariant> getVariantDetail(int id);


  Future<ProductVariant> updateVariant(int id, Map<String, dynamic> body);

}

