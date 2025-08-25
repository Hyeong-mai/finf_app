import 'package:get/get.dart';
import 'package:finf_app/controller/record_list_controller.dart';

class RecordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RecordListController(), permanent: true);
  }
}
