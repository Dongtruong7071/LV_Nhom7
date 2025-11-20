import 'package:dio/dio.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://127.0.0.1:8000", 
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  static Dio get dio => _dio;
}
