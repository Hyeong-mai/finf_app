import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class RecordController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // 로딩 상태
  final RxBool isLoading = false.obs;
  
  // 스테틱 기록 데이터
  final RxList<Map<String, dynamic>> staticRecords = <Map<String, dynamic>>[].obs;
  
  // 호흡기반 기록 데이터
  final RxList<Map<String, dynamic>> breathBasedRecords = <Map<String, dynamic>>[].obs;
  
  // 시간기반 기록 데이터
  final RxList<Map<String, dynamic>> timeBasedRecords = <Map<String, dynamic>>[].obs;
  
  // 에러 상태
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 초기 데이터 로드
    loadAllRecords();
  }

  /// 모든 기록 데이터 로드
  Future<void> loadAllRecords() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';
      
      // 병렬로 모든 기록 데이터 로드
      await Future.wait([
        loadStaticRecords(),
        loadBreathBasedRecords(),
        loadTimeBasedRecords(),
      ]);
      
    } catch (e) {
      hasError.value = true;
      errorMessage.value = '기록 데이터 로드 중 오류가 발생했습니다: $e';
      print('기록 데이터 로드 오류: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// 스테틱 기록 데이터 로드
  Future<void> loadStaticRecords() async {
    try {
      final response = await _apiService.get('/records/static');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        staticRecords.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
        
        // 순위별로 정렬 (기록이 높은 순)
        staticRecords.sort((a, b) {
          final aRecord = _parseRecordTime(a['record'] ?? '0');
          final bRecord = _parseRecordTime(b['record'] ?? '0');
          return bRecord.compareTo(aRecord); // 내림차순
        });
        
        // 순위 추가
        for (int i = 0; i < staticRecords.length; i++) {
          staticRecords[i]['rank'] = i + 1;
        }
      }
    } catch (e) {
      print('스테틱 기록 로드 실패: $e');
      // 에러 발생 시 기본 데이터 유지
    }
  }

  /// 호흡기반 기록 데이터 로드
  Future<void> loadBreathBasedRecords() async {
    try {
      final response = await _apiService.get('/records/breath-based');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        breathBasedRecords.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
        
        // 날짜별로 정렬 (최신순)
        breathBasedRecords.sort((a, b) {
          final aDate = DateTime.parse(a['date'] ?? '1970-01-01');
          final bDate = DateTime.parse(b['date'] ?? '1970-01-01');
          return bDate.compareTo(aDate); // 내림차순
        });
      }
    } catch (e) {
      print('호흡기반 기록 로드 실패: $e');
      // 에러 발생 시 기본 데이터 유지
    }
  }

  /// 시간기반 기록 데이터 로드
  Future<void> loadTimeBasedRecords() async {
    try {
      final response = await _apiService.get('/records/time-based');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        timeBasedRecords.value = data.map((item) => Map<String, dynamic>.from(item)).toList();
        
        // 날짜별로 정렬 (최신순)
        timeBasedRecords.sort((a, b) {
          final aDate = DateTime.parse(a['date'] ?? '1970-01-01');
          final bDate = DateTime.parse(b['date'] ?? '1970-01-01');
          return bDate.compareTo(aDate); // 내림차순
        });
      }
    } catch (e) {
      print('시간기반 기록 로드 실패: $e');
      // 에러 발생 시 기본 데이터 유지
    }
  }

  /// 특정 기록 삭제
  Future<bool> deleteRecord(String recordType, String recordId) async {
    try {
      final response = await _apiService.delete('/records/$recordType/$recordId');
      
      if (response.statusCode == 200) {
        // 삭제 성공 시 해당 데이터 목록에서 제거
        switch (recordType) {
          case 'static':
            staticRecords.removeWhere((record) => record['id'] == recordId);
            break;
          case 'breath-based':
            breathBasedRecords.removeWhere((record) => record['id'] == recordId);
            break;
          case 'time-based':
            timeBasedRecords.removeWhere((record) => record['id'] == recordId);
            break;
        }
        
        Get.snackbar(
          '삭제 완료',
          '기록이 삭제되었습니다.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        return true;
      }
    } catch (e) {
      print('기록 삭제 실패: $e');
      Get.snackbar(
        '삭제 실패',
        '기록 삭제 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
    return false;
  }

  /// 기록 새로고침
  Future<void> refreshRecords() async {
    await loadAllRecords();
  }

  /// 특정 기록 타입만 새로고침
  Future<void> refreshRecordType(String recordType) async {
    switch (recordType) {
      case 'static':
        await loadStaticRecords();
        break;
      case 'breath-based':
        await loadBreathBasedRecords();
        break;
      case 'time-based':
        await loadTimeBasedRecords();
        break;
    }
  }

  /// 기록 시간 파싱 (예: "120초" -> 120)
  int _parseRecordTime(String record) {
    try {
      if (record.contains('초')) {
        return int.parse(record.replaceAll('초', ''));
      } else if (record.contains('분')) {
        final parts = record.split('분');
        if (parts.length == 2) {
          final minutes = int.parse(parts[0]);
          final seconds = int.parse(parts[1].replaceAll('초', ''));
          return minutes * 60 + seconds;
        }
        return int.parse(parts[0]) * 60;
      }
      return int.parse(record);
    } catch (e) {
      return 0;
    }
  }

  /// 기록 시간 포맷팅 (예: 120 -> "2분 0초")
  String formatRecordTime(int seconds) {
    if (seconds < 60) {
      return '${seconds}초';
    } else {
      final minutes = seconds ~/ 60;
      final remainingSeconds = seconds % 60;
      if (remainingSeconds == 0) {
        return '${minutes}분';
      } else {
        return '${minutes}분 ${remainingSeconds}초';
      }
    }
  }

  /// 날짜 포맷팅
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  /// 기록 통계 정보
  Map<String, dynamic> getRecordStats() {
    final stats = <String, dynamic>{};
    
    // 스테틱 기록 통계
    if (staticRecords.isNotEmpty) {
      final bestRecord = staticRecords.first;
      stats['bestStaticRecord'] = bestRecord['record'];
      stats['totalStaticRecords'] = staticRecords.length;
    }
    
    // 호흡기반 기록 통계
    if (breathBasedRecords.isNotEmpty) {
      stats['totalBreathRecords'] = breathBasedRecords.length;
      final totalRounds = breathBasedRecords.fold<int>(0, (sum, record) => sum + (record['totalRounds'] as int? ?? 0));
      stats['totalBreathRounds'] = totalRounds;
    }
    
    // 시간기반 기록 통계
    if (timeBasedRecords.isNotEmpty) {
      stats['totalTimeRecords'] = timeBasedRecords.length;
      final totalRounds = timeBasedRecords.fold<int>(0, (sum, record) => sum + (record['totalRounds'] as int? ?? 0));
      stats['totalTimeRounds'] = totalRounds;
    }
    
    return stats;
  }
}
