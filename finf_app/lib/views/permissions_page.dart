import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_text_style.dart';
import '../theme/theme.dart';
import '../widgets/common_layout.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('권한 설정', style: AppTextStyles.h4m('white')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Get.back(),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '앱 권한 안내',
                    style: AppTextStyles.h3m('white'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'FinF 앱이 정상적으로 작동하기 위해 필요한 권한들을 안내드립니다.',
                    style: AppTextStyles.b2r('white'),
                  ),
                  const SizedBox(height: 30),
                  
                  // 마이크 권한
                  _buildPermissionCard(
                    icon: Icons.mic,
                    title: '마이크 권한',
                    description: '호흡 소리를 감지하여 명상 타이머를 제어하기 위해 필요합니다.',
                    isRequired: true,
                    onRequestPermission: () {
                      // 마이크 권한 요청 로직
                      Get.snackbar(
                        '권한 요청',
                        '마이크 권한을 요청합니다.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 알림 권한
                  _buildPermissionCard(
                    icon: Icons.notifications,
                    title: '알림 권한',
                    description: '명상 완료 시 알림을 받기 위해 필요합니다.',
                    isRequired: false,
                    onRequestPermission: () {
                      // 알림 권한 요청 로직
                      Get.snackbar(
                        '권한 요청',
                        '알림 권한을 요청합니다.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // 저장소 권한
                  _buildPermissionCard(
                    icon: Icons.storage,
                    title: '저장소 권한',
                    description: '명상 기록과 설정을 저장하기 위해 필요합니다.',
                    isRequired: true,
                    onRequestPermission: () {
                      // 저장소 권한 요청 로직
                      Get.snackbar(
                        '권한 요청',
                        '저장소 권한을 요청합니다.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.blue,
                        colorText: Colors.white,
                      );
                    },
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // 권한 설정 안내
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppTheme.primaryColor,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '권한 설정 방법',
                              style: AppTextStyles.h4m('white'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '1. 설정 > 앱 > FinF > 권한으로 이동\n'
                          '2. 필요한 권한을 허용으로 설정\n'
                          '3. 앱을 다시 실행하여 권한 적용 확인',
                          style: AppTextStyles.b2r('white'),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // 모든 권한 허용 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // 모든 권한 요청 로직
                        Get.snackbar(
                          '권한 요청',
                          '모든 필요한 권한을 요청합니다.',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: AppTheme.primaryColor,
                          colorText: Colors.white,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        '모든 권한 허용',
                        style: AppTextStyles.b1m('white'),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isRequired,
    required VoidCallback onRequestPermission,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h4m('white'),
                    ),
                    if (isRequired)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '필수',
                          style: AppTextStyles.b3m('white'),
                        ),
                      ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onRequestPermission,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.buttonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '권한 요청',
                  style: AppTextStyles.b3m('white'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: AppTextStyles.b2r('white'),
          ),
        ],
      ),
    );
  }
}

