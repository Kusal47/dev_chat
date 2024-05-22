import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class AppThemes {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
        primaryColor: colorScheme.primary,
        primaryColorLight: primaryColorLight,
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          foregroundColor: Colors.white,
          color: colorScheme.primary,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        canvasColor: colorScheme.background,
        scaffoldBackgroundColor: colorScheme.background,
        highlightColor: Colors.transparent,
        focusColor: focusColor,
        buttonTheme: ButtonThemeData(
          buttonColor: colorScheme.onSurface,
        ),
        textTheme: textTheme,
        fontFamily: 'Roboto',
        dividerColor: dividerColor,
        disabledColor: disabledColor,
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: colorScheme.primary,
        ));
  }

  static const textTheme = TextTheme(
    titleLarge: TextStyle(fontSize: 15.0, color: Colors.black, height: 1.3),
    titleMedium: TextStyle(fontSize: 16.0, color: Colors.black, height: 1.3),
    titleSmall: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        height: 1.3),
  );

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    background: scaffoldBackgroundColor,
    surface: Colors.white,
    onBackground: Colors.black,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: primaryColor,
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: primaryColor,
    secondary: secondaryColor,
    background: blackColor,
    surface: Color(0xff1E2746),
    onBackground: Colors.white,
    error: Colors.red,
    onError: Colors.white,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.white,
    brightness: Brightness.dark,
  );
}
