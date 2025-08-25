import 'dart:async';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:finf_app/widgets/common_box.dart';
import 'package:finf_app/widgets/common_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'timer_provider.dart';
import '../controllers/settings_controller.dart';
import '../services/api_service.dart';
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;
  final double animationValue;

  CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.animationValue = 1.0,
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

    // 프로그레스 원 그리기 (애니메이션 적용)
    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final rect = Rect.fromCircle(center: center, radius: radius);
    
    // 애니메이션 값을 적용한 부드러운 프로그레스
    final animatedProgress = progress * animationValue;
    canvas.drawArc(
      rect,
      -90 * (3.14159 / 180), // 시작점을 12시 방향으로
      animatedProgress * 2 * 3.14159, // 애니메이션 적용된 진행률
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.color != color || 
           oldDelegate.animationValue != animationValue;
  }
}

class TimeBasedTimerProvider extends TimerProvider {
  Timer? _timer;
  TimerState _currentState = TimerState.idle;
  
  // 애니메이션을 위한 변수
  double _animationValue = 0.0;
  Timer? _animationTimer;

  @override
  void onInit() {
    super.onInit();
    print('TimeBasedTimerProvider onInit 시작');
    _loadSettings();
    print(
      'TimeBasedTimerProvider onInit 완료: 라운드=$_totalRounds, 기준시간=$_baseTimeSeconds초',
    );
  }

  /// 설정 로드
  void _loadSettings() {
    try {
      final settingsController = Get.find<SettingsController>();
      _totalRounds = settingsController.timeBasedRounds.value;
      
      // 서버에서 가져온 최고 기록을 기준 시간으로 사용
      _baseTimeSeconds = settingsController.getStaticRecordFinalSeconds();
      
      // 준비호흡 시간은 설정에서 가져오기 (라운드별로 감소)
      _prepTimeSeconds = (120 - (1 - 1) * 15).clamp(30, 120);
      
      print('설정 로드 성공: 라운드=$_totalRounds, 기준시간=$_baseTimeSeconds초 (서버 최고 기록 기준)');
    } catch (e) {
      print('설정 로드 실패: $e');
      // 기본값 사용
      _totalRounds = 3;
      _baseTimeSeconds = 120; // 2분
      _prepTimeSeconds = 120;
    }
  }

  // 설정값들
  int _totalRounds = 8; // 최대 8라운드
  int _baseTimeSeconds = Get.find<SettingsController>().getStaticRecordFinalSeconds(); // 기준 스테틱 시간 (2분)
  int _prepTimeSeconds = 120; // 준비호흡 시간 (2분부터 시작)
  
  // 밀리초 단위 진행률을 위한 변수
  double _currentPhaseProgress = 0.0; // 밀리초 단위 진행률 (0.0 ~ 1.0)
  


  // 현재 상태
  int _currentRound = 1;
  int _remainingSeconds = 0;
  int _totalElapsedSeconds = 0;
  bool _isPrepPhase = true; // true: 준비호흡, false: 숨참기

  // 타이머 데이터
  int get currentRound => _currentRound;
  int get totalRounds => _totalRounds;
  int get remainingSeconds => _remainingSeconds;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  int get baseTimeSeconds => _baseTimeSeconds;
  int get prepTimeSeconds => _prepTimeSeconds;
  bool get isPrepPhase => _isPrepPhase;
  String get displayTime => TimerUtils.formatTime(_remainingSeconds);
  String get totalDisplayTime => TimerUtils.formatTime(_totalElapsedSeconds);
  String get currentPhaseText => _isPrepPhase ? '준비호흡' : '숨참기';

  // 진행률
  double get roundProgress =>
      TimerUtils.calculateProgress(_currentRound - 1, _totalRounds);
  double get timeProgress => TimerUtils.calculateProgress(
    _isPrepPhase
        ? (_prepTimeSeconds - _remainingSeconds)
        : (_baseTimeSeconds - _remainingSeconds),
    _isPrepPhase ? _prepTimeSeconds : _baseTimeSeconds,
  );

