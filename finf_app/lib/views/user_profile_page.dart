import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widgets/common_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import '../widgets/common_layout.dart';
import 'withdrawal_page.dart';


class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {


    
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title:  Text('회원 정보', style: AppTextStyles.h4m('white')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: CommonLayout(
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // 로그인 방법 아이콘
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _getLoginMethodColor(),
                        borderRadius: BorderRadius.circular(52),
                      ),
                      child: Center(
                        child: _getLoginMethodIcon(),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // 계정 이메일
                    Text(
                      'user@example.com', // 실제 사용자 이메일로 교체 필요
                      style: AppTextStyles.b1m('white'),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // 가입 일자
                    Text(
                      '가입 일자: 2024년 2월 10일', // 실제 가입일로 교체 필요
                      style: AppTextStyles.b3r('white'),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
                                 Column(
                   children: [
                     RichText(
                       text: TextSpan(
                         text: '회원 탈퇴하기',
                         style: AppTextStyles.b3r('white').copyWith(decoration: TextDecoration.underline),  
                                                   recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(() => const WithdrawalPage());
                            },
                       ),
                     ),
                   ],
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 로그인 방법에 따른 아이콘 반환
  Widget _getLoginMethodIcon() {
    // TODO: 실제 로그인 방법을 확인하는 로직으로 교체 필요
    String loginMethod = 'apple'; // 임시로 카카오로 설정
    
    switch (loginMethod) {
      case 'kakao':
        return CommonIcon(iconPath: 'kakao.svg', width: 28, height: 28);
      case 'apple':
        return CommonIcon(iconPath: 'apple.svg', width: 28, height: 28);
      default:
        return Icon(Icons.person, size: 19, color: Colors.white);
    }
  }

  // 로그인 방법에 따른 아이콘 색상 반환
  Color _getLoginMethodColor() {
    // TODO: 실제 로그인 방법을 확인하는 로직으로 교체 필요
    String loginMethod = 'apple'; // 임시로 카카오로 설정
    
    switch (loginMethod) {
      case 'kakao':
        return const Color(0xFFFEE500); // 카카오 노란색
      case 'apple':
        return Colors.black; // 애플 검은색
      default:
        return Colors.grey; // 기본 회색
    }
  }
}
