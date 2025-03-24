import 'package:flutter/material.dart';
import 'package:gezify/core/configs/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      primaryColor: AppColors.splashColor,
      scaffoldBackgroundColor: AppColors.bgColor,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))));

  static final darkTheme = ThemeData(
      primaryColor: AppColors.splashColor,
      scaffoldBackgroundColor: AppColors.darkBgColor,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)))));
}
