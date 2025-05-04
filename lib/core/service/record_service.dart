import 'package:finf_app/core/service/dio_provider.dart';
import 'package:finf_app/core/config/env.dart';
import 'package:dio/dio.dart';

class RecordService {
  final Dio _dio = DioProvider.dio;

  Future<Map<String, dynamic>> fetchStaticBased() async {
    try {
      final response = await _dio.get('/trainings/static-records');
      return response.data;
    } catch (e) {
      print(e);
      // 임시 데이터 반환
      return {
        "result": [
          {
            "createdAt": "2024-03-20T06:38:07.166Z",
            "updatedAt": "2024-03-20T06:38:07.166Z",
            "id": 1,
            "userId": 1,
            "record": 150,
            "highest": true
          },
          {
            "createdAt": "2024-03-21T06:38:07.166Z",
            "updatedAt": "2024-03-21T06:38:07.166Z",
            "id": 2,
            "userId": 1,
            "record": 195,
            "highest": false
          }
        ],
        "nextUrl": ""
      };
    }
  }

  Future<Map<String, dynamic>> fetchTimeBased() async {
    try {
      final response = await _dio.get('/trainings/time-based');
      return response.data;
    } catch (e) {
      print(e);
      // 임시 데이터 반환
      return {
        "result": [
          {
            "id": 1,
            "userId": 1,
            "totalRounds": 3,
            "skipReadyBreathing": false,
            "totalSetTime": 300,
            "staticRecord": 150,
            "createdAt": "2024-03-20T06:38:37.645Z",
            "updatedAt": "2024-03-20T06:38:37.645Z"
          },
          {
            "id": 2,
            "userId": 1,
            "totalRounds": 4,
            "skipReadyBreathing": true,
            "totalSetTime": 390,
            "staticRecord": 180,
            "createdAt": "2024-03-21T06:38:37.645Z",
            "updatedAt": "2024-03-21T06:38:37.645Z"
          }
        ],
        "nextUrl": ""
      };
    }
  }

  Future<Map<String, dynamic>> fetchBreathBased() async {
    try {
      final response = await _dio.get('/trainings/breath-based');
      return response.data;
    } catch (e) {
      print(e);
      // 임시 데이터 반환
      return {
        "result": [
          {
            "id": 1,
            "userId": 1,
            "totalRounds": 5,
            "skipReadyBreathing": false,
            "preparatoryBreathDuration": 30,
            "totalSetTime": 600,
            "staticRecord": 150,
            "createdAt": "2024-03-20T06:39:17.713Z",
            "updatedAt": "2024-03-20T06:39:17.713Z"
          },
          {
            "id": 2,
            "userId": 1,
            "totalRounds": 6,
            "skipReadyBreathing": true,
            "preparatoryBreathDuration": 45,
            "totalSetTime": 900,
            "staticRecord": 180,
            "createdAt": "2024-03-21T06:39:17.713Z",
            "updatedAt": "2024-03-21T06:39:17.713Z"
          }
        ],
        "nextUrl": ""
      };
    }
  }

  Future<void> deleteStaticBased(int id) async {
    print('스테틱 기록 삭제: $id');
    // TODO: 실제 API 연동
  }

  Future<void> deleteTimeBased(int id) async {
    print('시간 기록 삭제: $id');
    // TODO: 실제 API 연동
  }

  Future<void> deleteBreathBased(int id) async {
    print('호흡 기록 삭제: $id');
    // TODO: 실제 API 연동
  }
}
