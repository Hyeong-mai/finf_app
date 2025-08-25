import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:finf_app/core/service/provider/dio_provider.dart';

class ApiService extends GetxService {
  final Dio _dio = DioProvider.client;

  static Future<Map<String, dynamic>> refreshToken() async {
    // 토큰 갱신 로직 구현
    return {};
  }

  Future<List<Map<String, dynamic>>> getStaticRecords() async {
    try {
      final response = await _dio.get('/records/static');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('기록을 불러오는데 실패했습니다.');
    }
  }

  Future<Map<String, dynamic>> getHighestStaticRecord() async {
    // 임시 데이터
    return {
      "createdAt": "2025-04-19T06:23:00.489Z",
      "updatedAt": "2025-04-19T06:23:00.489Z",
      "id": 1,
      "userId": 1,
      "record": 150, // 2분 30초
      "highest": true
    };
  }
}
