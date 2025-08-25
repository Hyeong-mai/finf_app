import 'dart:async';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/common_icon.dart';
import 'package:finf_app/widgets/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'timer_provider.dart';
import '../services/api_service.dart';
import '../controllers/settings_controller.dart';

class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // 배경 원 그리기
    final backgroundPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // 프로그레스 원 그리기
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -90 * (3.14159 / 180), // 시작점을 12시 방향으로
      progress * 2 * 3.14159, // 진행률에 따라 호 그리기
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class StaticTimerProvider extends TimerProvider {
  Timer? _timer;
  int _currentSeconds = 0;
  TimerState _currentState = TimerState.idle;

  // 선택된 분, 초
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  // 타이머 데이터
  int get currentSeconds => _currentSeconds;
  String get displayTime => TimerUtils.formatTime(_currentSeconds);

  // 선택된 분, 초
  int get selectedMinutes => _selectedMinutes;
  int get selectedSeconds => _selectedSeconds;

  @override
  TimerState get currentState => _currentState;

  @override
  void start() {
    if (_currentState == TimerState.running) return;

    _currentState = TimerState.running;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentSeconds++;
      update();
    });

    update();
  }

  @override
  void pause() {
    if (_currentState != TimerState.running) return;

    _currentState = TimerState.paused;
    _timer?.cancel();
    _timer = null;

    update();
  }

  @override
  void resume() {
    if (_currentState != TimerState.paused) return;

    start();
  }

  @override
  void stop() {
    stopWithType('default');
  }

  void stopWithType(String type) {
    // 확인 다이얼로그 표시
    Get.dialog(
      ShowDialog(
          title: '기록 측정 종료',
          content: type == 'selected' ? '선택한 시간 기록을 종료하시겠습니까?' : '타이머 기록을 종료하시겠습니까?',
          leftButtonText: '취소',
          rightButtonText: '종료',
          onLeftButtonPressed: () => Get.back(),
          onRightButtonPressed: () async {
            _performStop(type);
          },
      ),
    );
  }

  // 실제 stop 로직을 수행하는 private 메서드
  void _performStop(String type) {
    _currentState = TimerState.completed;
    _timer?.cancel();
    _timer = null;

    // 기록 완료 데이터를 서버로 전송
    _sendRecordToServer(type);

    // 완료 콜백 호출
    onComplete?.call();

    update();
  }

  /// 기록 완료 데이터를 서버로 전송
  Future<void> _sendRecordToServer(String type) async {

    try {
      final apiService = Get.find<ApiService>();

      // type에 따라 다른 데이터 전송
      int baseTimeSeconds;
      if (type == 'selected') {
        // 선택한 시간을 초로 변환
        baseTimeSeconds = (_selectedMinutes * 60) + _selectedSeconds;
      } else {
        // 타이머 기록된 시간
        baseTimeSeconds = _currentSeconds;
      }

      await apiService.sendStaticRecord(
       record: baseTimeSeconds,
      );

      Get.snackbar(
        '기록 전송 완료',
        '스테틱 기록이 서버에 저장되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('기록 전송 실패: $e');
      Get.snackbar(
        '기록 전송 실패',
        '스테틱 기록 전송 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  void reset() {
    _currentState = TimerState.idle;
    _currentSeconds = 0;
    _timer?.cancel();
    _timer = null;

    update();
  }

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// 설정 로드
  void _loadSettings() {
    try {
      final settingsController = Get.find<SettingsController>();
      // 설정이 변경될 때마다 업데이트
      ever(settingsController.staticRecordUseTimer, (_) => update());
      ever(settingsController.staticRecordSeconds, (_) => update());
      ever(settingsController.staticRecordMinutes, (_) => update());
      ever(settingsController.staticRecordDirectSeconds, (_) => update());

      // 무조건 0분 0초로 초기화
      _selectedMinutes = 0;
      _selectedSeconds = 0;
    } catch (e) {
      print('설정 로드 실패: $e');
      // 기본값 사용
      _selectedMinutes = 2;
      _selectedSeconds = 0;
    }
  }

  /// 설정에 따른 목표 시간 가져오기
  int getTargetTime() {
    try {
      final settingsController = Get.find<SettingsController>();
      return settingsController.getStaticRecordFinalSeconds();
    } catch (e) {
      print('목표 시간 가져오기 실패: $e');
      return 120; // 기본값 2분
    }
  }

  /// 설정에 따른 목표 시간 텍스트
  String getTargetTimeText() {
    try {
      final settingsController = Get.find<SettingsController>();
      if (settingsController.staticRecordUseTimer.value) {
        return '목표: ${TimerUtils.formatTime(settingsController.staticRecordSeconds.value)}';
      } else {
        return '목표: ${TimerUtils.formatTime(settingsController.getStaticRecordDirectTotalSeconds())}';
      }
    } catch (e) {
      return '목표: 2:00';
    }
  }

  @override
  Widget buildCustomUI() {
    return Column(
      children: [
        // 현재 시간 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonIcon(iconPath: 'time.svg', width: 24, height: 24),
            const SizedBox(width: 8),
            Text("기록 직접 입력", style: AppTextStyles.b2m('white')),
          ],
        ),

        const SizedBox(height: 16),

        // 분, 초 선택 박스
        GestureDetector(
          onTap: () => _showTimePicker(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    _selectedMinutes > 0 || _selectedSeconds > 0
                        ? '${_selectedMinutes.toString().padLeft(2, '0')} 분 ${_selectedSeconds.toString().padLeft(2, '0')} 초'
                        : '기록 직접 입력하기',
                    style: AppTextStyles.b1r('white'),
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _selectedMinutes > 0 || _selectedSeconds > 0
                      ? () => stopWithType('selected')
                      : null,
                  icon: _selectedMinutes > 0 || _selectedSeconds > 0
                      ? null
                      : const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                  label: _selectedMinutes > 0 || _selectedSeconds > 0
                      ? const Text('완료')
                      : const Text(''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 82),
        Stack(
          alignment: Alignment.center,
          children: [
            // 배경 원
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 14,
                ),
              ),
            ),
            // 프로그레스 원
            SizedBox(
              width: 300,
              height: 300,
              child: CustomPaint(
                painter: CircularProgressPainter(
                  progress: _currentState == TimerState.running
                      ? _currentSeconds / 300.0
                      : 0.0, // 5분(300초) 기준
                  color: Colors.white,
                  strokeWidth: 14,
                ),
              ),
            ),
            // 중앙 콘텐츠
            Column(
              children: [
                Text('새로운 기록 시작', style: AppTextStyles.h3r('white')),
                const SizedBox(height: 8),
                Text(
                  displayTime,
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 제어 버튼들
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (_currentState == TimerState.idle ||
                _currentState == TimerState.paused)
              ElevatedButton(
                onPressed: _currentState == TimerState.paused ? resume : start,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(18),
                ),
                child: _currentState == TimerState.paused
                    ? CommonIcon(iconPath: 'play.svg', width: 32, height: 32)
                    : CommonIcon(iconPath: 'play.svg', width: 32, height: 32),
              ),

            if (_currentState == TimerState.running)
              ElevatedButton(
                onPressed: pause,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(18),
                ),
                child: CommonIcon(iconPath: 'pause.svg', width: 32, height: 32),
              ),

            if (_currentState == TimerState.running ||
                _currentState == TimerState.paused)
              ElevatedButton(
                onPressed: () => stopWithType('timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(18),
                ),
                child: CommonIcon(iconPath: 'stop.svg', width: 32, height: 32),
              ),

            ElevatedButton(
              onPressed: reset,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(18),
              ),
              child: CommonIcon(iconPath: 'stop.svg', width: 32, height: 32),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // 우측 추가 완료 버튼
      ],
    );
  }

  @override
  Map<String, dynamic> getTimerData() {
    return {
      'type': 'static',
      'currentSeconds': _currentSeconds,
      'displayTime': displayTime,
      'selectedMinutes': _selectedMinutes,
      'selectedSeconds': _selectedSeconds,
      'state': _currentState.name,
      'isCompleted': _currentState == TimerState.completed,
    };
  }

  /// 시간 선택 픽커 표시 (분+초 통합)
  void _showTimePicker() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: AppTheme.primaryColor,
          child: Column(
            children: [
              // 헤더
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  border: Border(
                    bottom: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: Text('취소', style: AppTextStyles.b1m('white')),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    Text('시간 선택', style: AppTextStyles.b1m('white')),
                    CupertinoButton(
                      child: Text('확인', style: AppTextStyles.b1m('white')),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              // 분, 초 픽커
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      // 분 선택
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 50,
                          onSelectedItemChanged: (int index) {
                            _selectedMinutes = index;
                            update();
                          },
                          children: List.generate(61, (index) => index).map((
                            minutes,
                          ) {
                            return Center(
                              child: Text(
                                '$minutes',
                                style: AppTextStyles.b1m('white'),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Text('분', style: AppTextStyles.b1m('white')),
                      const SizedBox(width: 20),
                      // 초 선택
                      Expanded(
                        child: CupertinoPicker(
                          itemExtent: 50,
                          onSelectedItemChanged: (int index) {
                            _selectedSeconds = index;
                            update();
                          },
                          children: List.generate(60, (index) => index).map((
                            seconds,
                          ) {
                            return Center(
                              child: Text(
                                '$seconds',
                                style: AppTextStyles.b1m('white'),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Text('초', style: AppTextStyles.b1m('white')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    // 페이지 나갈 때 선택된 분, 초 초기화
    _selectedMinutes = 0;
    _selectedSeconds = 0;
    super.dispose();
  }
}
