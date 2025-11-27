import 'package:get/get.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../data/datasources/remote/category_remote_data_source.dart';

class CategoryController extends GetxController {
  late final CategoryRepository _repository;

  CategoryController() {
    _repository = CategoryRepositoryImpl(remoteDataSource: CategoryRemoteDataSource());
  }

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

      final data = await _repository.getCategories();
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

      final category = await _repository.getCategoryDetail(id);
      selectedCategory.value = category;
    } catch (e) {
      error.value = e.toString();
      print('Error fetching category detail: $e');
    } finally {
      isLoading.value = false;
    }
  }


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
