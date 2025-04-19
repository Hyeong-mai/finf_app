import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_button_widget.dart';
import 'package:finf_app/widget/common/custom_icon_button_widget.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:finf_app/widget/dashboard/breath_table_dashboard.dart';
import 'package:finf_app/widget/dashboard/dashboard_title.dart';
import 'package:finf_app/widget/dashboard/static_records_dashboard.dart';
import 'package:finf_app/widget/dashboard/time_table_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/binding/main_binding.dart';
import '../../controller/main_controller.dart';
import '../../core/routes/app_routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<MainController>(
      init: MainController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent, // Material 3 대응
            shadowColor: Colors.transparent,
            actions: [
              IconButton(
                icon: SvgIcon(
                  url: "assets/icons/record.svg",
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.record);
                },
              ),
              IconButton(
                icon: SvgIcon(
                  url: "assets/icons/setting.svg",
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.set);
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const DashboardTitle(),
                    const SizedBox(height: 24),
                    StaticRecordsDashboard(
                      data: controller.highestRecord.value,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        const SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              TimeTableDashboard(),
                              SizedBox(width: 16), // 위젯 사이 간격 (선택)
                              BreathTableDashboard(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "똑똑하게 훈련하기",
                          style: AppTextStyles.b3underline("white"),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    CustomWrapperWidget(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      width: double.infinity,
                      radius: 4,
                      height: 80,
                      child: const Text("ad"),
                    ),
                    const SizedBox(height: 21),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
