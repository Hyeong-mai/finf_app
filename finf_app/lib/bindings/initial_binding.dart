import 'package:get/get.dart';
import '../controllers/splash_controller.dart';
import '../controllers/login_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/record_controller.dart';
import '../services/api_service.dart';
import '../utils/storage_service.dart';
import '../providers/static_timer_provider.dart';
import '../providers/time_based_timer_provider.dart';
import '../providers/breath_based_timer_provider.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // 서비스들
    Get.put<StorageService>(StorageService(), permanent: true);
    Get.put<ApiService>(ApiService(), permanent: true);
    
    // 컨트롤러들
    Get.lazyPut<SplashController>(() => SplashController(), fenix: true);
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(), fenix: true);
    Get.lazyPut<RecordController>(() => RecordController(), fenix: true);
    
    // 타이머 Provider들
    Get.lazyPut<StaticTimerProvider>(() => StaticTimerProvider(), fenix: true);
    Get.lazyPut<TimeBasedTimerProvider>(() => TimeBasedTimerProvider(), fenix: true);
    Get.lazyPut<BreathBasedTimerProvider>(() => BreathBasedTimerProvider(), fenix: true);
  }
}


