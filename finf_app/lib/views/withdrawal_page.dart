import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_text_style.dart';
import '../theme/theme.dart';
import '../widgets/common_layout.dart';

class WithdrawalPage extends StatefulWidget {
  const WithdrawalPage({super.key});

  @override
  State<WithdrawalPage> createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  String? _selectedReason;
  final TextEditingController _otherReasonController = TextEditingController();
  
  final List<String> _withdrawalReasons = [
    '잘 사용하지 않게 되었어요',
    '서비스 속도 저하 및 오류가 있어요',
    '유용하지 않아요',
    '아이디 변경 후 재가입',
    '기타',
  ];

  @override
  void dispose() {
    _otherReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('회원 탈퇴', style: AppTextStyles.h4m('white')),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text('핀프렌즈를 떠나실 건가요?', style: AppTextStyles.h2m('white')),
                  const SizedBox(height: 16),
                                 Text('핀프렌즈에게 부족한 점을 알려주세요', style: AppTextStyles.b1m('white')),
                     const SizedBox(height: 24),
                     
                                      // 탈퇴 사유 라디오 버튼
                 _buildRadioButtonList(),
                 
                 // 기타 선택 시 텍스트 박스
                 if (_selectedReason == '기타') ...[
                   const SizedBox(height: 20),
                   Container(
                     width: double.infinity,
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                     decoration: BoxDecoration(
                       color: Colors.white.withOpacity(0.1),
                       borderRadius: BorderRadius.circular(12),
                       border: Border.all(color: Colors.white.withOpacity(0.3)),
                     ),
                     child: TextField(
                       controller: _otherReasonController,
                       style: AppTextStyles.b1r('white'),
                       decoration: InputDecoration(
                         hintText: '탈퇴 사유를 자유롭게 작성해주세요',
                         hintStyle: AppTextStyles.b1r('white').copyWith(
                           color: Colors.white.withOpacity(0.6),
                         ),
                         border: InputBorder.none,
                         contentPadding: EdgeInsets.zero,
                       ),
                       maxLines: 3,
                       maxLength: 200,
                     ),
                   ),
                 ],
                 
                 const SizedBox(height: 32),
                 
                    
                  ],
                ),
                                  // 탈퇴 버튼
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     onPressed: _canProceedWithdrawal() ? () => _showWithdrawalDialog(context) : null,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: _canProceedWithdrawal() ? AppTheme.buttonColor : Colors.grey,
                       foregroundColor: Colors.white,
                       padding: const EdgeInsets.symmetric(vertical: 16),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                     child: Text('회원 탈퇴하기', style: AppTextStyles.b1b('white')),
                   ),
                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

 

  Widget _buildRadioButtonList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _withdrawalReasons.map((reason) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            children: [
              Radio<String>(
                value: reason,
                groupValue: _selectedReason,
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                    // 기타가 아닌 다른 옵션 선택 시 텍스트 컨트롤러 초기화
                    if (value != '기타') {
                      _otherReasonController.clear();
                    }
                  });
                },
                activeColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(MaterialState.selected)) {
                      return Colors.white;
                    }
                    return Colors.white.withOpacity(0.5);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  reason,
                  style: AppTextStyles.b1r('white'),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  bool _canProceedWithdrawal() {
    if (_selectedReason == null) return false;
    if (_selectedReason == '기타' && _otherReasonController.text.trim().isEmpty) return false;
    return true;
  }

  void _showWithdrawalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            '정말 탈퇴하시겠습니까?',
            style: AppTextStyles.h4b('black'),
            textAlign: TextAlign.center,
          ),
          content: Text(
            '탈퇴 시 모든 데이터가 삭제되며 복구할 수 없습니다.\n\n'
            '정말 탈퇴를 진행하시겠습니까?',
            style: AppTextStyles.b1r('black'),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소', style: AppTextStyles.b1m('grey')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processWithdrawal();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('탈퇴', style: AppTextStyles.b1b('white')),
            ),
          ],
        );
      },
    );
  }

  void _processWithdrawal() {
    // TODO: 실제 탈퇴 처리 로직 구현
    Get.snackbar(
      '탈퇴 처리 중',
      '회원 탈퇴가 진행되고 있습니다...',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );

    // 2초 후 탈퇴 완료 처리
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login'); // 로그인 페이지로 이동
      Get.snackbar(
        '탈퇴 완료',
        '회원 탈퇴가 완료되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    });
  }
}
