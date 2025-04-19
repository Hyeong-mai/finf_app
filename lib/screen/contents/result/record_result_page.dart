import 'package:finf_app/core/routes/app_routes.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';

class RecordResultPage extends StatelessWidget {
  final String from;

  const RecordResultPage({super.key, required this.from});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: from != ""
            ? Text(from == "breath" ? '호흡 기반 테이블' : '시간 기반 테이블',
                style: AppTextStyles.h4m("white"))
            : null,
        leading: IconButton(
          icon: Icon(
            Icons.close, // 뒤로가기 대신 X 아이콘 사용
            color: Theme.of(context).scaffoldBackgroundColor,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgIcon(
                      url: "assets/icons/complete.svg",
                      size: 203,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      '훈련을 완료했어요!',
                      style: AppTextStyles.h1m("white"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '오늘 더 깊은 바다를 향해 조금 더 나아갔어요 내일도 참여해봐요',
                      style: AppTextStyles.b1r("white"),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              CustomButtonWidget(
                width: double.infinity,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.main,
                    (route) => false,
                  );
                  from == "breath"
                      ? Navigator.pushNamed(context, AppRoutes.timetable)
                      : from == "time"
                          ? Navigator.pushNamed(context, AppRoutes.breathtable)
                          : null;
                },
                padding: EdgeInsets.all(12),
                backgroundColor: Colors.blue,
                child: Center(
                    child: Text(
                  from == "breath"
                      ? "시간 기반 테이블 훈련 하러 가기"
                      : from == "time"
                          ? "호흡 기반 테이블 훈련 하러 가기"
                          : "테이블 훈련 하러 가기",
                  style: AppTextStyles.b1m("white"),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
