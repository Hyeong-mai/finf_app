import 'package:finf_app/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['스테틱', '시간 기반', '호흡 기반'];

    return SizedBox(
      height: 36,
      // decoration: const BoxDecoration(
      //   color: Colors.white,
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(3, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: double.infinity, // ✅ 세로 꽉 차게
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? Theme.of(context).scaffoldBackgroundColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    labels[index],
                    style: AppTextStyles.b1m(isSelected ? "white" : "gray"),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
