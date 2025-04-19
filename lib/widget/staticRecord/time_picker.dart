import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerPicker extends StatefulWidget {
  final bool isPickerVisible;
  const TimerPicker({super.key, required this.isPickerVisible});

  @override
  State<TimerPicker> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  final StaticRecordsController _controller =
      Get.find<StaticRecordsController>();
  int selectedMinute = 0;
  int selectedSecond = 0;

  final List<int> minuteList = List.generate(60, (i) => i); // 0~59분
  final List<int> secondList = List.generate(60, (i) => i); // 0~59초

  void _updateSelectedTime() {
    final timeString =
        '${selectedMinute.toString().padLeft(2, '0')}:${selectedSecond.toString().padLeft(2, '0')}';
    _controller.setSelectedTime(timeString);
  }

  @override
  Widget build(BuildContext context) {
    return CustomWrapperWidget(
      hasBorder: widget.isPickerVisible,
      radius: 8,
      height: 200,
      width: double.infinity,
      backgroundColor: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 분
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: selectedMinute),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedMinute = index;
                  _updateSelectedTime();
                });
              },
              children: List.generate(
                60,
                (i) => Center(
                  child: Text('$i', style: AppTextStyles.b1r("white")),
                ),
              ),
            ),
          ),
          Text(' : ', style: AppTextStyles.b1r("white")),
          // 초
          SizedBox(
            width: 100,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: selectedSecond),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedSecond = index;
                  _updateSelectedTime();
                });
              },
              children: List.generate(
                60,
                (i) => Center(
                  child: Text(i.toString().padLeft(2, '0'),
                      style: AppTextStyles.b1r("white")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
