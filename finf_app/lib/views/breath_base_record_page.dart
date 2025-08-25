import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/common_box.dart';
import 'package:finf_app/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/common_timer.dart';
import '../providers/breath_based_timer_provider.dart';
import '../controllers/settings_controller.dart';
import '../providers/timer_provider.dart';
import '../widgets/common_layout.dart';

class BreathBaseRecordPage extends StatefulWidget {
  const BreathBaseRecordPage({super.key});

  @override
  State<BreathBaseRecordPage> createState() => _BreathBaseRecordPageState();
}

class _BreathBaseRecordPageState extends State<BreathBaseRecordPage> {
  bool _showTimer = false;
  late BreathBasedTimerProvider timerProvider;
  late SettingsController settingsController;

  @override
  void initState() {
    super.initState();
    timerProvider = Get.find<BreathBasedTimerProvider>();
    settingsController = Get.find<SettingsController>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showTimer) {
          // 타이머 페이지를 떠날 때 항상 확인 다이얼로그 표시
          final shouldPop = await _showExitConfirmationDialog(context);
          if (shouldPop) {
            // 타이머 초기화
            timerProvider.reset();
            setState(() {
              _showTimer = false;
            });
            Get.snackbar(
              '기록 초기화',
              '페이지를 떠나면서 기록이 초기화되었습니다.',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
          return shouldPop;
        }
        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            '호흡 기반 테이블' ,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: _showTimer
              ? IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () async {
                    // 타이머 페이지를 떠날 때 확인 다이얼로그 표시
                    final shouldPop = await _showExitConfirmationDialog(
                      context,
                    );
                    if (shouldPop) {
                      // 타이머 초기화
                      timerProvider.reset();
                      setState(() {
                        _showTimer = false;
                      });
                      Get.snackbar(
                        '기록 초기화',
                        '페이지를 떠나면서 기록이 초기화되었습니다.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        duration: const Duration(seconds: 3),
                      );
                    }
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                ),
        ),
        body: CommonLayout(
          child: SafeArea(
            child: _showTimer ? _buildTimerPage() : _buildPreviewPage(),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewPage() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                CommonBox(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '순서',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.b3r('white'),
                              ),
                            ),
                            if (true)
                              Expanded(
                                child: Text(
                                  '준비 호흡',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.b3r('white'),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                '숨 참기',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.b3r('white'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            ...List.generate(
                              settingsController.breathBasedRounds.value,
                              (index) {
                                final round = index + 1;
                                final prepTime = settingsController
                                    .breathBasedPrepSeconds
                                    .value;
                                final staticTime = settingsController
                                    .getStaticRecordFinalSeconds();
                                final breathCount =
                                    TimerUtils.calculateBreathCount(
                                      prepTime,
                                      round,
                                    );

                                final isFirstRound = round == 1;
                                final skipFirstPrep = settingsController
                                    .breathBasedSkipPrep
                                    .value;
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                        width: 1,
                                        color: AppTheme.primaryColor
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '$round',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.b1r('white'),
                                        ),
                                      ),
                                      if (isFirstRound && skipFirstPrep)
                                        Expanded(
                                          child: Text(
                                            '생략',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.b1r('gray'),
                                          ),
                                        )
                                      else
                                        Expanded(
                                          child: Text(
                                            '${breathCount}회',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyles.b1r('white'),
                                          ),
                                        ),
                                      Expanded(
                                        child: Text(
                                          '${TimerUtils.formatTime(staticTime)}',
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.b1r('white'),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info, color: Colors.white),
                    Text('총 n분 동안 훈련 진행', style: AppTextStyles.b3r('white')),
                  ],
                ),
                Text(
                  '준비호흡 시간은 설정 또는 여기서 바꿀 수 있어요',
                  style: AppTextStyles.b3r('white'),
                ),
              ],
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // 타이머 시작 전 설정 새로고침
                  timerProvider.refreshSettings();
                  setState(() {
                    _showTimer = true;
                  });
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('기록 시작하기', style: TextStyle(fontSize: 18)),
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
    );
  }

  Widget _buildTimerPage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: GetBuilder<BreathBasedTimerProvider>(
        builder: (controller) {
          return CommonTimer(
                timerProvider: controller,
                title: '호흡기반 타이머',
                themeColor: Colors.red,
                onComplete: () {
                  // 타이머 완료 시 처리
                  Get.snackbar(
                    '운동 완료!',
                    '모든 라운드가 완료되었습니다.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                },
              );
        },
      ),
    );
  }

  /// 페이지 떠나기 확인 다이얼로그
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ShowDialog(
              title: '기록 초기화',
              content: '이 페이지를 떠나면 현재 진행 중인 타이머와 기록이 모두 초기화됩니다.\n정말로 떠나시겠습니까?',
              leftButtonText: '취소',
              rightButtonText: '떠나기',
              onLeftButtonPressed: () => Navigator.of(context).pop(false),
              onRightButtonPressed: () => Navigator.of(context).pop(true),
            );
          },
        ) ??
        false;
  }
}
