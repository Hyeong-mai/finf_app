import 'package:finf_app/controller/time_table_controller.dart';
import 'package:finf_app/screen/contents/result/record_result_page.dart';
import 'package:finf_app/screen/contents/timer/contents_timer_page.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/app_background.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/table/record_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeTablePage extends GetView<TimeTableController> {
  const TimeTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              // 여기서 뒤로가기 버튼 색상 설정
              color: Theme.of(context).scaffoldBackgroundColor,
              size: 24, // 아이콘 크기
            ),
            title: Text(
              '시간 테이블',
              style: AppTextStyles.h4m("white"),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => RecordTable(data: controller.records.toList())),
                CustomButtonWidget(
                  width: double.infinity,
                  onPressed: () {
                    Get.to(() => const ContentsTimerPage(from: 'time'));
                  },
                  padding: const EdgeInsets.all(12),
                  backgroundColor: Colors.blue,
                  child: Center(
                      child: Text(
                    "시간 기반 테이블 훈련 하러 가기",
                    style: AppTextStyles.b1m("white"),
                  )),
                ),
              ],
            ),
          )),
    );
  }
}
