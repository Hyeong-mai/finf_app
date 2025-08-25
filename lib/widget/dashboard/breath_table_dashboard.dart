import 'package:finf_app/core/binding/breath_table_binding.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/routes/app_routes.dart';

class BreathTableDashboard extends StatelessWidget {
  const BreathTableDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWrapperWidget(
      width: 240,
      height: 280,
      backgroundColor: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgIcon(
                url: "assets/icons/breathTable.svg",
                color: Theme.of(context).scaffoldBackgroundColor,
                size: 48,
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                "호흡 기반 테이블",
                style: AppTextStyles.h4m("white"),
              ),
              Text(
                "준비 호흡 횟수를 줄여가며 훈련해요",
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
            onPressed: () {
              final breathTableBinding = BreathTableBinding();
              breathTableBinding.dependencies();
              Get.toNamed(AppRoutes.breathtable);
            },
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
