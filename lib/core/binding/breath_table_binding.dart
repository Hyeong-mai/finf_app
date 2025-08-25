import 'package:get/get.dart';
import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/controller/breath_table_controller.dart';

class BreathTableBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaticRecordsController(), permanent: true);
    Get.put(BreathTableController(), permanent: true);
  }
}
