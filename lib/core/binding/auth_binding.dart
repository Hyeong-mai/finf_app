import 'package:get/get.dart';
import '../../controller/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(),
        permanent: true); // permanent: true로 설정하여 앱 전체에서 유지
  }
}
