import 'package:get/get.dart';
import '../core/service/record_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class RecordListController extends GetxController {
  final RxList<Map<String, dynamic>> staticRecords =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> timeRecords = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> breathRecords =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final _recordService = RecordService();
  final selectedIndex = 0.obs;

  // 현재 선택된 인덱스에 따라 해당하는 레코드 리스트를 반환
  List<Map<String, dynamic>> get records {
    switch (selectedIndex.value) {
      case 0:
        return staticRecords;
      case 1:
        return timeRecords;
      case 2:
        return breathRecords;
      default:
        return staticRecords;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllRecords();
  }

  Future<void> fetchAllRecords() async {
    isLoading.value = true;
    await Future.wait([
      fetchStaticBased(),
      fetchTimeBased(),
      fetchBreathBased(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchStaticBased() async {
    final response = await _recordService.fetchStaticBased();
    staticRecords.value = List<Map<String, dynamic>>.from(response['result']);
  }

  Future<void> fetchTimeBased() async {
    final response = await _recordService.fetchTimeBased();
    timeRecords.value = List<Map<String, dynamic>>.from(response['result']);
  }

  Future<void> fetchBreathBased() async {
    final response = await _recordService.fetchBreathBased();
    breathRecords.value = List<Map<String, dynamic>>.from(response['result']);
  }

  Future<void> deleteRecord(int id) async {
    try {
      isLoading.value = true;
      switch (selectedIndex.value) {
        case 0:
          await _recordService.deleteStaticBased(id);
          await fetchStaticBased();
          Get.snackbar(
            '성공',
            '정적 기록이 삭제되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case 1:
          await _recordService.deleteTimeBased(id);
          await fetchTimeBased();
          Get.snackbar(
            '성공',
            '시간 기록이 삭제되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
        case 2:
          await _recordService.deleteBreathBased(id);
          await fetchBreathBased();
          Get.snackbar(
            '성공',
            '호흡 기록이 삭제되었습니다.',
            snackPosition: SnackPosition.BOTTOM,
          );
          break;
      }
    } catch (e) {
      String errorMessage = '삭제 중 오류가 발생했습니다.';
      if (e is FormatException) {
        errorMessage = '데이터 형식이 올바르지 않습니다.';
      } else if (e is TimeoutException) {
        errorMessage = '서버 응답 시간이 초과되었습니다.';
      } else if (e is SocketException) {
        errorMessage = '네트워크 연결을 확인해주세요.';
      }
      Get.snackbar(
        '오류',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
