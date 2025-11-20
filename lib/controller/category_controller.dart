import 'package:get/get.dart';
import 'package:ungdungbanmypham/core/models/category_model.dart';
import 'package:ungdungbanmypham/core/services/category_service.dart';


class CategoryController extends GetxController {
  final CategoryService _categoryService = CategoryService();

  var isLoading = false.obs;
  var categories = <Category>[].obs;
  var selectedCategory = Rx<Category?>(null);
  var error = Rx<String?>(null);
  var allCategories = <Category>[];

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      error.value = null;

      final data = await _categoryService.loadCategories();
      categories.assignAll(data);
      allCategories = List<Category>.from(data);
    } catch (e) {
      error.value = e.toString();
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCategoryDetail(int id) async {
    try {
      isLoading.value = true;
      error.value = null;

      final category = await _categoryService.loadCategoryDetail(id);
      selectedCategory.value = category;
    } catch (e) {
      error.value = e.toString();
      print('Error fetching category detail: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createCategory(Category category) async {
    try {
      final created =
          await _categoryService.createCategory(category.toJson());
      categories.add(created);
      allCategories.add(created);
      return true;
    } catch (e) {
      error.value = e.toString();
      print("Create category error: $e");
      return false;
    }
  }

  Future<bool> updateCategory(int id, Category category) async {
    try {
      final updated =
          await _categoryService.updateCategory(id, category.toJson());

      int index = categories.indexWhere((c) => c.id == id);
      if (index != -1) categories[index] = updated;

      int allIndex = allCategories.indexWhere((c) => c.id == id);
      if (allIndex != -1) allCategories[allIndex] = updated;

      return true;
    } catch (e) {
      error.value = e.toString();
      print("Update category error: $e");
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      await _categoryService.deleteCategory(id);
      categories.removeWhere((c) => c.id == id);
      allCategories.removeWhere((c) => c.id == id);
      return true;
    } catch (e) {
      error.value = e.toString();
      print("Delete category error: $e");
      return false;
    }
  }

  // ---------- Tìm kiếm ----------
  void searchCategories(String query) {
    if (query.isEmpty) {
      categories.assignAll(allCategories);
    } else {
      final filtered = allCategories
          .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      categories.assignAll(filtered);
    }
  }
}
