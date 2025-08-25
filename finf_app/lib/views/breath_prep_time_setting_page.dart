import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../providers/timer_provider.dart';
import '../widgets/common_layout.dart';

class BreathPrepTimeSettingPage extends StatelessWidget {
  const BreathPrepTimeSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController =
        Get.find<SettingsController>();

    // 선택 가능한 준비호흡 시간 옵션들
    const List<int> prepTimeOptions = [3, 6, 9, 12, 15];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('준비호흡 시간 설정', style: AppTextStyles.h4m('white')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => {
             settingsController.saveSettings(),
             Get.back(),
          }
        ),
      ),
      body: CommonLayout(
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 시간 옵션 선택
                Container(
                  width: double.infinity,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '들숨과 날숨을 합한 초 수를 선택해요',
                        style: AppTextStyles.b1r('white'),
                      ),
                      const SizedBox(height: 16),

                      // 라디오 버튼들
                      ...prepTimeOptions.map((seconds) {
                        return Obx(
                          () => RadioListTile<int>(
                            value: seconds,
                            groupValue:
                                settingsController.breathBasedPrepSeconds.value,
                            onChanged: (value) {
                              if (value != null) {
                                settingsController
                                        .breathBasedPrepSeconds
                                        .value =
                                    value;
                              }
                            },
                            title: Text(
                              '${seconds}초',
                              style: AppTextStyles.b1r('white'),
                            ),
                            subtitle: Text(
                              '(들숨 ${(seconds / 2).round()}초, 날숨 ${(seconds / 2).round()}초)',
                              style: AppTextStyles.b3r('white').copyWith(
                                color: AppTheme.buttonTextColor.withOpacity(0.5),
                              ),
                            ),
                            fillColor: WidgetStateProperty.all(
                              AppTheme.buttonColor,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                          ),
                        );
                      }).toList(),
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
}
