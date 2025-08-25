import 'package:finf_app/widgets/common_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/common_layout.dart';
import 'terms_of_service_page.dart';
import 'privacy_policy_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // LoginController 초기화
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CommonLayout(
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset('assets/images/logo.png', width: 240),
                ),

                // 카카오 로그인 버튼
                _buildKakaoLoginButton(controller),
                const SizedBox(height: 16),

                // Apple 로그인 버튼
                _buildAppleLoginButton(controller),

                const SizedBox(height: 40),

                // 약관 동의 텍스트
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                    children: [
                      const TextSpan(text: '가입을 진행할 경우, '),
                      TextSpan(
                        text: '서비스 약관',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const TermsOfServicePage());
                          },
                      ),
                      const TextSpan(text: ' 및 '),
                      TextSpan(
                        text: '개인정보 처리방침',
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.to(() => const PrivacyPolicyPage());
                          },
                      ),
                      const TextSpan(text: '에 \n동의한 것으로 간주합니다.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKakaoLoginButton(LoginController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isKakaoLoading.value
              ? null
              : () => controller.handleKakaoLogin(),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEE500),
            foregroundColor: const Color(0xFF191919),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isKakaoLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF191919),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonIcon(iconPath: 'kakao.svg', width: 19, height: 19),
                    const SizedBox(width: 12),
                    const Text(
                      '카카오로 시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildAppleLoginButton(LoginController controller) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: controller.isAppleLoading.value
              ? null
              : () => controller.handleAppleLogin(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: controller.isAppleLoading.value
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonIcon(iconPath: 'apple.svg', width: 19, height: 19),
                    const SizedBox(width: 12),
                    const Text(
                      'Apple로 시작하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
