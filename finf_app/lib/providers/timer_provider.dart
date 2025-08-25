import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// 타이머 상태 열거형
enum TimerState {
  idle,      // 대기
  running,   // 실행 중
  paused,    // 일시정지
  completed, // 완료
}

/// 타이머 Provider의 기본 인터페이스
abstract class TimerProvider extends GetxController {
  // 기본 타이머 상태
  TimerState get currentState;
  bool get isRunning => currentState == TimerState.running;
  bool get isPaused => currentState == TimerState.paused;
  bool get isCompleted => currentState == TimerState.completed;
  bool get isIdle => currentState == TimerState.idle;
  
  // 타이머 제어 메소드
  void start();
  void pause();
  void resume();
  void stop();
  void reset();
  
  // Provider별 특화 UI 빌드
  Widget buildCustomUI();
  
  // Provider별 특화 데이터
  Map<String, dynamic> getTimerData();
  
  // 타이머 완료 콜백
  VoidCallback? onComplete;
  
  // 타이머 상태 변경 시 알림
  void notifyStateChanged() {
    update();
  }
}

/// 타이머 관련 유틸리티 클래스
class TimerUtils {
  /// 초를 "분:초" 형태로 포맷팅
  static String formatTime(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (minutes == 0) {
      return '0:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}: ${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// 초를 "00분00초" 형태로 포맷팅 (UI용)
  static String formatTimeUI(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    
    return '${minutes.toString().padLeft(2, '0')}분${seconds.toString().padLeft(2, '0')}초';
  }
  
  /// 초를 "시:분:초" 형태로 포맷팅
  static String formatTimeLong(int totalSeconds) {
    if (totalSeconds < 0) totalSeconds = 0;
    
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    if (hours == 0) {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
  
  /// 진행률 계산 (0.0 ~ 1.0)
  static double calculateProgress(int current, int total) {
    if (total <= 0) return 0.0;
    return (current / total).clamp(0.0, 1.0);
  }
  
  /// 호흡 기반 타이머에서 라운드별 호흡 횟수 계산
  /// prepSeconds: 준비호흡 시간 (초)
  /// round: 현재 라운드 (1부터 시작)
  /// 기본 호흡 횟수는 8회, 라운드마다 1회씩 감소
  static int calculateBreathCount(int prepSeconds, int round) {
    // 기본 호흡 횟수는 8회
    const int baseBreathCount = 8;
    // 라운드마다 1회씩 감소
    final int breathCount = baseBreathCount - (round - 1);
    // 최소 1회는 보장
    return breathCount.clamp(1, baseBreathCount);
  }
  
  /// 호흡 기반 타이머에서 라운드별 호흡 횟수를 텍스트로 표시
  static String formatBreathCount(int prepSeconds, int round) {
    final breathCount = calculateBreathCount(prepSeconds, round);
    return '${breathCount}회';
  }
  
  /// 호흡 기반 타이머에서 라운드별 호흡 횟수를 상세 텍스트로 표시
  static String formatBreathCountDetail(int prepSeconds, int round) {
    final breathCount = calculateBreathCount(prepSeconds, round);
    return '${breathCount}회 (${prepSeconds}초씩)';
  }
}
