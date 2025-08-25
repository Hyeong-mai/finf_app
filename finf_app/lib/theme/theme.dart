import 'package:flutter/material.dart';

class AppTheme {
  // 공통으로 사용할 색상 정의
  static const primaryColor = Color.fromRGBO(21, 77, 108, 0.72);
  static const buttonColor = Color(0xFF52B6EC);
  static const buttonTextColor = Colors.white;
  static const yellowColor = Color(0xFFFFCF72);
  static const lightTextColor = Colors.black;
  static const darkTextColor = Colors.white;
  static const grayColor = Color(0xFFEFF0F1);
  static const appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent, // 완전 투명
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),

    surfaceTintColor: Colors.transparent, // Material 3 대응
    shadowColor: Colors.transparent, // 그림자 완전 제거
  );
  // 라이트 테마
  static ThemeData lightTheme = ThemeData(
    // 기본 밝기 모드
    brightness: Brightness.light,

    // 기본 색상 스키마
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: Colors.transparent,
      secondaryContainer: buttonColor,
    ),

    // 스캐폴드 배경색
    scaffoldBackgroundColor: Colors.white,

    // 앱바 테마

    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: buttonTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 0, // 그림자 제거
      ),
    ),

    // 텍스트 버튼 테마
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: buttonColor,
      ),
    ),

    // 입력 필드 테마
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );

  // 다크 테마
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: buttonTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        elevation: 0, // 그림자 제거
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: buttonColor,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),
  );
}
