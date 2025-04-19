import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';

class TimeTableDashboard extends StatelessWidget {
  const TimeTableDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWrapperWidget(
      height: 280,
      width: 240,
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgIcon(
                url: "assets/icons/timeTable.svg",
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 48,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "시간 기반 테이블",
                style: AppTextStyles.h4m("white"),
              ),
              Text(
                "15초씩 준비 호흡 시간을 줄여가며 훈련해요",
                style: AppTextStyles.b3r("white"),
              ),
            ],
          ),
          const SizedBox(
            height: 48,
          ),
          CustomButtonWidget(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            backgroundColor: Colors.white,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.timetable),
            child: Center(
              child: Text(
                "훈련 시작하기",
                style: AppTextStyles.b1m("black"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
