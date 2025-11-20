import '../api/category_api.dart';
import '../models/category_model.dart';

class CategoryService {
  final CategoryApi api = CategoryApi();

  Future<List<Category>> loadCategories() => api.getCategories();

  Future<Category> loadCategoryDetail(int id) =>
      api.getCategoryDetail(id);

  Future<Category> createCategory(Map<String, dynamic> body) =>
      api.createCategory(body);

  Future<Category> updateCategory(int id, Map<String, dynamic> body) =>
      api.updateCategory(id, body);

  Future<bool> deleteCategory(int id) => api.deleteCategory(id);
}
