import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final double? width;
  final double? radius;

  const CustomButtonWidget({
    super.key,
    required this.child,
    this.width,
    this.radius,
    required this.padding,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 8)),
        child: Container(
          width: width,
          color: backgroundColor,
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
