import 'package:finf_app/controller/static_records_controller.dart';
import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/widget/common/custom_wrapper_widget.dart';
import 'package:finf_app/widget/staticRecord/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectTimeWidget extends StatefulWidget {
  const SelectTimeWidget({super.key});

  @override
  State<SelectTimeWidget> createState() => _SelectTimeWidgetState();
}

class _SelectTimeWidgetState extends State<SelectTimeWidget> {
  final GlobalKey _wrapperKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isPickerVisible = false;
  final StaticRecordsController _controller =
      Get.find<StaticRecordsController>();

  void _togglePicker() {
    if (_isPickerVisible) {
      _hidePicker();
    } else {
      _showPicker();
    }
  }

  void _showPicker() {
    final renderBox =
        _wrapperKey.currentContext?.findRenderObject() as RenderBox?;
    final position = renderBox?.localToGlobal(Offset.zero);
    final size = renderBox?.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: position?.dx ?? 0,
        top: (position?.dy ?? 0) + (size?.height ?? 0) + 10,
        width: size?.width ?? MediaQuery.of(context).size.width,
        child: TimerPicker(isPickerVisible: _isPickerVisible),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isPickerVisible = true;
    });
  }

  void _hidePicker({bool callSetState = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (mounted && callSetState) {
      setState(() {
        _isPickerVisible = false;
      });
    } else {
      _isPickerVisible = false;
    }
  }

  @override
  void dispose() {
    _hidePicker(callSetState: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePicker,
      child: CustomWrapperWidget(
        hasBorder: _isPickerVisible,
        key: _wrapperKey,
        radius: 8,
        backgroundColor: Theme.of(context).primaryColor,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "기록 직접 입력하기",
              style: AppTextStyles.b1r("white"),
            ),
            !_isPickerVisible
                ? Icon(
                    Icons.expand_less,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  )
                : TextButton(
                    onPressed: () {
                      print('선택된 시간: ${_controller.selectedTime.value}');
                      _hidePicker();
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '확인',
                      style: AppTextStyles.b3m("white"),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
