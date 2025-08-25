import 'package:finf_app/core/service/auth_service.dart';
import 'package:finf_app/main.dart';
import 'package:finf_app/core/service/config/api_config.dart';
import 'package:finf_app/core/service/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:logger/logger.dart';

class DioProvider {
  static Dio? _dio;
  static bool isRestarting = false;
  static final _authService = AuthService();

  static Dio get client {
    _dio ??= createDio();
    return _dio!;
  }

  static void saveTokens(Map<String, dynamic>? tokens) {
    // 토큰 저장 로직 구현
    if (tokens != null) {
      client.options.headers['Authorization'] =
          'Bearer ${tokens['accessToken']}';
    } else {
      client.options.headers['Authorization'] = 'Bearer ';
    }
  }

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.getBaseUrl(),
        headers: {
          'Content-Type': 'application/json',
          'Api-Version': '1.0',
          'Authorization': 'Bearer ',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          final requestPath = error.requestOptions.path;
          Logger().d(
              "❌ Dio Error on: $requestPath → ${error.response?.statusCode}");

          if (error.response?.statusCode == 403 &&
              error.requestOptions.extra["__isRetryRequest"] != true) {
            try {
              final newTokens = await _authService.refreshToken();
              if (newTokens != null) {
                saveTokens(newTokens);
                final newToken = newTokens['accessToken'];

                final options = error.requestOptions;
                options.extra["__isRetryRequest"] = true;
                options.headers["Authorization"] = "Bearer $newToken";

                final retryResponse = await DioProvider.client.request(
                  options.path,
                  options: Options(
                    method: options.method,
                    headers: options.headers,
                  ),
                  data: options.data,
                  queryParameters: options.queryParameters,
                );

                return handler.resolve(retryResponse);
              }
            } catch (e) {
              return handler.reject(error); // fallback
            }
          }

          if (error.response?.statusCode == 401 &&
              requestPath != "/api/admin/auth/login") {
            if (!isRestarting) {
              isRestarting = true;
              saveTokens(null);
              Get.deleteAll();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final context = navigatorKey.currentContext;
                if (context != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        error.response?.data["message"] ??
                            "세션이 만료되었습니다. 다시 로그인해주세요.",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      duration: const Duration(milliseconds: 1500),
                    ),
                  );
                  Get.offAllNamed('/login');
                }
              });
              // if (navigatorKey.currentContext != null) {
              //   Get.offAllNamed('/login');
              //   void showError(String message, BuildContext context) {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text(message)),
              //     );
              //   }

              //   ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //         error.response?.data["message"] ??
              //             "세션이 만료되었습니다. 다시 로그인해주세요.",
              //         style: const TextStyle(
              //           fontSize: 16,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //         ),
              //       ),
              //       duration: const Duration(milliseconds: 1500),
              //     ),
              //   );
              // }
            }

            return handler.reject(error); // ❗반드시 reject로 처리
          }

          return handler.next(error); // default flow
        },
      ),
    );

    return dio;
  }

  static void resetClient() {
    _dio = createDio(); // 서버 변경 시 호출
  }
}
