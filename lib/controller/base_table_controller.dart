import 'package:finf_app/core/service/record_service.dart';
import 'package:get/get.dart';

abstract class BaseTableController extends GetxController {
  final RecordService _recordService = RecordService();
  final RxList<Map<String, dynamic>> records = <Map<String, dynamic>>[].obs;
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

  Future<void> fetchRecords() async {
    final response = await fetchData();
    records.value = List<Map<String, dynamic>>.from(response['result']);
  }

  Future<Map<String, dynamic>> fetchData();
}
