import 'package:dio/dio.dart';

class DioClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: "https://mock-api.dev", // 👉 TODO: replace bằng BE thật
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  )..interceptors.add(LogInterceptor(
    requestBody: true,
    responseBody: true,
  ));
}