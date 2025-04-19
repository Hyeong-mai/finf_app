import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String url;
  final double size;
  final Color? color;
  final bool country;

  const SvgIcon({
    super.key,
    required this.url,
    this.size = 28,
    this.color = Colors.black,
    this.country = false,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      url,
      width: size,
      height: size,
      colorFilter: country ? null : ColorFilter.mode(color!, BlendMode.srcIn),
    );
  }
}
