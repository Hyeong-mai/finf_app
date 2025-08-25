import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late dio.Dio _dio;
  final StorageService _storageService = Get.find<StorageService>();

  /// API 서비스 초기화
  void initialize() {
    _dio = dio.Dio(
      dio.BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 인터셉터 설정
    _setupInterceptors();
  }

  /// 인터셉터 설정
  void _setupInterceptors() {
    print('인터셉터 설정 시작');
    // 요청 인터셉터
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onRequest: (options, handler) async {
          // 토큰이 있으면 헤더에 추가
          final token = await _storageService.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          handler.next(response);
        },
        onError: (error, handler) async {
          // 401 에러 시 토큰 리프레시 시도
          if (error.response?.statusCode == 401) {
            try {
              final newToken = await _refreshToken();
              if (newToken != null) {
                // 원래 요청 재시도
                final originalRequest = error.requestOptions;
                originalRequest.headers['Authorization'] = 'Bearer $newToken';

                final response = await _dio.fetch(originalRequest);
                handler.resolve(response);
                return;
              }
            } catch (e) {
              // 토큰 리프레시 실패 시 로그아웃 처리
              await _handleTokenRefreshFailure();
            }
          }
          handler.next(error);
        },
      ),
    );

    // 로깅 인터셉터 (개발 환경에서만)
    if (ApiConstants.isDebugMode) {
      _dio.interceptors.add(
        dio.LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => print(obj),
        ),
      );
    }
  }

  /// 토큰 리프레시
  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null) return null;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        // 새 토큰 저장
        await _storageService.saveAccessToken(newAccessToken);
        await _storageService.saveRefreshToken(newRefreshToken);

        return newAccessToken;
      }
    } catch (e) {
      print('토큰 리프레시 실패: $e');
    }
    return null;
  }

  /// 토큰 리프레시 실패 처리
  Future<void> _handleTokenRefreshFailure() async {
    // 저장된 토큰 삭제
    await _storageService.clearTokens();

    // 로그인 페이지로 이동
    Get.offAllNamed('/login');

    // 사용자에게 알림
    Get.snackbar(
      '세션 만료',
      '다시 로그인해주세요.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFFF44336),
      colorText: Colors.white,
    );
  }

  /// GET 요청
  Future<dio.Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// POST 요청
  Future<dio.Response> post(String path, {dynamic data}) async {
    try {
      print('API 요청 전송: $path');
      print('요청 데이터: $data');

      final response = await _dio.post(path, data: data);
      print('API 응답 성공: ${response.statusCode}');
      print('응답 데이터: ${response.data}');
      return response;
    } catch (e) {
      print('API 요청 실패: $e');
      if (e is dio.DioException) {
        print('DioException 상세 정보:');
        print('  - 에러 타입: ${e.type}');
        print('  - 상태 코드: ${e.response?.statusCode}');
        print('  - 응답 데이터: ${e.response?.data}');
        print('  - 요청 데이터: ${e.requestOptions.data}');
        print('  - 요청 헤더: ${e.requestOptions.headers}');
      }
      rethrow;
    }
  }

  /// PUT 요청
  Future<dio.Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE 요청
  Future<dio.Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 파일 업로드
  Future<dio.Response> uploadFile(String path, dio.FormData formData) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: dio.Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 스테틱 최고 기록 조회
  Future<dio.Response> getHighestStaticRecord({
    required int userId,
  }) async {
    try {
      // 테스트용: 하드코딩된 140초 값 반환
      await Future.delayed(const Duration(milliseconds: 500)); // API 호출 시뮬레이션
      
      // Mock 응답 데이터 생성
      final mockResponse = {
        'result': {
          'id': 1,
          'userId': userId,
          'record': 20, // 140초
          'highest': true,
          'createdAt': '2025-08-25T07:17:38.903Z',
          'updatedAt': '2025-08-25T07:17:38.903Z',
        }
      };
      
      // Dio Response 객체 생성
      final response = dio.Response(
        data: mockResponse,
        statusCode: 200,
        requestOptions: dio.RequestOptions(path: '/trainings/static-records/highest'),
      );
      
      return response;
      
      // 실제 API 호출 코드 (테스트 완료 후 활성화)
      // final queryParameters = <String, dynamic>{
      //   'userId': userId,
      // };
      // 
      // final response = await _dio.get(
      //   '/trainings/static-records/highest',
      //   queryParameters: queryParameters,
      // );
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 기록 데이터 조회
  Future<dio.Response> getStaticRecords({
    required int userId,
    int? cursor,
    int limit = 10,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'userId': userId,
        'limit': limit,
      };
      
      if (cursor != null) {
        queryParameters['cursor'] = cursor;
      }
      
      final response = await _dio.get(
        ApiConstants.staticRecords,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 시간기반 기록 데이터 조회
  Future<dio.Response> getTimeBasedRecords({
    required int userId,
    int? cursor,
    int limit = 10,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'userId': userId,
        'limit': limit,
      };
      
      if (cursor != null) {
        queryParameters['cursor'] = cursor;
      }
      
      final response = await _dio.get(
        ApiConstants.timeBasedRecords,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 호흡기반 기록 데이터 조회
  Future<dio.Response> getBreathBasedRecords({
    required int userId,
    int? cursor,
    int limit = 10,
  }) async {
    try {
      final queryParameters = <String, dynamic>{
        'userId': userId,
        'limit': limit,
      };
      
      if (cursor != null) {
        queryParameters['cursor'] = cursor;
      }
      
      final response = await _dio.get(
        ApiConstants.breathBasedRecords,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// 운동 기록 완료 데이터 전송
  Future<dio.Response> sendStaticRecord({required int record}) async {
    try {
      final data = {'record': record};

      final response = await _dio.post('/trainings/static-records', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> sendTimeRecord({
    required int totalRounds,
    required bool skipReadyBreathing,
    required int staticRecord,
  }) async {
    try {
      final data = {
        'totalRounds': totalRounds,
        'skipReadyBreathing': skipReadyBreathing,
        'staticRecord': staticRecord,
      };

      final response = await _dio.post('/trainings/time-based', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dio.Response> sendBreathRecord({
    required int totalRounds,
    required bool skipReadyBreathing,
    required int preparatoryBreathDuration,
    required int staticRecord,
  }) async {
    try {
      final data = {
        'totalRounds': totalRounds,
        'skipReadyBreathing': skipReadyBreathing,
        'preparatoryBreathDuration': preparatoryBreathDuration,
        'staticRecord': staticRecord,
      };

      final response = await _dio.post('/trainings/breath-based', data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
