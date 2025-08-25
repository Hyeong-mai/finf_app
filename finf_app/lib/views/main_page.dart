import 'package:finf_app/widgets/common_box.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/common_button.dart';
import 'package:finf_app/widgets/common_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../controllers/settings_controller.dart';
import '../services/api_service.dart';
import '../utils/storage_service.dart';
import '../widgets/common_layout.dart';
import 'login_page.dart';
import 'breath_base_record_page.dart';
import 'time_base_record_page.dart';
import 'static_record_page.dart';
import 'record_page.dart';
import 'set_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final LoginController _loginController = Get.find<LoginController>();
  final SettingsController _settingsController = Get.find<SettingsController>();
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();
  
  @override
  void initState() {
    super.initState();
     _loadHighestStaticRecord();
  }
  
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
  
  /// 스테틱 최고 기록 로드
  Future<void> _loadHighestStaticRecord() async {
    try {
      // 사용자 ID 가져오기
      final userId = await _storageService.getUserId();
      // if (userId == null) {
      //   print('사용자 ID를 찾을 수 없습니다.');
      //   return;
      // }
      
      // 최고 기록 API 호출
      final response = await _apiService.getHighestStaticRecord(userId: 1);
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['result'] != null) {
          final record = data['result']['record'] ?? 0;
          _settingsController.setHighestStaticRecord(record);
          print('최고 기록 로드 성공: ${record}초');
        }
      }
    } catch (e) {
      print('최고 기록 로드 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: CommonIcon(iconPath: 'record.svg', width: 24, height: 24),
            onPressed: () => Get.to(() => const RecordPage()),
            tooltip: '기록',
          ),
          IconButton(
            icon: CommonIcon(iconPath: 'setting.svg', width: 24, height: 24),
            onPressed: () => Get.to(() => const SetPage()),
            tooltip: '설정',
          ),
        ],
      ),
      body: CommonLayout(
        overlayColor: Colors.black,
        overlayOpacity: 0,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('CO2 TABLE', style: AppTextStyles.h2m('white')),
                    const SizedBox(height: 16),
                    Text(
                      '스테틱 최고기록에 따라 숨참기 시간이 지정돼요',
                      style: AppTextStyles.b1r('white'),
                    ),
                    const SizedBox(height: 24),
                    CommonBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '스테틱 최고 기록',
                                style: AppTextStyles.b3r('white'),
                              ),

                              Obx(() => Text(
                                _settingsController.highestStaticRecord.value > 0
                                    ? '🔥 ${_formatDuration(_settingsController.highestStaticRecord.value)}'
                                    : '🔥 스테틱 기록을 시작하세요!',
                                style: AppTextStyles.h4m('white'),
                              )),
                            ],
                          ),
                          CommonButton(
                            child: Text(
                              '관리',
                              style: AppTextStyles.b2m('black'),
                            ),
                            onTap: () {
                              Get.to(() => const StaticRecordPage());
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          CommonBox(
                            width: 240,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonIcon(iconPath: 'timeTable.svg'),
                                const SizedBox(height: 24),
                                Text(
                                  '시간 기반 테이블',
                                  style: AppTextStyles.h4m('white'),
                                ),
                                Text(
                                  '15초씩 준비 호흡 시간을 줄여가며 훈련해요',
                                  style: AppTextStyles.b3r('white'),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(height: 46),
                                CommonButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '훈련 시작하기',
                                        style: AppTextStyles.b1m('black'),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Get.to(() => const TimeBaseRecordPage());
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          CommonBox(
                            width: 240,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonIcon(iconPath: 'breathTable.svg'),
                                const SizedBox(height: 24),
                                Text(
                                  '호흡 기반 테이블',
                                  style: AppTextStyles.h4m('white'),
                                ),
                                Text(
                                  '준비 호흡 횟수를 줄여가며 훈련해요',
                                  style: AppTextStyles.b3r('white'),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                                const SizedBox(height: 46),
                                CommonButton(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '훈련 시작하기',
                                        style: AppTextStyles.b1m('black'),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    Get.to(() => const BreathBaseRecordPage());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  ],
                ),
                CommonBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('ad', style: AppTextStyles.b1m('black')),
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
