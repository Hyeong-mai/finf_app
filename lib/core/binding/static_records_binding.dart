import 'package:get/get.dart';
import 'package:finf_app/controller/static_records_controller.dart';

class StaticRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StaticRecordsController(), permanent: true);
  }
}
