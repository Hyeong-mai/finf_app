import 'package:finf_app/controller/auth_controller.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart'; // 라우트 정의 파일 경로 확인 후 맞게 수정
import '../../widget/common/app_background.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

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

              // 카카오 로그인 버튼
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final success = await controller.signInWithKakao();
                            if (success) {
                              Get.offAllNamed(AppRoutes.main);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SvgIcon(
                          url: 'assets/icons/kakao.svg',
                          size: 24,
                          color: Color(0xFF3C1E1E),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isLoading.value
                              ? '로그인 중...'
                              : '카카오톡으로 시작하기',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 12),

              // 애플 로그인 버튼
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            final success = await controller.signInWithApple();
                            if (success) {
                              Get.offAllNamed(AppRoutes.main);
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SvgIcon(
                          url: 'assets/icons/apple.svg',
                          size: 24,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.isLoading.value
                              ? '로그인 중...'
                              : '애플 로그인으로 시작하기',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),

              const SizedBox(height: 16),

              // 에러 메시지 표시
              // Obx(() => controller.errorMessage.value.isNotEmpty
              //     ? Padding(
              //         padding: const EdgeInsets.only(bottom: 16),
              //         child: Text(
              //           controller.errorMessage.value,
              //           style: const TextStyle(
              //             color: Colors.red,
              //             fontSize: 14,
              //           ),
              //           textAlign: TextAlign.center,
              //         ),
              //       )
              //     : const SizedBox.shrink()),

              // 약관 동의 텍스트
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
