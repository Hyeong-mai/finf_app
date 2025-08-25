import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../providers/timer_provider.dart';

class CommonTimer extends StatelessWidget {
  final TimerProvider timerProvider;
  final VoidCallback? onComplete;
  final String title;
  final Color themeColor;

  const CommonTimer({
    super.key,
    required this.timerProvider,
    this.onComplete,
    required this.title,
    required this.themeColor,
  });

  @override
  Widget build(BuildContext context) {
    // onComplete 콜백을 타이머 provider에 연결
    if (onComplete != null) {
      timerProvider.onComplete = onComplete;
    }

    return timerProvider.buildCustomUI();
  }

 
}
