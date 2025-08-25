import 'package:get/get.dart';
import 'package:finf_app/controller/main_controller.dart';
import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/core/service/api_service.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ApiService(), permanent: true);
    Get.put(MainController(), permanent: true);
  }
}
