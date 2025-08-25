import 'package:dio/dio.dart';
import '../config/env.dart';

class DioProvider {
  static final Dio dio = Dio(BaseOptions(
    baseUrl: Env.apiUrl,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));
}
