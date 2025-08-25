import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/common_timer.dart';
import '../providers/static_timer_provider.dart';
import '../widgets/common_layout.dart';

class StaticRecordPage extends StatelessWidget {
  const StaticRecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final StaticTimerProvider timerProvider = Get.find<StaticTimerProvider>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('스테틱 기록', style: AppTextStyles.h4m('white')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () async {
            // 타이머가 실행 중이거나 일시정지 상태일 때만 확인 다이얼로그 표시
            if (timerProvider.isRunning || timerProvider.isPaused) {
              final shouldPop = await _showExitConfirmationDialog(context);
              print('leading에서 받은 값: $shouldPop');
              if (shouldPop == true) {
                print('페이지 나가기 실행');
                // 타이머 초기화
                timerProvider.reset();
                // 스낵바 표시
                 Get.back();
                 
                Get.snackbar(
                  '기록 초기화',
                  '페이지를 떠나면서 기록이 초기화되었습니다.',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
                // 페이지 나가기
                Get.back();
              }
            } else {
              Get.back();
            }
          },
        ),
      ),
      body: CommonLayout(
        overlayColor: AppTheme.primaryColor,
        overlayOpacity: 0,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: GetBuilder<StaticTimerProvider>(
              builder: (controller) {
                return CommonTimer(
                  timerProvider: controller,
                  title: '스테틱 타이머',
                  themeColor: Colors.white,
                  onComplete: () {
                    // 타이머 완료 시 처리
                    Get.snackbar(
                      '기록 완료!',
                      '스테틱 기록이 완료되었습니다.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.purple,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 페이지 떠나기 확인 다이얼로그
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ShowDialog(
              title: '기록 초기화',
              content: '페이지를 떠나면 현재 기록이 초기화됩니다.\n정말로 떠나시겠습니까?',
              leftButtonText: '취소',
              rightButtonText: '떠나기',
              onLeftButtonPressed: () {
                print('취소');
                Navigator.of(context).pop(false);
              },
              onRightButtonPressed: () {
                // 다이얼로그 닫기
                print('떠나기');
                Navigator.of(context).pop(true);
              },
            );
          },
        ) ??
        false;
    
    print('다이얼로그 결과: $result');
    return result;
  }
}
