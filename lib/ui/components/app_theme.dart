import 'package:flutter/material.dart';

import './theme/theme.dart';

ThemeData makeAppTheme() {
  final primaryColor = colorBrandPrimaryDark;
  final primaryColorDark = colorBrandPrimaryDarkest;
  final primaryColorLight = colorBrandPrimaryMedium;
  final secundaryColor = Color.fromRGBO(0, 77, 64, 1);
  final secondaryColorDark = Color.fromRGBO(0, 36, 26, 1);
  final disableColor = Colors.grey[400];
  final dividerColor = Colors.grey;

  final textTheme = TextTheme(
    headline1: TextStyle(
        fontSize: 30, fontWeight: FontWeight.bold, color: primaryColorDark),
  );

  final inputDecorationTheme = InputDecorationTheme(
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: primaryColorLight,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: primaryColor,
      ),
    ),
    alignLabelWithHint: true,
  );
  final buttonTheme = ButtonThemeData(
    colorScheme: ColorScheme.light(
      primary: primaryColor,
    ),
    buttonColor: primaryColor,
    splashColor: primaryColorLight,
    padding: EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 20,
    ),
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );

  return ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColorDark,
    primaryColorLight: primaryColorLight,
    highlightColor: secundaryColor,
    secondaryHeaderColor: secondaryColorDark,
    disabledColor: disableColor,
    dividerColor: dividerColor,
    colorScheme: ColorScheme.light(primary: primaryColor),
    backgroundColor: Colors.white,
    textTheme: textTheme,
    inputDecorationTheme: inputDecorationTheme,
    buttonTheme: buttonTheme,
  );
}
