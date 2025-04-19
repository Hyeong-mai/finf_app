import 'dart:async';
import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/screen/contents/result/record_result_page.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'otp_display.dart'; // OTPDisplay 위젯 따로 분리되어 있다고 가정

class OTPTimerScreen extends StatefulWidget {
  final String? from;
  const OTPTimerScreen({super.key, this.from});

  @override
  State<OTPTimerScreen> createState() => _OTPTimerScreenState();
}

class _OTPTimerScreenState extends State<OTPTimerScreen> {
  final StaticRecordsController _controller =
      Get.find<StaticRecordsController>();
  Timer? timer;
  int elapsedSeconds = 0;
  final int totalSeconds = 20 * 59;
  bool isRunning = false; // ✅ 상태 추적용

  double get percent => elapsedSeconds / totalSeconds;

  @override
  void initState() {
    super.initState();
    // 자동 시작 안 할 경우, 이 줄 제거
    // startStopwatch();
  }

  void startStopwatch() {
    if (isRunning) return;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (elapsedSeconds >= totalSeconds) {
          t.cancel();
          isRunning = false;
        } else {
          elapsedSeconds++;
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void stopStopwatch() {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    _controller.setSelectedTime(timeString);
    print(_controller.selectedSeconds.value);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecordResultPage(from: widget.from ?? ""),
      ),
    );

    timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 255,
          width: 255,
          child: OTPDisplay(
            from: widget.from == "",
            remainingSeconds: elapsedSeconds,
            percent: percent.clamp(0.0, 1.0),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButtonWidget(
              onPressed: stopStopwatch,
              radius: 100,
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.all(16),
              child: SvgIcon(
                url: "assets/icons/stop.svg",
                size: 32,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const SizedBox(width: 16),
            CustomButtonWidget(
                onPressed: startStopwatch,
                radius: 100,
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.all(16),
                child: SvgIcon(
                  url: "assets/icons/play.svg",
                  size: 32,
                  color: Theme.of(context).scaffoldBackgroundColor,
                )),
          ],
        ),
      ],
    );
  }
}
