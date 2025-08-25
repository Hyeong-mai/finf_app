import 'package:finf_app/core/binding/static_records_binding.dart';
import 'package:finf_app/core/model/static_record_model.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../core/routes/app_routes.dart';

class StaticRecordsDashboard extends StatelessWidget {
  final StaticRecord? data;
  const StaticRecordsDashboard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return CustomWrapperWidget(
      backgroundColor: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "스테틱 최고 기록",
                style: AppTextStyles.b3r("white"),
              ),
              Text(
                "🔥 ${data?.formattedRecord ?? "00분00초"}",
                style: AppTextStyles.h4m("white"),
              ),
            ],
          ),
          CustomButtonWidget(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            backgroundColor: Colors.white,
            onPressed: () {
              final staticRecordsBinding = StaticRecordsBinding();
              staticRecordsBinding.dependencies();
              Get.toNamed(AppRoutes.staticRecords);
            },
            child: Text(
              "관리",
              style: AppTextStyles.b2m("black"),
            ),
          ),
        ],
      ),
    );
  }
}
