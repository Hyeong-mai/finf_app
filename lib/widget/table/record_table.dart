import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';

class RecordTable extends StatelessWidget {
  const RecordTable({
    super.key,
    required this.data,
  });

  final List<Map<String, dynamic>> data;

  @override
  Widget build(BuildContext context) {
    print(data);
    return Column(
      children: [
        CustomWrapperWidget(
          backgroundColor: Theme.of(context).primaryColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: Text('순위',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r("white"))),
                    Expanded(
                        child: Text('기록',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r("white"))),
                    Expanded(
                        child: Text('날짜',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.b1r("white"))),
                  ],
                ),
              ),
              // 💡 ListView 높이 명확히 설정
              SizedBox(
                height: 400,
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (_, __) => Divider(
                    color: const Color(0xFF154D6C).withOpacity(0.72),
                  ),
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text('${item['rank']}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.b1r("white"))),
                          Expanded(
                              child: Text('${item['record']}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.b1r("white"))),
                          Expanded(
                              child: Text('${item['date']}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.b1r("white"))),
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    url: "assets/icons/clock.svg",
                    size: 16,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  Text(
                    "총 n분 동안 훈련 진행",
                    style: AppTextStyles.b3r("white"),
                  ),
                ],
              ),
              Text(
                "스태틱 최고 기록에 따라 시간이 지정돼요",
                style: AppTextStyles.b3r("white"),
              ),
            ],
          ),
        )
      ],
    );
  }
}
