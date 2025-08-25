import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();
  
  // 오디오 카운트다운 설정
  final RxBool audioCountdown = true.obs;
  
  // 시간 기반 라운드 설정
  final RxInt timeBasedRounds = 3.obs;
  
  // 시간 기반 첫번째 준비호흡 생략
  final RxBool timeBasedSkipFirstPrep = false.obs;
  
  // 시간 기반 타이머 시간 설정 (분)
  final RxInt timeBasedMinutes = 2.obs;
  
  // 시간 기반 타이머 시간 설정 (초)
  final RxInt timeBasedSeconds = 2.obs;
  
  // 호흡 기반 라운드 설정
  final RxInt breathBasedRounds = 3.obs;
  
  // 호흡 기반 준비호흡 초 설정
  final RxInt breathBasedPrepSeconds = 9.obs;
  
  // 호흡 기반 준비호흡 생략
  final RxBool breathBasedSkipPrep = false.obs;
  
  // 스테틱 기록 설정
  final RxInt staticRecordSeconds = 120.obs; // 기본 2분
  
  // 스테틱 기록 모드 설정 (true: 타이머 모드, false: 직접 입력 모드)
  final RxBool staticRecordUseTimer = true.obs;
  
  // 스테틱 기록 직접 입력 시간 (분)
  final RxInt staticRecordMinutes = 2.obs;
  
  // 스테틱 기록 직접 입력 시간 (초)
  final RxInt staticRecordDirectSeconds = 0.obs;
  
  // 스테틱 최고 기록 (서버에서 가져온 값)
  final RxInt highestStaticRecord = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// 설정 로드
  Future<void> _loadSettings() async {
    try {
      audioCountdown.value = await _storageService.getSetting('audio_countdown', defaultValue: true);
      timeBasedRounds.value = await _storageService.getSettingInt('time_based_rounds', defaultValue: 3);
      timeBasedSkipFirstPrep.value = await _storageService.getSetting('time_based_skip_first_prep', defaultValue: false);
      timeBasedMinutes.value = await _storageService.getSettingInt('time_based_minutes', defaultValue: 2);
      timeBasedSeconds.value = await _storageService.getSettingInt('time_based_seconds', defaultValue: 2);
      breathBasedRounds.value = await _storageService.getSettingInt('breath_based_rounds', defaultValue: 3);
      breathBasedPrepSeconds.value = await _storageService.getSettingInt('breath_based_prep_seconds', defaultValue: 9);
      breathBasedSkipPrep.value = await _storageService.getSetting('breath_based_skip_prep', defaultValue: false);
      staticRecordSeconds.value = await _storageService.getSettingInt('static_record_seconds', defaultValue: 120);
      staticRecordUseTimer.value = await _storageService.getSetting('static_record_use_timer', defaultValue: true);
      staticRecordMinutes.value = await _storageService.getSettingInt('static_record_minutes', defaultValue: 2);
      staticRecordDirectSeconds.value = await _storageService.getSettingInt('static_record_direct_seconds', defaultValue: 0);
    } catch (e) {
      print('설정 로드 실패: $e');
    }
  }

  /// 스테틱 최고 기록 설정
  void setHighestStaticRecord(int record) {
    highestStaticRecord.value = record;
    print('최고 기록 설정: ${record}초');
  }
  
  /// 설정 저장
  Future<void> saveSettings() async {
    try {
      await _storageService.saveSetting('audio_countdown', audioCountdown.value);
      await _storageService.saveSetting('time_based_rounds', timeBasedRounds.value);
      await _storageService.saveSetting('time_based_skip_first_prep', timeBasedSkipFirstPrep.value);
      await _storageService.saveSetting('time_based_minutes', timeBasedMinutes.value);
      await _storageService.saveSetting('time_based_seconds', timeBasedSeconds.value);
      await _storageService.saveSetting('breath_based_rounds', breathBasedRounds.value);
      await _storageService.saveSetting('breath_based_prep_seconds', breathBasedPrepSeconds.value);
      await _storageService.saveSetting('breath_based_skip_prep', breathBasedSkipPrep.value);
      await _storageService.saveSetting('static_record_seconds', staticRecordSeconds.value);
      await _storageService.saveSetting('static_record_use_timer', staticRecordUseTimer.value);
      await _storageService.saveSetting('static_record_minutes', staticRecordMinutes.value);
      await _storageService.saveSetting('static_record_direct_seconds', staticRecordDirectSeconds.value);
      
      Get.snackbar(
        '설정 저장',
        '설정이 저장되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('설정 저장 실패: $e');
      Get.snackbar(
        '설정 저장 실패',
        '설정 저장 중 오류가 발생했습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// 오디오 카운트다운 토글
  void toggleAudioCountdown() {
    audioCountdown.value = !audioCountdown.value;
  }

  /// 시간 기반 라운드 증가
  void increaseTimeBasedRounds() {
    if (timeBasedRounds.value < 10) {
      timeBasedRounds.value++;
    }
  }

  /// 시간 기반 라운드 감소
  void decreaseTimeBasedRounds() {
    if (timeBasedRounds.value > 1) {
      timeBasedRounds.value--;
    }
  }

  /// 시간 기반 첫번째 준비호흡 생략 토글
  void toggleTimeBasedSkipFirstPrep() {
    timeBasedSkipFirstPrep.value = !timeBasedSkipFirstPrep.value;
  }

  /// 시간 기반 타이머 분 증가
  void increaseTimeBasedMinutes() {
    if (timeBasedMinutes.value < 10) { // 최대 10분
      timeBasedMinutes.value++;
    }
  }

  /// 시간 기반 타이머 분 감소
  void decreaseTimeBasedMinutes() {
    if (timeBasedMinutes.value > 0) { // 최소 0분
      timeBasedMinutes.value--;
    }
  }

  /// 시간 기반 타이머 초 증가
  void increaseTimeBasedSeconds() {
    if (timeBasedSeconds.value < 59) { // 최대 59초
      timeBasedSeconds.value++;
    }
  }

  /// 시간 기반 타이머 초 감소
  void decreaseTimeBasedSeconds() {
    if (timeBasedSeconds.value > 0) { // 최소 0초
      timeBasedSeconds.value--;
    }
  }

  /// 호흡 기반 라운드 증가
  void increaseBreathBasedRounds() {
    if (breathBasedRounds.value < 10) {
      breathBasedRounds.value++;
    }
  }

  /// 호흡 기반 라운드 감소
  void decreaseBreathBasedRounds() {
    if (breathBasedRounds.value > 1) {
      breathBasedRounds.value--;
    }
  }

  /// 호흡 기반 준비호흡 초 설정 (3,6,9,12,15초만 가능)
  void setBreathBasedPrepSeconds(int seconds) {
    if ([3, 6, 9, 12, 15].contains(seconds)) {
      breathBasedPrepSeconds.value = seconds;
    }
  }
  
  /// 호흡 기반 준비호흡 초 증가 (3,6,9,12,15초 순서)
  void increaseBreathBasedPrepSeconds() {
    final current = breathBasedPrepSeconds.value;
    if (current == 3) breathBasedPrepSeconds.value = 6;
    else if (current == 6) breathBasedPrepSeconds.value = 9;
    else if (current == 9) breathBasedPrepSeconds.value = 12;
    else if (current == 12) breathBasedPrepSeconds.value = 15;
  }
  
  /// 호흡 기반 준비호흡 초 감소 (15,12,9,6,3초 순서)
  void decreaseBreathBasedPrepSeconds() {
    final current = breathBasedPrepSeconds.value;
    if (current == 15) breathBasedPrepSeconds.value = 12;
    else if (current == 12) breathBasedPrepSeconds.value = 9;
    else if (current == 9) breathBasedPrepSeconds.value = 6;
    else if (current == 6) breathBasedPrepSeconds.value = 3;
  }

  /// 호흡 기반 준비호흡 생략 토글
  void toggleBreathBasedSkipPrep() {
    breathBasedSkipPrep.value = !breathBasedSkipPrep.value;
  }
  
  /// 호흡 기반 준비호흡 시간을 호흡 횟수로 변환 (1라운드 기준)
  int getBreathBasedPrepBreathCount() {
    // 1라운드는 기본 8회의 호흡
    return 8;
  }
  
  /// 호흡 기반 준비호흡 시간을 특정 라운드의 호흡 횟수로 변환
  int getBreathBasedPrepBreathCountForRound(int round) {
    // 기본 8회에서 라운드마다 1회씩 감소
    final breathCount = 8 - (round - 1);
    return breathCount.clamp(1, 8);
  }
  
  /// 호흡 기반 준비호흡 시간을 호흡 횟수 텍스트로 표시 (1라운드 기준)
  String getBreathBasedPrepBreathCountText() {
    return '${getBreathBasedPrepBreathCount()}회';
  }
  
  /// 호흡 기반 준비호흡 시간을 특정 라운드의 호흡 횟수 텍스트로 표시
  String getBreathBasedPrepBreathCountTextForRound(int round) {
    final breathCount = getBreathBasedPrepBreathCountForRound(round);
    return '${breathCount}회';
  }
  
  /// 스테틱 기록 시간 설정 (초 단위)
  void setStaticRecordSeconds(int seconds) {
    staticRecordSeconds.value = seconds;
  }
  
  /// 스테틱 기록 시간 증가 (15초씩)
  void increaseStaticRecordSeconds() {
    if (staticRecordSeconds.value < 300) { // 최대 5분
      staticRecordSeconds.value += 15;
    }
  }
  
  /// 스테틱 기록 시간 감소 (15초씩)
  void decreaseStaticRecordSeconds() {
    if (staticRecordSeconds.value > 30) { // 최소 30초
      staticRecordSeconds.value -= 15;
    }
  }
  
  /// 스테틱 기록 모드 토글 (타이머 모드 ↔ 직접 입력 모드)
  void toggleStaticRecordMode() {
    staticRecordUseTimer.value = !staticRecordUseTimer.value;
  }
  
  /// 스테틱 기록 직접 입력 분 증가
  void increaseStaticRecordMinutes() {
    if (staticRecordMinutes.value < 10) { // 최대 10분
      staticRecordMinutes.value++;
    }
  }
  
  /// 스테틱 기록 직접 입력 분 감소
  void decreaseStaticRecordMinutes() {
    if (staticRecordMinutes.value > 0) { // 최소 0분
      staticRecordMinutes.value--;
    }
  }
  
  /// 스테틱 기록 직접 입력 초 증가
  void increaseStaticRecordDirectSeconds() {
    if (staticRecordDirectSeconds.value < 59) { // 최대 59초
      staticRecordDirectSeconds.value++;
    }
  }
  
  /// 스테틱 기록 직접 입력 초 감소
  void decreaseStaticRecordDirectSeconds() {
    if (staticRecordDirectSeconds.value > 0) { // 최소 0초
      staticRecordDirectSeconds.value--;
    }
  }
  
  /// 스테틱 기록 직접 입력 시간을 초 단위로 변환
  int getStaticRecordDirectTotalSeconds() {
    return (staticRecordMinutes.value * 60) + staticRecordDirectSeconds.value;
  }
  
  /// 스테틱 기록에 사용할 최종 시간 (초 단위)
  int getStaticRecordFinalSeconds() {
    // 서버에서 가져온 최고 기록이 있으면 그것을 사용
    if (highestStaticRecord.value > 0) {
      return highestStaticRecord.value;
    }
    
    // 최고 기록이 없으면 기존 로직 사용
    if (staticRecordUseTimer.value) {
      return staticRecordSeconds.value;
    } else {
      return getStaticRecordDirectTotalSeconds();
    }
  }

  /// 설정 초기화
  Future<void> resetSettings() async {
    try {
      await _storageService.clearSettings();
      await _loadSettings();
      
      Get.snackbar(
        '설정 초기화',
        '설정이 기본값으로 초기화되었습니다.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF2196F3),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('설정 초기화 실패: $e');
    }
  }
}