  @override
  TimerState get currentState => _currentState;

  // 설정 업데이트
  void updateSettings({
    int? totalRounds,
    int? baseTimeSeconds,
    int? prepTimeSeconds,
  }) {
    if (totalRounds != null) _totalRounds = totalRounds;
    if (baseTimeSeconds != null) _baseTimeSeconds = baseTimeSeconds;
    if (prepTimeSeconds != null) _prepTimeSeconds = prepTimeSeconds;

    if (_currentState == TimerState.idle) {
      _resetToInitialState();
    }

    update();
  }

  /// 설정 변경 시 호출하여 타이머 상태 업데이트
  void refreshSettings() {
    print('TimeBasedTimerProvider 설정 새로고침 시작');
    _loadSettings();
    if (_currentState == TimerState.idle) {
      _resetToInitialState();
    }
    print(
      'TimeBasedTimerProvider 설정 새로고침 완료: 라운드=$_totalRounds, 기준시간=$_baseTimeSeconds초',
    );
    update();
  }

  @override
  void start() {
    if (_currentState == TimerState.running) return;

    _currentState = TimerState.running;
    _startCountdown();

    update();
  }

  @override
  void stop() {
    _currentState = TimerState.completed;
    _timer?.cancel();
    _timer = null;

    // 기록 완료 데이터를 서버로 전송
    _sendRecordToServer();

    onComplete?.call();
    update();
  }

