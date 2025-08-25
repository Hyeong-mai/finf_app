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

/// 호흡 상태 열거형
enum BreathState {
  preparation, // 준비호흡
  holding, // 숨참기
}

/// 호흡 단계 열거형
enum BreathPhase {
  inhale, // 들숨
  exhale, // 날숨
}

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

class BreathBasedTimerProvider extends TimerProvider {
  Timer? _timer;
  TimerState _currentState = TimerState.idle;
  BreathState _currentBreathState = BreathState.preparation;
  BreathPhase _currentBreathPhase = BreathPhase.inhale; // 현재 호흡 단계

  // 애니메이션을 위한 변수
  double _animationValue = 0.0;
  Timer? _animationTimer;

  // 설정값들
  int _totalRounds = 8; // 최대 8라운드
  int _prepSeconds = 9; // 기본 9초 (3,6,9,12,15초 중 선택)

  @override
  void onInit() {
    super.onInit();
    print('BreathBasedTimerProvider onInit 시작');
    _loadSettings();
    print(
      'BreathBasedTimerProvider onInit 완료: 라운드=$_totalRounds, 준비시간=$_prepSeconds초',
    );
  }

  /// 설정 로드
  void _loadSettings() {
    try {
      final settingsController = Get.find<SettingsController>();
      _totalRounds = settingsController.breathBasedRounds.value;
      _prepSeconds = settingsController.breathBasedPrepSeconds.value;
      print('설정 로드 성공: 라운드=$_totalRounds, 준비시간=$_prepSeconds초');
    } catch (e) {
      print('설정 로드 실패: $e');
      // 기본값 사용
      _totalRounds = 3;
      _prepSeconds = 9;
    }
  }

  // 현재 상태
  int _currentRound = 1;
  int _currentPhaseSeconds = 0;
  int _totalElapsedSeconds = 0;
  int _currentBreathCount = 0; // 현재 라운드의 현재 호흡 횟수
  double _currentPhaseProgress = 0.0; // 밀리초 단위 진행률 (0.0 ~ 1.0)

  // 타이머 데이터
  int get currentRound => _currentRound;
  int get totalRounds => _totalRounds;
  int get currentPhaseSeconds => _currentPhaseSeconds;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  BreathState get currentBreathState => _currentBreathState;
  BreathPhase get currentBreathPhase => _currentBreathPhase;
  int get currentBreathCount => _currentBreathCount;
  String get displayTime => TimerUtils.formatTime(_totalElapsedSeconds);

  // 현재 라운드의 총 호흡 횟수
  int get currentRoundBreathCount =>
      TimerUtils.calculateBreathCount(_getCurrentPrepSeconds(), _currentRound);

  // 현재 설정된 준비호흡 시간을 실시간으로 가져오기
  int _getCurrentPrepSeconds() {
    try {
      final settingsController = Get.find<SettingsController>();
      return settingsController.breathBasedPrepSeconds.value;
    } catch (e) {
      print('설정값 가져오기 실패, 기본값 사용: $e');
      return _prepSeconds;
    }
  }

  // 진행률
  double get roundProgress =>
      TimerUtils.calculateProgress(_currentRound - 1, _totalRounds);
  double get phaseProgress => _getPhaseProgress();
  double get breathProgress => _getBreathProgress();

  @override
  TimerState get currentState => _currentState;

  // 설정 업데이트
  void updateSettings({int? totalRounds, int? prepSeconds}) {
    if (totalRounds != null) _totalRounds = totalRounds;
    if (prepSeconds != null) _prepSeconds = prepSeconds;

    if (_currentState == TimerState.idle) {
      _resetToInitialState();
    }

    update();
  }

  /// 설정 변경 시 호출하여 타이머 상태 업데이트
  void refreshSettings() {
    print('설정 새로고침 시작');
    _loadSettings();
    if (_currentState == TimerState.idle) {
      _resetToInitialState();
    }
    print('설정 새로고침 완료: 라운드=$_totalRounds, 준비시간=$_prepSeconds초');
    update();
  }

