import 'package:get/get.dart';

class StaticRecordsController extends GetxController {
  final selectedTime = ''.obs;
  final selectedSeconds = 0.obs;

  void setSelectedTime(String time) {
    selectedTime.value = time;
    // 시간 문자열을 초로 변환
    final parts = time.split(':');
    if (parts.length == 2) {
      final minutes = int.parse(parts[0]);
      final seconds = int.parse(parts[1]);
      selectedSeconds.value = (minutes * 60) + seconds;
    }
  }
}
