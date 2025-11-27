import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/remote/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});
 
  @override
  Future<Category> getCategoryDetail(int id) {
    return remoteDataSource.getCategoryDetail(id);
  }

  @override
  Future<List<Category>> getCategories() {
    return remoteDataSource.getCategories();
  }

 
}
