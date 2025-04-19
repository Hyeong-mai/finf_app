import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/timer/otp_timer_screen.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';

class ContentsTimerPage extends StatelessWidget {
  final String from;

  const ContentsTimerPage({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.close, // 뒤로가기 대신 X 아이콘 사용
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            from == "time" ? "시간 기반 테이블" : "호흡 기반 테이블",
            style: AppTextStyles.h4m("white"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWrapperWidget(
                backgroundColor: Theme.of(context).primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "경과 시간",
                          style: AppTextStyles.b3r("white"),
                        ),
                        Text(
                          "0:00",
                          style: AppTextStyles.h4m("white"),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "순서",
                          style: AppTextStyles.b3r("white"),
                        ),
                        Text(
                          "1 / 8",
                          style: AppTextStyles.h4m("white"),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "남은 시간",
                          style: AppTextStyles.b3r("white"),
                        ),
                        Text(
                          "0:00",
                          style: AppTextStyles.h4m("white"),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OTPTimerScreen(from: from),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "앱 화면을 유지해 주세요!",
                          style: AppTextStyles.b3r("white"),
                        ),
                      ],
                    ),
                    Text(
                      "이탈시, 1분 후에 자동 종료되며 기록에 남지 않아요",
                      style: AppTextStyles.b3r("white"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
