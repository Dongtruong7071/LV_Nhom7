import '../api/brand_api.dart';
import '../models/brand_model.dart';

class BrandService {
  final BrandApi api = BrandApi();

  Future<List<Brand>> loadBrands() => api.getBrands();

  Future<Brand> loadBrandDetail(int id) => api.getBrandDetail(id);

  Future<Brand> createBrand(Map<String, dynamic> body) =>
      api.createBrand(body);

  Future<Brand> updateBrand(int id, Map<String, dynamic> body) =>
      api.updateBrand(id, body);

  Future<bool> deleteBrand(int id) => api.deleteBrand(id);
}
