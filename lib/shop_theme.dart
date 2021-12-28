import 'package:flutter/material.dart';

class ShopTheme {
  static ThemeData light() {
    return ThemeData(
      primaryColor: Colors.white,
      colorScheme: const ColorScheme.light().copyWith(
          primary: const Color(0XFFA25D00),
          secondary: const Color(0XFFE97E03),
          error: Colors.redAccent),
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black, size: 25),
        elevation: 0,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      textTheme: lightTextTheme,
    );
  }

  static TextTheme lightTextTheme = const TextTheme(
    headline1: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 17,
        color: Colors.black,
        fontWeight: FontWeight.w800),
    headline2: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 28,
        color: Colors.black,
        fontWeight: FontWeight.w600),
    subtitle1: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 16,
        color: Colors.black54,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2),
    bodyText1: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 22,
        color: Color(0XFF403B58),
        fontWeight: FontWeight.w600),
    bodyText2: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700),
  );
}
