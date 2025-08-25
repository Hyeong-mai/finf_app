import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../views/login_page.dart';

class SplashController extends GetxController {
  final RxBool isInitialized = false.obs;

  @override
  void onReady() {
    super.onReady();
    _initializeAndRoute();
  }

  Future<void> _initializeAndRoute() async {
    await _initializeCore();
    isInitialized.value = true;

    Get.offAll(() => const LoginPage());
  }

  Future<void> _initializeCore() async {
    await _initHive();
    await Future.delayed(const Duration(milliseconds: 3000));
  }

  Future<void> _initHive() async {
    try {
      await Hive.initFlutter();
    } catch (_) {}

    await _openBoxSafely('app');
  }

  Future<void> _openBoxSafely(String name) async {
    if (!Hive.isBoxOpen(name)) {
      try {
        await Hive.openBox(name);
      } catch (_) {}
    }
  }
}


