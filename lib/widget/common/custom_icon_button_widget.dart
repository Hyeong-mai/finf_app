import 'package:flutter/material.dart';

class CustomIconButtonWrapper extends StatelessWidget {
  final Color backgroundColor;
  final Widget icon;
  final VoidCallback? onPressed;

  const CustomIconButtonWrapper({
    super.key,
    required this.backgroundColor,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.all(16),
          child: icon,
        ),
      ),
    );
  }
}
