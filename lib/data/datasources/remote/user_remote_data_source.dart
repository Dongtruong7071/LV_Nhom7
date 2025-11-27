import 'package:dio/dio.dart';
import 'package:ungdungbanmypham/core/api/dio_client.dart';
import 'package:ungdungbanmypham/domain/entities/user.dart';

class UserRemoteDataSource {
  final Dio _dio = DioClient.dio;

  Future<User> getUserByFirebaseUid(String firebaseUid) async {
    final response = await _dio.get("/users/by_uid/$firebaseUid");
    return User.fromJson(response.data);
  }

  Future<User> updateUser(int userId, Map<String, dynamic> data) async {
    final response = await _dio.put("/users/$userId", data: data);
    return User.fromJson(response.data);
  }

  Future<User> createUser(Map<String, dynamic> data) async {
    final response = await _dio.post("/users", data: data);
    return User.fromJson(response.data);
  }
}


