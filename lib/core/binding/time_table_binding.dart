import 'package:get/get.dart';
import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/controller/time_table_controller.dart';

class TimeTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaticRecordsController(), permanent: true);
    Get.put(TimeTableController(), permanent: true);
  }
}
