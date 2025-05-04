import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

class StaticRecordsController extends GetxController {
  final selectedTime = ''.obs;
  final selectedSeconds = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  void setSelectedTime(String time) {
    try {
      isLoading.value = true;
      selectedTime.value = time;
      // 시간 문자열을 초로 변환
      final parts = time.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        selectedSeconds.value = (minutes * 60) + seconds;
      } else {
        throw const FormatException('잘못된 시간 형식입니다.');
      }
    } catch (e) {
      String errorMsg = '시간 설정 중 오류가 발생했습니다.';
      if (e is FormatException) {
        errorMsg = '시간 형식이 올바르지 않습니다. (예: 00:00)';
      } else if (e is TimeoutException) {
        errorMsg = '작업 시간이 초과되었습니다.';
      } else if (e is SocketException) {
        errorMsg = '네트워크 연결을 확인해주세요.';
      }
      errorMessage.value = errorMsg;
      Get.snackbar(
        '오류',
        errorMsg,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    selectedTime.close();
    selectedSeconds.close();
    isLoading.close();
    errorMessage.close();
    super.onClose();
  }
}
