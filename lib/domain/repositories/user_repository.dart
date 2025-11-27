import '../entities/user.dart';

abstract class UserRepository {
  Future<User> getUserByFirebaseUid(String firebaseUid);
  Future<User> updateUser(int userId, Map<String, dynamic> data);
  Future<User> createUser(Map<String, dynamic> data);
}


