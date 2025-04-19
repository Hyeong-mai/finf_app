import 'package:finf_app/controller/auth_controller.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart'; // 라우트 정의 파일 경로 확인 후 맞게 수정
import '../../widget/common/app_background.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = AuthController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고나 이미지를 추가할 수 있는 공간

              Expanded(
                child: Center(
                  child: Semantics(
                    textField: false,
                    child: const Text(
                      "FINFRIENDS",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // 로그인 버튼
              ElevatedButton(
                onPressed: () async {
                  final success = await _authController.signInWithKakao();
                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEE500),
                  foregroundColor: const Color(0xFF000000),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(
                      url: 'assets/icons/kakao.svg',
                      size: 24,
                      color: Color(0xFF3C1E1E),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '카카오톡으로 시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final success = await _authController.signInWithApple();
                  if (success && context.mounted) {
                    Navigator.pushReplacementNamed(context, AppRoutes.main);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(
                      url: 'assets/icons/apple.svg',
                      size: 24,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '애플 로그인으로 시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // 추가 버튼이나 링크를 위한 공간
              TextButton(
                onPressed: () {
                  // 회원가입 또는 다른 액션
                },
                child: Center(
                  child: Text(
                    '가입을 진행할 경우, 서비스 약관 및 개인정보 처리방침에 동의한 것으로 간주합니다.',
                    style: AppTextStyles.nav("white"),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              const SizedBox(height: 48), // 하단 여백
            ],
          ),
        ),
      ),
    );
  }
}
