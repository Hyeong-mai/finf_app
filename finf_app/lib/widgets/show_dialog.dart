import 'package:finf_app/theme/app_text_style.dart';
import 'package:finf_app/theme/theme.dart';
import 'package:flutter/material.dart';

class ShowDialog extends StatelessWidget {
  final String title;
  final String content;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftButtonPressed;
  final VoidCallback onRightButtonPressed;

  const ShowDialog({
    super.key,
    required this.title,
    required this.content,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonPressed,
    required this.onRightButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: AppTheme.darkTextColor,
      title: Text(title, style: AppTextStyles.h3m('black')),
      content: Text(content, style: AppTextStyles.b3r('black')),
      actions: [
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.grayColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: onLeftButtonPressed,
                    child: Text(leftButtonText, style: AppTextStyles.b3m('black')),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.buttonColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: onRightButtonPressed,
                    child: Text(rightButtonText, style: AppTextStyles.b3m('white')),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