  @override
  void start() {
    if (_currentState == TimerState.running) return;

    _currentState = TimerState.running;
    _startPhase();

    update();
  }

  @override
  void pause() {
    if (_currentState != TimerState.running) return;

    _currentState = TimerState.paused;
    _timer?.cancel();
    _timer = null;
    _animationTimer?.cancel(); // 애니메이션 타이머도 정지

    // 현재 진행 상태는 보존 (초기화하지 않음)
    // _currentPhaseSeconds, _currentPhaseProgress, _currentBreathState 등은 그대로 유지

    update();
  }

  @override
  void resume() {
    if (_currentState != TimerState.paused) return;

    // 일시정지된 상태에서 재시작
    _currentState = TimerState.running;

    // 현재 진행 상태를 유지한 채로 타이머 재시작
    _startPhaseFromCurrentState();

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
      final apiService = Get.find<ApiService>();
      await apiService.sendBreathRecord(
        totalRounds: _totalRounds,
        skipReadyBreathing: _shouldSkipFirstPrep(),
        preparatoryBreathDuration: _getCurrentPrepSeconds(),
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
    _currentPhaseSeconds = 0;
    _totalElapsedSeconds = 0;
    _currentPhaseProgress = 0.0; // 진행률 초기화
    _animationValue = 0.0; // 애니메이션 값 초기화

    // 첫 번째 라운드에서 준비호흡 생략 설정이 true인 경우
    if (_shouldSkipFirstPrep()) {
      // 1라운드 준비호흡 생략, 바로 숨참기로
      _currentBreathState = BreathState.holding;
      _currentBreathPhase = BreathPhase.inhale;
      _currentBreathCount = 0;
      print('초기 상태: 1라운드 준비호흡 생략 - 바로 숨참기로');
    } else {
      // 일반적인 경우: 준비호흡으로 시작
      _currentBreathState = BreathState.preparation;
      _currentBreathPhase = BreathPhase.inhale;
      _currentBreathCount = 0;
      print('초기 상태: 1라운드 준비호흡으로 시작');
    }
  }

  /// 현재 진행 상태를 유지한 채로 타이머 재시작 (일시정지 후 재개용)
  void _startPhaseFromCurrentState() {
    _timer?.cancel();
    _animationTimer?.cancel();

    // 현재 진행 상태에서 남은 시간 계산
    int phaseDuration = _getPhaseDuration();
    int remainingMilliseconds = (phaseDuration - _currentPhaseSeconds) * 1000;

    if (remainingMilliseconds <= 0) {
      // 이미 완료된 상태라면 다음 단계로
      _nextPhase();
      return;
    }

    // 애니메이션 시작
    _startAnimation();

    // 현재 진행된 시간을 고려하여 시작
    int elapsedMilliseconds = _currentPhaseSeconds * 1000;
    int lastSeconds = _currentPhaseSeconds;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      elapsedMilliseconds += 10;
      int currentSeconds = elapsedMilliseconds ~/ 1000;

      // 초가 변경되었을 때만 카운터 증가
      if (currentSeconds > lastSeconds) {
        _currentPhaseSeconds = currentSeconds;
        _totalElapsedSeconds++;
        lastSeconds = currentSeconds;
      }

      // 밀리초 단위 진행률 계산 (매우 부드러운 애니메이션을 위해)
      _currentPhaseProgress = (elapsedMilliseconds / (phaseDuration * 1000))
          .clamp(0.0, 1.0);

      if (elapsedMilliseconds >= phaseDuration * 1000) {
        _nextPhase();
      }

      update();
    });
  }

  void _startPhase() {
    _timer?.cancel();
    _animationTimer?.cancel();

    int phaseDuration = _getPhaseDuration();
    int totalMilliseconds = phaseDuration * 1000; // 초를 밀리초로 변환
    int elapsedMilliseconds = 0;
    int lastSeconds = 0;

    // 애니메이션 시작
    _startAnimation();

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      elapsedMilliseconds += 10;
      int currentSeconds = elapsedMilliseconds ~/ 1000;

      // 초가 변경되었을 때만 카운터 증가
      if (currentSeconds > lastSeconds) {
        _currentPhaseSeconds = currentSeconds;
        _totalElapsedSeconds++;
        lastSeconds = currentSeconds;
      }

      // 밀리초 단위 진행률 계산 (매우 부드러운 애니메이션을 위해)
      _currentPhaseProgress = (elapsedMilliseconds / totalMilliseconds).clamp(
        0.0,
        1.0,
      );

      if (elapsedMilliseconds >= totalMilliseconds) {
        _nextPhase();
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

  void _nextPhase() {
    _currentPhaseSeconds = 0;
    _currentPhaseProgress = 0.0; // 진행률 초기화
    _animationValue = 0.0; // 애니메이션 값 초기화

    switch (_currentBreathState) {
      case BreathState.preparation:
        // 준비호흡 단계(들숨/날숨) 완료, 다음 단계로
        _nextBreathPhase();
        break;
      case BreathState.holding:
        // 숨참기 완료, 다음 라운드로
        _nextRound();
        break;
    }

    if (_currentState == TimerState.running) {
      _startPhase();
    }
  }

  void _nextBreathPhase() {
    if (_currentBreathPhase == BreathPhase.inhale) {
      // 들숨 완료, 날숨으로
      _currentBreathPhase = BreathPhase.exhale;
    } else {
      // 날숨 완료, 다음 호흡 또는 숨참기로
      _nextBreathOrRound();
    }
  }

  void _nextBreathOrRound() {
    // 준비호흡 1회 완료 후 처리 (들숨 + 날숨)
    _currentBreathCount++;

    if (_currentBreathCount >= currentRoundBreathCount) {
      // 현재 라운드의 모든 준비호흡 완료, 숨참기로
      _currentBreathState = BreathState.holding;
      _currentBreathPhase = BreathPhase.inhale; // 들숨 상태로 변경
    } else {
      // 같은 라운드에서 다음 준비호흡으로 (들숨부터 시작)
      _currentBreathPhase = BreathPhase.inhale;
    }
  }

  void _nextRound() {
    if (_currentRound < _totalRounds) {
      _currentRound++;

      // 첫 번째 라운드이고 준비호흡 생략 설정이 true인 경우
      if (_currentRound == 1 && _shouldSkipFirstPrep()) {
        // 1라운드 준비호흡 생략, 바로 숨참기로
        _currentBreathState = BreathState.holding;
        _currentBreathPhase = BreathPhase.inhale;
        _currentBreathCount = 0;
        print('1라운드 준비호흡 생략 - 바로 숨참기로');
      } else {
        // 일반적인 경우: 준비호흡으로 시작
        _currentBreathState = BreathState.preparation;
        _currentBreathPhase = BreathPhase.inhale;
        _currentBreathCount = 0;
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
      return settingsController.breathBasedSkipPrep.value;
    } catch (e) {
      print('설정값 가져오기 실패: $e');
      return false;
    }
  }

  /// 숨참기 시간 가져오기 (모드에 따라)
  int _getStaticTimeSeconds() {
    try {
      final settingsController = Get.find<SettingsController>();
      return settingsController.getStaticRecordFinalSeconds();
    } catch (e) {
      print('숨참기 시간 가져오기 실패: $e');
      return 120; // 기본값 2분
    }
  }

  int _getPhaseDuration() {
    switch (_currentBreathState) {
      case BreathState.preparation:
        // 들숨과 날숨의 시간을 다르게 설정
        if (_currentBreathPhase == BreathPhase.inhale) {
          // 들숨: 전체 시간의 1/3 (3초)
          final totalPrepTime = _getCurrentPrepSeconds();
          final inhaleTime = (totalPrepTime / 3).round();

          return inhaleTime;
        } else {
          // 날숨: 전체 시간의 2/3 (6초)
          final totalPrepTime = _getCurrentPrepSeconds();
          final exhaleTime = (totalPrepTime * 2 / 3).round();

          return exhaleTime;
        }
      case BreathState.holding:
        // 스테틱 설정에서 숨참기 시간 가져오기 (모드에 따라)
        final settingsController = Get.find<SettingsController>();
        final staticTime = settingsController.getStaticRecordFinalSeconds();

        return staticTime;
    }
  }

  double _getPhaseProgress() {
    // 밀리초 단위 진행률 반환 (부드러운 애니메이션)
    return _currentPhaseProgress;
  }

  double _getBreathProgress() {
    if (currentRoundBreathCount <= 0) return 0.0;

    // 들숨/날숨 단계를 고려한 진행률 계산
    double progress = _currentBreathCount / currentRoundBreathCount;

    if (_currentBreathState == BreathState.preparation) {
      // 준비호흡 상태에서는 들숨/날숨 단계를 추가로 고려
      if (_currentBreathPhase == BreathPhase.inhale) {
        // 들숨은 전체 호흡의 1/3 시간
        progress += (1.0 / 3.0) / currentRoundBreathCount;
      } else {
        // 날숨은 전체 호흡의 2/3 시간
        progress += (2.0 / 3.0) / currentRoundBreathCount;
      }
    }

    return progress.clamp(0.0, 1.0);
  }

  String _getBreathStateText() {
    switch (_currentBreathState) {
      case BreathState.preparation:
        final totalPrepTime = _getCurrentPrepSeconds();
        final inhaleTime = (totalPrepTime / 3).round();
        final exhaleTime = (totalPrepTime * 2 / 3).round();
        return '${_getBreathPhaseText()} (${_getPhaseDuration()}초)';
      case BreathState.holding:
        return '숨참기';
    }
  }

  String _getBreathPhaseText() {
    switch (_currentBreathPhase) {
      case BreathPhase.inhale:
        return '들숨';
      case BreathPhase.exhale:
        return '날숨';
    }
  }

  Color _getBreathStateColor() {
    switch (_currentBreathState) {
      case BreathState.preparation:
        return AppTheme.buttonTextColor;
      case BreathState.holding:
        return AppTheme.yellowColor;
    }
  }

  @override
  Widget buildCustomUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                      "${displayTime}",
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
                      '${TimerUtils.formatTime(_getPhaseDuration() - _currentPhaseSeconds)}',
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
                      color: _getBreathStateColor(),
                      strokeWidth: 14,
                      animationValue: _animationValue,
                    ),
                  ),
                ),
                // 중앙 콘텐츠
                Column(
                  children: [
                    Text(
                      _getBreathStateText(),
                      style: AppTextStyles.h3r('white'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${TimerUtils.formatTime(_getPhaseDuration() - _currentPhaseSeconds)}',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w500,
                        color: _getBreathStateColor(),
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
                    child: CommonIcon(
                      iconPath: _currentState == TimerState.paused
                          ? 'play.svg'
                          : 'play.svg',
                      width: 32,
                      height: 32,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(18),
                    ),
                  ),

                if (_currentState == TimerState.running)
                  ElevatedButton(
                    onPressed: pause,
                    child: CommonIcon(
                      iconPath: 'pause.svg',
                      width: 32,
                      height: 32,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(18),
                    ),
                  ),

                ElevatedButton(
                  onPressed: reset,
                  child: CommonIcon(
                    iconPath: 'stop.svg',
                    width: 32,
                    height: 32,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(18),
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
            ),
          ],
        ),
      ],
    );
  }

  @override
  Map<String, dynamic> getTimerData() {
    return {
      'type': 'breath-based',
      'currentRound': _currentRound,
      'totalRounds': _totalRounds,
      'currentBreathState': _currentBreathState.name,
      'currentBreathPhase': _currentBreathPhase.name,
      'currentBreathCount': _currentBreathCount,
      'breathPhaseText': _getBreathPhaseText(),
      'currentRoundBreathCount': currentRoundBreathCount,
      'totalElapsedSeconds': _totalElapsedSeconds,
      'displayTime': displayTime,
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
