import '../entities/brand.dart';

abstract class BrandRepository {
  Future<List<Brand>> getBrands();
  Future<Brand> getBrandDetail(int id);
 
}
