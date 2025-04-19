import 'package:finf_app/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
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
    // await Future.delayed(Duration(seconds: 1)); // 로딩 화면용 잠깐 대기

    // final box = await Hive.openBox('auth');
    // final token = box.get('accessToken');

    // if (token != null && token.toString().isNotEmpty) {
    //   Navigator.pushReplacementNamed(context, AppRoutes.main);
    // } else {
    //   Navigator.pushReplacementNamed(context, AppRoutes.login);
    // }
    Navigator.pushReplacementNamed(context, AppRoutes.main);
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
