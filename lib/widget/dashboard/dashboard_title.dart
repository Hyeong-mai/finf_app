import 'package:finf_app/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class DashboardTitle extends StatelessWidget {
  const DashboardTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CO2 TABLE",
          style: AppTextStyles.h2m("white"),
        ),
        const SizedBox(
          height: 16,
        ),
        Text(
          "스테틱 최고기록에 따라 숨참기 시간이 지정돼요",
          style: AppTextStyles.b1r("white"),
        ),
      ],
    );
  }
}
