import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  const CommonButton({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    );

    final defaultPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    );

    Widget buttonContent = Container(
      padding: padding ?? defaultPadding,
      decoration: decoration ?? defaultDecoration,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: buttonContent,
        ),
      );
    }

    return buttonContent;
  }
}
