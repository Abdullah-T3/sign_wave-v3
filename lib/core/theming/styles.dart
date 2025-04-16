import 'package:flutter/material.dart';

import 'colors.dart';

class TextStyles {
  static const body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const lightBlueText = TextStyle(
    color: ColorsManager.lightBlue,
    fontSize: 35,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );

  static const buttonsTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );

  static const robotoBold16 = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );

  static const robotoRegular12 = TextStyle(
    color: Colors.grey,
    fontSize: 12,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );
  static const robotoRegular14Black = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );
  static const robotoRegular20White = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );

  static const robotoRegular16White = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.75,
  );
}

class ButtonStyles {}

class AppStyles {
  static ThemeData getThemeData() => ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.blue,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}