  /// 기록 완료 데이터를 서버로 전송
  Future<void> _sendRecordToServer() async {
    try {
      print('기록 완료 데이터를 서버로 전송 시작');

      final apiService = Get.find<ApiService>();
      await apiService.sendTimeRecord(
        totalRounds: _totalRounds,
        skipReadyBreathing: _shouldSkipFirstPrep(),
        staticRecord: _totalElapsedSeconds,

      );

      Get.snackbar(
        '기록 전송 완료',
        '운동 기록이 서버에 저장되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('기록 전송 실패: $e');
      Get.snackbar(
        '기록 전송 실패',
        '운동 기록 전송 중 오류가 발생했습니다.',
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
    _resetToInitialState();
    _timer?.cancel();
    _timer = null;

    update();
  }

  void _resetToInitialState() {
    _currentRound = 1;
    _animationValue = 0.0; // 애니메이션 값 초기화
    _currentPhaseProgress = 0.0; // 진행률 초기화

    // 첫 번째 라운드에서 준비호흡 생략 설정이 true인 경우
    if (_shouldSkipFirstPrep()) {
      // 1라운드 준비호흡 생략, 바로 숨참기로
      _isPrepPhase = false;
      _remainingSeconds = _baseTimeSeconds;
      _totalElapsedSeconds = 0;
      print('초기 상태: 1라운드 준비호흡 생략 - 바로 숨참기로');
    } else {
      // 일반적인 경우: 준비호흡으로 시작
      _isPrepPhase = true;
      _prepTimeSeconds = 120; // 준비호흡 시간 초기화
      _remainingSeconds = _prepTimeSeconds;
      _totalElapsedSeconds = 0;
      print('초기 상태: 1라운드 준비호흡으로 시작');
    }
  }

  @override
  void pause() {
    if (_currentState != TimerState.running) return;

    _currentState = TimerState.paused;
    _timer?.cancel();
    _timer = null;
    _animationTimer?.cancel(); // 애니메이션 타이머도 정지
    
    // 현재 진행 상태는 보존 (초기화하지 않음)
    // _remainingSeconds, _currentPhaseProgress, _isPrepPhase 등은 그대로 유지

    update();
  }

  @override
  void resume() {
    if (_currentState != TimerState.paused) return;

    // 일시정지된 상태에서 재시작
    _currentState = TimerState.running;
    
    // 현재 진행 상태를 유지한 채로 타이머 재시작
    _startCountdownFromCurrentState();
    
    update();
  }

  /// 현재 진행 상태를 유지한 채로 타이머 재시작 (일시정지 후 재개용)
  void _startCountdownFromCurrentState() {
    _timer?.cancel();
    _animationTimer?.cancel();

    // 현재 진행 상태에서 남은 시간 계산
    int totalMilliseconds = (_isPrepPhase ? _prepTimeSeconds : _baseTimeSeconds) * 1000; // 전체 시간
    int elapsedMilliseconds = totalMilliseconds - (_remainingSeconds * 1000); // 이미 진행된 시간
    int lastSeconds = (_isPrepPhase ? _prepTimeSeconds : _baseTimeSeconds) - _remainingSeconds; // 이미 진행된 초
    
    // 애니메이션 시작 (현재 진행 상태 유지)
    _startAnimationFromCurrentState();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      elapsedMilliseconds += 10;
      int currentSeconds = elapsedMilliseconds ~/ 1000;
      
      // 초가 변경되었을 때만 카운터 증가
      if (currentSeconds > lastSeconds) {
        _remainingSeconds--;
        _totalElapsedSeconds++;
        lastSeconds = currentSeconds;
      }
      
      // 밀리초 단위 진행률 계산 (이미 진행된 상태에서 시작)
      _currentPhaseProgress = (elapsedMilliseconds / totalMilliseconds).clamp(0.0, 1.0);

      if (elapsedMilliseconds >= totalMilliseconds) {
        _nextRound();
      }

      update();
    });
  }

  void _startCountdown() {
    _timer?.cancel();
    _animationTimer?.cancel();

    // 애니메이션 시작
    _startAnimation();

    int totalMilliseconds = _remainingSeconds * 1000; // 초를 밀리초로 변환
    int elapsedMilliseconds = 0;
    int lastSeconds = 0;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      elapsedMilliseconds += 10;
      int currentSeconds = elapsedMilliseconds ~/ 1000;
      
      // 초가 변경되었을 때만 카운터 증가
      if (currentSeconds > lastSeconds) {
        _remainingSeconds--;
        _totalElapsedSeconds++;
        lastSeconds = currentSeconds;
      }
      
      // 밀리초 단위 진행률 계산 (매우 부드러운 애니메이션을 위해)
      _currentPhaseProgress = (elapsedMilliseconds / totalMilliseconds).clamp(0.0, 1.0);

      if (elapsedMilliseconds >= totalMilliseconds) {
        _nextRound();
      }

      update();
    });
  }

  /// 부드러운 애니메이션을 위한 메서드
  void _startAnimation() {
    _animationValue = 0.0;
    _animationTimer?.cancel();
    
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _animationValue += 0.05; // 약 60fps로 부드럽게 증가
      
      if (_animationValue >= 1.0) {
        _animationValue = 1.0;
        timer.cancel();
      }
      
      update(); // UI 업데이트
    });
  }

  /// 현재 진행 상태를 유지한 애니메이션을 위한 메서드 (일시정지 후 재개용)
  void _startAnimationFromCurrentState() {
    // 현재 진행 상태에 맞는 애니메이션 값 설정
    _animationValue = _currentPhaseProgress;
    _animationTimer?.cancel();
    
    _animationTimer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      _animationValue += 0.05; // 약 60fps로 부드럽게 증가
      
      if (_animationValue >= 1.0) {
        _animationValue = 1.0;
        timer.cancel();
      }
      
      update(); // UI 업데이트
    });
  }

  void _nextRound() {
    if (_currentRound < _totalRounds) {
      _currentRound++;

      // 첫 번째 라운드이고 준비호흡 생략 설정이 true인 경우
      if (_currentRound == 1 && _shouldSkipFirstPrep()) {
        // 1라운드 준비호흡 생략, 바로 숨참기로
        _isPrepPhase = false;
        _remainingSeconds = _baseTimeSeconds;
        _animationValue = 0.0; // 애니메이션 값 초기화
        _currentPhaseProgress = 0.0; // 진행률 초기화
        print('1라운드 준비호흡 생략 - 바로 숨참기로');
      } else {
        // 일반적인 경우: 준비호흡과 숨참기 단계 전환
        if (_isPrepPhase) {
          // 준비호흡 완료, 숨참기 시작
          _isPrepPhase = false;
          _remainingSeconds = _baseTimeSeconds;
          _animationValue = 0.0; // 애니메이션 값 초기화
          _currentPhaseProgress = 0.0; // 진행률 초기화
        } else {
          // 숨참기 완료, 다음 라운드 준비호흡 시작
          _isPrepPhase = true;
          // 준비호흡 시간은 15초씩 감소 (최소 30초)
          _prepTimeSeconds = (_prepTimeSeconds - 15).clamp(30, 120);
          _remainingSeconds = _prepTimeSeconds;
          _animationValue = 0.0; // 애니메이션 값 초기화
          _currentPhaseProgress = 0.0; // 진행률 초기화
        }
      }

      if (_currentState == TimerState.running) {
        _startCountdown();
      }
    } else {
      // 모든 라운드 완료
      stop();
      return;
    }
  }

  /// 첫 번째 준비호흡 생략 여부 확인
  bool _shouldSkipFirstPrep() {
    try {
      final settingsController = Get.find<SettingsController>();
      return settingsController.timeBasedSkipFirstPrep.value;
    } catch (e) {
      print('설정값 가져오기 실패: $e');
      return false;
    }
  }

  @override
  Widget buildCustomUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 라운드 정보
        CommonBox(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "경과 시간",
                      textAlign: TextAlign.left,
                      style: AppTextStyles.b3r('white'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "순서",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.b3r('white'),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "남은 시간",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.b3r('white'),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${totalDisplayTime}",
                      textAlign: TextAlign.left,
                      style: AppTextStyles.h4m('white'),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$_currentRound",
                          style: AppTextStyles.h4m('white'),
                        ),
                        Text('/', style: AppTextStyles.h4m('gray')),
                        Text('$_totalRounds', style: AppTextStyles.h4m('gray')),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${displayTime}",
                      textAlign: TextAlign.right,
                      style: AppTextStyles.h4m('white'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
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
                          ? _currentPhaseProgress
                          : 0.0,
                      color: _isPrepPhase
                          ? AppTheme.buttonTextColor
                          : AppTheme.yellowColor,
                      strokeWidth: 14,
                      animationValue: _animationValue,
                    ),
                  ),
                ),
                // 중앙 콘텐츠
                Column(
                  children: [
                    Text(
                      currentPhaseText,
                      style: AppTextStyles.h3r(
                        _isPrepPhase ? 'white' : 'yellow',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayTime,
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                        color: _isPrepPhase
                            ? AppTheme.buttonTextColor
                            : AppTheme.yellowColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // 제어 버튼들
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (_currentState == TimerState.idle ||
                    _currentState == TimerState.paused)
                  ElevatedButton(
                    onPressed: _currentState == TimerState.paused
                        ? resume
                        : start,
                    child: CommonIcon(iconPath: _currentState == TimerState.paused ? 'play.svg' : 'play.svg', width: 32, height: 32),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(
                        18,
                      ),
                    ),
                  ),

                if (_currentState == TimerState.running)
                  ElevatedButton(
                    onPressed: pause,
                    child: CommonIcon(iconPath: 'pause.svg', width: 32, height: 32),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(
                        18,
                      ),
                    ),
                  ),

                ElevatedButton(
                  onPressed: reset,
                  child: CommonIcon(iconPath: 'stop.svg', width: 32, height: 32),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(
                      18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // 제어 버튼들
            Column(
              children: [
                    Text('앱 화면을 유지해 주세요!', style: AppTextStyles.b3r('white')),
                    Text('이탈시, 기록이 초기화 됩니다!', style: AppTextStyles.b3r('white')),
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> getTimerData() {
    return {
      'type': 'time-based',
      'currentRound': _currentRound,
      'totalRounds': _totalRounds,
      'baseTimeSeconds': _baseTimeSeconds,
      'totalElapsedSeconds': _totalElapsedSeconds,
      'displayTime': displayTime,
      'totalDisplayTime': totalDisplayTime,
      'state': _currentState.name,
      'isCompleted': _currentState == TimerState.completed,
    };
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
