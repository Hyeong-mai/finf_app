import 'package:flutter/material.dart';

class CommonLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  final Color? overlayColor;
  final double overlayOpacity;

  const CommonLayout({
    super.key,
    required this.child,
    this.appBar,

    this.overlayColor,
    this.overlayOpacity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/mainBackground.png'),
          fit: BoxFit.cover,
          colorFilter: overlayColor != null
              ? ColorFilter.mode(
                  overlayColor!.withOpacity(overlayOpacity),
                  BlendMode.darken,
                )
              : null,
        ),
      ),
      child: Column(
        children: [
          if (appBar != null) appBar!,
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// 간단한 백그라운드 이미지 위젯
class BackgroundImage extends StatelessWidget {
  final Widget child;
  final String imagePath;
  final BoxFit fit;
  final Color? overlayColor;
  final double overlayOpacity;

  const BackgroundImage({
    super.key,
    required this.child,
    this.imagePath = 'assets/background/mainBackground.png',
    this.fit = BoxFit.cover,
    this.overlayColor,
    this.overlayOpacity = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: fit,
          colorFilter: overlayColor != null
              ? ColorFilter.mode(
                  overlayColor!.withOpacity(overlayOpacity),
                  BlendMode.darken,
                )
              : null,
        ),
      ),
      child: child,
    );
  }
}

/// 그라데이션 백그라운드 위젯
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final EdgeInsetsGeometry? padding;

  const GradientBackground({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
        ),
      ),
      child: Container(
        padding: padding ?? const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}

/// 반투명 오버레이 위젯
class OverlayContainer extends StatelessWidget {
  final Widget child;
  final Color overlayColor;
  final double opacity;
  final EdgeInsetsGeometry? padding;

  const OverlayContainer({
    super.key,
    required this.child,
    required this.overlayColor,
    this.opacity = 0.7,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: overlayColor.withOpacity(opacity),
      child: Container(
        padding: padding ?? const EdgeInsets.all(24.0),
        child: child,
      ),
    );
  }
}
