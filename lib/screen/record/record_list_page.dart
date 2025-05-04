import 'package:finf_app/controller/record_list_controller.dart';
import 'package:finf_app/core/util/date_util.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/app_background.dart';
import 'package:finf_app/widget/common/custom_nav_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RecordListPage extends GetView<RecordListController> {
  const RecordListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).scaffoldBackgroundColor,
            size: 24,
          ),
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            '테이블 기록',
            style: AppTextStyles.h4m("white"),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              CustomNavBar(
                selectedIndex: controller.selectedIndex.value,
                onTap: (index) {
                  controller.selectedIndex.value = index;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '순위',
                        style: AppTextStyles.b1r("white"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '기록',
                        style: AppTextStyles.b1r("white"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '날짜',
                        style: AppTextStyles.b1r("white"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final records = controller.records;
                  return ListView.separated(
                    itemCount: records.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    itemBuilder: (context, index) {
                      final item = records[index];
                      return Dismissible(
                        key: Key(item['id'].toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) async {
                          await controller.deleteRecord(item['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '${item['rank']}',
                                  style: AppTextStyles.b1r("white"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${item['record']}',
                                  style: AppTextStyles.b1r("white"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  DateUtil.formatDate(item['updatedAt']),
                                  style: AppTextStyles.b1r("white"),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              )
            ],
          );
        }),
      ),
    );
  }
}
