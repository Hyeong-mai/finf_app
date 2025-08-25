import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CommonBox extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final VoidCallback? onTap;
  final double? width;

  const CommonBox({
    super.key,
    required this.child,
    this.padding,
    this.decoration,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final defaultDecoration = BoxDecoration(
      color: AppTheme.primaryColor.withOpacity(0.72),
      borderRadius: BorderRadius.circular(24),
    );

    final defaultPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 16,
    );

    Widget boxContent = Container(
      width: width,
      padding: padding ?? defaultPadding,
      decoration: decoration ?? defaultDecoration,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: boxContent,
        ),
      );
    }

    return boxContent;
  }
}
