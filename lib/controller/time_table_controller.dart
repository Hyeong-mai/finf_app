import 'package:finf_app/controller/base_table_controller.dart';
import 'package:finf_app/core/service/record_service.dart';
import 'package:get/get.dart';

class TimeTableController extends BaseTableController {
  final RecordService _recordService = RecordService();
  final timeRecords = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchRecords();
  }

  @override
  Future<Map<String, dynamic>> fetchData() async {
    return _recordService.fetchTimeBased();
  }
}
