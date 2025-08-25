import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/svg_icon.dart';
import 'package:flutter/material.dart';

class SelectTitle extends StatelessWidget {
  const SelectTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgIcon(
          url: "assets/icons/time.svg",
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          "기록 직접 입력",
          style: AppTextStyles.b2m("white"),
        ),
      ],
    );
  }
}
