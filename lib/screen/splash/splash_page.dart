import 'package:finf_app/core/routes/app_routes.dart';
import 'package:finf_app/core/binding/auth_binding.dart';
import 'package:finf_app/core/binding/main_binding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart'; // 또는 shared_preferences 사용 가능

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    await Future.delayed(const Duration(seconds: 1)); // 로딩 화면용 잠깐 대기

    final box = await Hive.openBox('auth');

    // 테스트용 임의 토큰 주입
    await box.put('accessToken', 'test_token_123456');
    await box.put('refreshToken', 'test_refresh_token_123456');

    final token = box.get('accessToken');

    if (token != null && token.toString().isNotEmpty) {
      final mainBinding = MainBinding();
      mainBinding.dependencies();
      Get.offAllNamed(AppRoutes.main);
    } else {
      final authBinding = AuthBinding();
      authBinding.dependencies();
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("data"), // 로딩 표시
      ),
    );
  }
}
