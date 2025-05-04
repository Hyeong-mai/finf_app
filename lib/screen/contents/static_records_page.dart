import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/app_background.dart';
import 'package:finf_app/widget/timer/otp_display.dart';
import 'package:finf_app/widget/timer/otp_timer_screen.dart';
import 'package:finf_app/widget/staticRecord/select_time_widget.dart';
import 'package:finf_app/widget/staticRecord/select_title.dart';
import 'package:flutter/material.dart';

class StaticRecordsPage extends StatelessWidget {
  const StaticRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          surfaceTintColor: Colors.transparent, // Material 3 대응
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(
            // 여기서 뒤로가기 버튼 색상 설정
            color: Theme.of(context).scaffoldBackgroundColor,
            size: 24, // 아이콘 크기
          ),
          title: Text(
            '스테틱 기록',
            style: AppTextStyles.h4m("white"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Column(
                children: [
                  SelectTitle(),
                  SizedBox(
                    height: 12,
                  ),
                  SelectTimeWidget(),
                ],
              ),
              Expanded(
                child: Container(
                  child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        OTPTimerScreen(
                          from: "",
                        ),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
