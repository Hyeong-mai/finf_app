import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/common_box.dart';
import 'package:finf_app/widgets/common_icon.dart';
import 'package:finf_app/widgets/common_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_page.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
            appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
      ),
      body: CommonLayout(
        overlayColor: AppTheme.primaryColor,
        overlayOpacity: 0.7,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CommonIcon(
                        iconPath: 'complete.svg',
                        width: 230,
                        height: 230,
                      ),
                      const SizedBox(height: 24),
                      Text('훈련을 완료했어요!', style: AppTextStyles.h1m('white')),
                      const SizedBox(height: 20),
                      Text(
                        '오늘 더 깊은 바다를 향해 조금 더 나아갔어요\n내일도 참여해봐요',
                        style: AppTextStyles.b1r('white'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.offAll(() => const MainPage());
                    },
                    label: const Text(
                      '메인페이지로 돌아기가',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
