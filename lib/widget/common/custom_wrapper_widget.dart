import 'package:flutter/material.dart';

class CustomWrapperWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final double? radius;
  final bool hasBorder;

  const CustomWrapperWidget({
    super.key,
    this.backgroundColor = Colors.black,
    required this.child,
    this.width,
    this.height,
    this.radius,
    this.hasBorder = false, //
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 24),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: hasBorder // border 조건부 적용
              ? Border.all(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  width: 1,
                )
              : null, // border가 false면 테두리 없음
        ),
        width: width,
        height: height,
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
