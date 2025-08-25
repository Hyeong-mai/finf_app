import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/common_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../controllers/login_controller.dart';
import '../providers/timer_provider.dart';
import '../widgets/common_layout.dart';
import '../widgets/show_dialog.dart';
import 'static_record_page.dart';
import 'login_page.dart';
import 'breath_prep_time_setting_page.dart';
import 'user_profile_page.dart';
import 'package:finf_app/theme/app_text_style.dart';

class SetPage extends StatelessWidget {
  const SetPage({super.key});

  /// 시간을 분:초 형식으로 변환하는 헬퍼 메서드
  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0초';
    
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (minutes > 0) {
      return '${minutes}분 ${remainingSeconds}초';
    } else {
      return '${remainingSeconds}초';
    }
  }

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.put(SettingsController());
    final LoginController loginController = Get.find<LoginController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('CO2 TABLE 설정', style: AppTextStyles.h4m('white')),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () async {
            print('뒤로가기 버튼 클릭됨'); // 디버깅용
            final shouldPop = await _showSaveChangesDialog(
              context,
              settingsController,
            );
            print('shouldPop 결과: $shouldPop'); // 디버깅용
            if (shouldPop) {
              print('페이지 나가기 시도'); // 디버깅용
              Navigator.of(context).pop();
            } else {
              print('페이지 나가지 않음'); // 디버깅용
            }
          },
        ),
      ),
      body: CommonLayout(
        overlayColor: AppTheme.primaryColor,
        overlayOpacity: 0,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // 통합 설정 헤더
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 0,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 12),
                        child: Text('통합 설정', style: AppTextStyles.h4m('white')),
                      ),

                      _buildSwitchTile(
                        title: '오디오 카운트다운',
                        value: settingsController.audioCountdown,
                        onChanged: (value) =>
                            settingsController.audioCountdown.value = value,
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '스테틱 기록',
                          style: AppTextStyles.b1r('white'),
                        ),
                        subtitle: Obx(() => Text(
                          settingsController.highestStaticRecord.value > 0
                              ? '최고 기록: ${_formatDuration(settingsController.highestStaticRecord.value)}'
                              : '기록 없음',
                          style: AppTextStyles.b3r('white').copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Obx(() => Text(
                            //   settingsController.highestStaticRecord.value > 0
                            //       ? '${_formatDuration(settingsController.highestStaticRecord.value)}'
                            //       : '',
                            //   style: AppTextStyles.b2m('white'),
                            // )),
                            // const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => const StaticRecordPage());
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                        child: Text('시간 기반 테이블', style: AppTextStyles.h4m('white')),
                      ),
                      // 시간 기반 설정
                      _buildNumberTile(
                        title: '라운드 설정',
                        value: settingsController.timeBasedRounds,
                        onIncrease: () =>
                            settingsController.increaseTimeBasedRounds(),
                        onDecrease: () =>
                            settingsController.decreaseTimeBasedRounds(),
                      ),

                      // _buildNumberTile(
                      //   title: '타이머 시간 (분)',
                      //   value: settingsController.timeBasedMinutes,
                      //   onIncrease: () =>
                      //       settingsController.increaseTimeBasedMinutes(),
                      //   onDecrease: () =>
                      //       settingsController.decreaseTimeBasedMinutes(),
                      // ),

                      // _buildNumberTile(
                      //   title: '타이머 시간 (초)',
                      //   value: settingsController.timeBasedSeconds,
                      //   onIncrease: () =>
                      //       settingsController.increaseTimeBasedSeconds(),
                      //   onDecrease: () =>
                      //       settingsController.decreaseTimeBasedSeconds(),
                      // ),
                      _buildSwitchTile(
                        title: '첫번째 준비호흡 생략',
                        value: settingsController.timeBasedSkipFirstPrep,
                        onChanged: (value) =>
                            settingsController.timeBasedSkipFirstPrep.value =
                                value,
                      ),
                    ],
                  ),
                ),

                Container(
                  height: 20,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                        child: Text('호흡 기반 테이블', style: AppTextStyles.h4m('white')),
                      ),
                      // 호흡 기반 설정
                      _buildNumberTile(
                        title: '라운드 설정',
                        value: settingsController.breathBasedRounds,
                        onIncrease: () =>
                            settingsController.increaseBreathBasedRounds(),
                        onDecrease: () =>
                            settingsController.decreaseBreathBasedRounds(),
                      ),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          '준비호흡 시간 설정',
                          style: AppTextStyles.b1r('white'),
                        ),
                        subtitle: Obx(() => Text(
                          '${settingsController.breathBasedPrepSeconds.value}초 (들숨 ${(settingsController.breathBasedPrepSeconds.value / 2).round()}초, 날숨 ${(settingsController.breathBasedPrepSeconds.value / 2).round()}초)',
                          style: AppTextStyles.b3r('white').copyWith(
                            color: Colors.white.withOpacity(0.7),
                          ),
                        )),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() => Text(
                              '${settingsController.breathBasedPrepSeconds.value}초',
                              style: AppTextStyles.b2m('white'),
                            )),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 16,
                            ),
                          ],
                        ),
                        onTap: () {
                          Get.to(() => const BreathPrepTimeSettingPage());
                        },
                      ),

                      _buildSwitchTile(
                        title: '준비호흡 생략',
                        value: settingsController.breathBasedSkipPrep,
                        onChanged: (value) =>
                            settingsController.breathBasedSkipPrep.value =
                                value,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 20,
                  color: AppTheme.primaryColor.withOpacity(0.7),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                     left: 24,
                    right: 24,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('회원정보', style: AppTextStyles.b1r('white')),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                        onTap: () {
                          Get.to(() => const UserProfilePage());
                        },
                      ),
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

  /// 변경사항 저장 확인 다이얼로그
  Future<bool> _showSaveChangesDialog(
    BuildContext context,
    SettingsController settingsController,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShowDialog(
          title: '변경사항 저장',
          content: '설정을 변경했습니다. 저장하시겠습니까?',
          leftButtonText: '저장하지 않음',
          rightButtonText: '저장',
          onLeftButtonPressed: () => Navigator.of(context).pop(false),
          onRightButtonPressed: () async {
            await settingsController.saveSettings();
            Navigator.of(context).pop(true);
          },
        );
      },
    );

    print('다이얼로그 결과: $result'); // 디버깅용
    return result ?? false;
  }

  Widget _buildSectionCard({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [Text(title)]),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required RxBool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Obx(
      () => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: AppTextStyles.b1r('white')),
        trailing: Switch(
          value: value.value,
          onChanged: onChanged,
          activeColor: const Color(0xFF52B6EC),
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withOpacity(0.3),
          overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
        ),
      ),
    );
  }

  Widget _buildNumberTile({
    required String title,
    required RxInt value,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Obx(
      () => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: AppTextStyles.b1r('white')),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrease,
              icon: const Icon(Icons.remove, color: Colors.white),
            ),
            Text(value.toString(), style: AppTextStyles.b1r('white')),
            IconButton(
              onPressed: onIncrease,
              icon: const Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
