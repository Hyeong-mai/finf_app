import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/util/common_utils.dart';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OTPDisplay extends StatelessWidget {
  final int remainingSeconds;
  final double percent;
  final bool from;

  const OTPDisplay({
    super.key,
    this.remainingSeconds = 0,
    this.from = false,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        percent: percent,
        radius: 127,
        lineWidth: 14,
        animation: true,
        animateFromLastPercent: true,
        progressColor: from
            ? Theme.of(context).colorScheme.inversePrimary
            : const Color.fromRGBO(255, 255, 255, 0.8),
        backgroundColor: Theme.of(context).primaryColor,
        circularStrokeCap: CircularStrokeCap.round,
        center: Container(
            height: 224,
            width: 224,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.12), // 반투명 흰색 배경
              shape: BoxShape.circle, // 원형으로 설정
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "새로운 기록 시작",
                  style: AppTextStyles.h3r("white"),
                ),
                Text(
                  formatTime(remainingSeconds),
                  style: AppTextStyles.h1b(from ? "yellow" : "white"),
                ),
              ],
            )),
      ),
    );
  }
}
