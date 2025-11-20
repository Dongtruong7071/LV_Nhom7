import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/models/brand_model.dart';
import 'package:ungdungbanmypham/core/services/brand_service.dart';


class BrandController extends GetxController {
  final BrandService _brandService = BrandService();

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

      final data = await _brandService.loadBrands();
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

      final brand = await _brandService.loadBrandDetail(id);
      selectedBrand.value = brand;
    } catch (e) {
      error.value = e.toString();
      print('Error fetching brand detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBrand(Brand brand) async {
    try {
      final created =
          await _brandService.createBrand(brand.toJson());
      brands.add(created);
      allBrands.add(created);
      return true;
    } catch (e) {
      error.value = e.toString();
      print("Create brand error: $e");
      return false;
    }
  }

  // ---------- Cập nhật brand ----------
  Future<bool> updateBrand(int id, Brand brand) async {
    try {
      final updated =
          await _brandService.updateBrand(id, brand.toJson());

      int index = brands.indexWhere((b) => b.id == id);
      if (index != -1) brands[index] = updated;

      int allIndex = allBrands.indexWhere((b) => b.id == id);
      if (allIndex != -1) allBrands[allIndex] = updated;

      return true;
    } catch (e) {
      error.value = e.toString();
      print("Update brand error: $e");
      return false;
    }
  }

  // ---------- Xóa brand ----------
  Future<bool> deleteBrand(int id) async {
    try {
      await _brandService.deleteBrand(id);
      brands.removeWhere((b) => b.id == id);
      allBrands.removeWhere((b) => b.id == id);
      return true;
    } catch (e) {
      error.value = e.toString();
      print("Delete brand error: $e");
      return false;
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
