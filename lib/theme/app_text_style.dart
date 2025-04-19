import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const _font = 'Pretendard';
  static const bold = FontWeight.w700;
  static const medium = FontWeight.w500;
  static const regular = FontWeight.w400;

  static const Color defaultColor = Color(0xFF090909);

  static Color getColorByType(String colorType) {
    switch (colorType.toLowerCase()) {
      case 'black':
        return Colors.black;
      case 'white':
        return Colors.white;
      case 'gray':
        return const Color(0xFF798493);
      case 'red':
        return const Color(0xFFFF3B30);
      case 'blue':
        return const Color(0xff007aff);
      case 'yellow':
        return const Color(0xFFFFCF72);
      case 'green':
        return const Color(0xFF34C759);
      case 'primary':
        return const Color.fromRGBO(66, 59, 127, 1);

      default:
        return defaultColor;
    }
  }

  // H1
  static const h1_size = 27;
  static const l_34 = 34;
  static TextStyle h1b(String colorType) => TextStyle(
        fontSize: h1_size.sp,
        fontWeight: bold,
        height: l_34 / h1_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h1m(String colorType) => TextStyle(
        fontSize: h1_size.sp,
        fontWeight: medium,
        height: l_34 / h1_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h1r(String colorType) => TextStyle(
        fontSize: h1_size.sp,
        fontWeight: regular,
        height: l_34 / h1_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //H2
  static const h2_size = 23;
  static const l_30 = 30;
  static TextStyle h2b(String colorType) => TextStyle(
        fontSize: h2_size.sp,
        fontWeight: bold,
        height: l_30 / h2_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h2m(String colorType) => TextStyle(
        fontSize: h2_size.sp,
        fontWeight: medium,
        height: l_30 / h2_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h2r(String colorType) => TextStyle(
        fontSize: h2_size.sp,
        fontWeight: regular,
        height: l_30 / h2_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //H3
  static const h3_size = 21;
  static const l_28 = 28;
  static TextStyle h3b(String colorType) => TextStyle(
        fontSize: h3_size.sp,
        fontWeight: bold,
        height: l_28 / h3_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h3m(String colorType) => TextStyle(
        fontSize: h3_size.sp,
        fontWeight: medium,
        height: l_28 / h3_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h3r(String colorType) => TextStyle(
        fontSize: h3_size.sp,
        fontWeight: regular,
        height: l_28 / h3_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //H4
  static const h4_size = 19;
  static const l_26 = 26;
  static TextStyle h4b(String colorType) => TextStyle(
        fontSize: h4_size.sp,
        fontWeight: bold,
        height: l_26 / h4_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h4m(String colorType) => TextStyle(
        fontSize: h4_size.sp,
        fontWeight: medium,
        height: l_26 / h4_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle h4r(String colorType) => TextStyle(
        fontSize: h4_size.sp,
        fontWeight: regular,
        height: l_26 / h4_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //B1
  static const b1_size = 17;
  static const l_24 = 24;
  static TextStyle b1b(String colorType) => TextStyle(
        fontSize: b1_size.sp,
        fontWeight: bold,
        height: l_24 / b1_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b1m(String colorType) => TextStyle(
        fontSize: b1_size.sp,
        fontWeight: medium,
        height: l_24 / b1_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b1r(String colorType) => TextStyle(
        fontSize: b1_size.sp,
        fontWeight: regular,
        height: l_24 / b1_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //B2
  static const b2_size = 16;
  static const l_22 = 22;
  static TextStyle b2b(String colorType) => TextStyle(
        fontSize: b2_size.sp,
        fontWeight: bold,
        height: l_22 / b2_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b2m(String colorType) => TextStyle(
        fontSize: b2_size.sp,
        fontWeight: medium,
        height: l_22 / b2_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b2r(String colorType) => TextStyle(
        fontSize: b2_size.sp,
        fontWeight: regular,
        height: l_22 / b2_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //B3
  static const b3_size = 13;
  static const l_20 = 20;
  static TextStyle b3b(String colorType) => TextStyle(
        fontSize: b3_size.sp,
        fontWeight: bold,
        height: l_20 / b3_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b3m(String colorType) => TextStyle(
        fontSize: b3_size.sp,
        fontWeight: medium,
        height: l_20 / b3_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b3r(String colorType) => TextStyle(
        fontSize: b3_size.sp,
        fontWeight: regular,
        height: l_20 / b3_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b3underline(String colorType) => TextStyle(
        fontSize: b3_size.sp,
        fontWeight: regular,
        height: l_20 / b3_size,
        fontFamily: _font,
        decoration: TextDecoration.underline,
        decorationColor: getColorByType(colorType),
        color: getColorByType(colorType),
      );

  //B4
  static const b4_size = 13;
  static const l_15 = 15;
  static TextStyle b4b(String colorType) => TextStyle(
        fontSize: b4_size.sp,
        fontWeight: bold,
        height: l_15 / b4_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b4m(String colorType) => TextStyle(
        fontSize: b4_size.sp,
        fontWeight: medium,
        height: l_15 / b4_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
  static TextStyle b4r(String colorType) => TextStyle(
        fontSize: b4_size.sp,
        fontWeight: regular,
        height: l_15 / b4_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );

  //Nav
  static const Nav_size = 11;
  static const l_14 = 14;
  static TextStyle nav(String colorType) => TextStyle(
        fontSize: Nav_size.sp,
        fontWeight: bold,
        height: l_14 / Nav_size,
        fontFamily: _font,
        color: getColorByType(colorType),
      );
}
