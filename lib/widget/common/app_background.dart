import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 배경 이미지
        Image.asset(
          'assets/background/mainBackground.png',
          fit: BoxFit.cover,
        ),
        // 자식 위젯
        child,
      ],
    );
  }
}
