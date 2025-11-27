import 'package:get/get.dart';
import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../../data/repositories/brand_repository_impl.dart';
import '../../data/datasources/remote/brand_remote_data_source.dart';

class BrandController extends GetxController {
  late final BrandRepository _repository;

  BrandController() {
    _repository = BrandRepositoryImpl(remoteDataSource: BrandRemoteDataSource());
  }

  var isLoading = false.obs;
  var brands = <Brand>[].obs;
  var selectedBrand = Rx<Brand?>(null);
  var error = Rx<String?>(null);
  var allBrands = <Brand>[];

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await _repository.getBrands();
      brands.assignAll(data);
      allBrands = List<Brand>.from(data);
    } catch (e) {
      error.value = e.toString();
      print('Error fetching brands: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBrandDetail(int id) async {
    try {
      isLoading.value = true;
      error.value = null;

      final brand = await _repository.getBrandDetail(id);
      selectedBrand.value = brand;
    } catch (e) {
      error.value = e.toString();
      print('Error fetching brand detail: $e');
    } finally {
      isLoading.value = false;
    }
  }


 


  // ---------- Tìm kiếm ----------
  void searchBrands(String query) {
    if (query.isEmpty) {
      brands.assignAll(allBrands);
    } else {
      final filtered = allBrands
          .where((b) => b.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      brands.assignAll(filtered);
    }
  }
}
