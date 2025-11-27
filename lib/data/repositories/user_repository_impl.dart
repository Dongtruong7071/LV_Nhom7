import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getUserByFirebaseUid(String firebaseUid) {
    return remoteDataSource.getUserByFirebaseUid(firebaseUid);
  }

  @override
  Future<User> updateUser(int userId, Map<String, dynamic> data) {
    return remoteDataSource.updateUser(userId, data);
  }

  @override
  Future<User> createUser(Map<String, dynamic> data) {
    return remoteDataSource.createUser(data);
  }
}


