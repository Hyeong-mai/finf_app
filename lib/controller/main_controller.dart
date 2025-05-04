import 'package:get/get.dart';
import 'package:finf_app/core/service/api_service.dart';
import 'package:finf_app/core/model/static_record_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class MainController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  final RxList<StaticRecord> staticRecords = <StaticRecord>[].obs;
  final Rx<StaticRecord?> highestRecord = Rx<StaticRecord?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getStaticRecords();
    fetchHighestStaticRecord();
  }

  Future<void> getStaticRecords() async {
    try {
      isLoading.value = true;
      final records = await _apiService.getStaticRecords();
      staticRecords.value =
          records.map((record) => StaticRecord.fromJson(record)).toList();
    } catch (e) {
      String errorMessage = '기록을 불러오는데 실패했습니다.';
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

  Future<void> fetchHighestStaticRecord() async {
    try {
      isLoading.value = true;
      final record = await _apiService.getHighestStaticRecord();
      highestRecord.value = StaticRecord.fromJson(record);
    } catch (e) {
      String errorMessage = '최고 기록을 불러오는데 실패했습니다.';
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
