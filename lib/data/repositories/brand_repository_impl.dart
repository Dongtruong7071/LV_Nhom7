import '../../domain/entities/brand.dart';
import '../../domain/repositories/brand_repository.dart';
import '../datasources/remote/brand_remote_data_source.dart';

class BrandRepositoryImpl implements BrandRepository {
  final BrandRemoteDataSource remoteDataSource;

  BrandRepositoryImpl({required this.remoteDataSource});


  @override
  Future<Brand> getBrandDetail(int id) {
    return remoteDataSource.getBrandDetail(id);
  }

  @override
  Future<List<Brand>> getBrands() {
    return remoteDataSource.getBrands();
  }


}
