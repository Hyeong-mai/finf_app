import 'dart:async';
import 'package:finf_app/controller/breath_table_controller.dart';
import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/controller/time_table_controller.dart';
import 'package:finf_app/screen/contents/result/record_result_page.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:finf_app/widget/timer/otp_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OTPTimerScreen extends StatefulWidget {
  final String from;

  const OTPTimerScreen({super.key, required this.from});

  @override
  State<OTPTimerScreen> createState() => _OTPTimerScreenState();
}

class _OTPTimerScreenState extends State<OTPTimerScreen> {
  late final dynamic controller;
  Timer? timer;
  int elapsedSeconds = 0;
  final int totalSeconds = 20 * 59;
  bool isRunning = false; // ✅ 상태 추적용

  double get percent => elapsedSeconds / totalSeconds;

  @override
  void initState() {
    super.initState();
    // from 값에 따라 다른 컨트롤러 사용
    switch (widget.from) {
      case 'time':
        controller = Get.put(TimeTableController());
        break;
      case 'breath':
        controller = Get.put(BreathTableController());
        break;
      default:
        controller = Get.put(StaticRecordsController());
        break;
    }
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
    controller.setSelectedTime(timeString);
    print(controller.selectedSeconds.value);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecordResultPage(from: widget.from),
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
