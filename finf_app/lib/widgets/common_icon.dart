import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonIcon extends StatelessWidget {
  final String iconPath;
  final double? width;
  final double? height;
  final Color? color;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;

  const CommonIcon({
    super.key,
    required this.iconPath,
    this.width,
    this.height,
    this.color,
    this.onTap,
    this.padding,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {

  

    Widget iconContent = Container(
      padding: padding ?? const EdgeInsets.all(0),
      child: SvgPicture.asset(
        'assets/icons/$iconPath',
        width: width ?? 48.sp,
        height: height ?? 48.sp,
        colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,

          child: iconContent,
        ),
      );
    }

    return iconContent;
  }
}
