import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class AppThemes {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor, Brightness.light);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor, Brightness.dark);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor, Brightness brightness) {
    return ThemeData(
      primaryColor: colorScheme.primary,
      primaryColorLight: brightness == Brightness.light ? primaryColorLight : darkPrimaryColorLight,
      colorScheme: colorScheme,
      appBarTheme: appBarTheme(brightness),
      iconTheme: iconTheme(brightness),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      focusColor: focusColor,
      buttonTheme: ButtonThemeData(
        buttonColor: colorScheme.onSurface,
      ),
      textTheme: textTheme(brightness),
      fontFamily: 'Roboto',
      dividerColor: brightness == Brightness.light ? dividerColor : darkDividerColor,
      disabledColor: brightness == Brightness.light ? disabledColor : darkDisabledColor,
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
      ),
      bottomNavigationBarTheme: bottomNavigationBarTheme(brightness),
      listTileTheme: listTileTheme(brightness),
    );
  }

  static AppBarTheme appBarTheme(Brightness brightness) {
    return AppBarTheme(
      foregroundColor: Colors.white,
      color: brightness == Brightness.light ? lightColorScheme.primary : darkColorScheme.primary,
      elevation: 0,
      systemOverlayStyle:
          brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
  }

  static IconThemeData iconTheme(Brightness brightness) {
    return IconThemeData(color: brightness == Brightness.light ? Colors.black : Colors.white);
  }

  static BottomNavigationBarThemeData bottomNavigationBarTheme(Brightness brightness) {
    return BottomNavigationBarThemeData(
      backgroundColor: brightness == Brightness.light ? Colors.white : darkScaffoldBackgroundColor,
      selectedItemColor: brightness == Brightness.light ? primaryColor : primaryColor,
      unselectedItemColor: brightness == Brightness.light ? Colors.black : Colors.white,
    );
  }

  static ListTileThemeData listTileTheme(Brightness brightness) {
    return ListTileThemeData(
      textColor: brightness == Brightness.light ? Colors.black : Colors.white,
      tileColor: brightness == Brightness.light ? Colors.white : darkScaffoldBackgroundColor,
    );
  }

  static TextTheme textTheme(Brightness brightness) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 96,
        fontWeight: FontWeight.w300,
        letterSpacing: -1.5,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      displayMedium: TextStyle(
        fontSize: 60,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.5,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      displaySmall: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w400,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.25,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        letterSpacing: 1.5,
        color: brightness == Brightness.light ? Colors.black : Colors.white,
      ),
    );
  }

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
    primary: darkPrimaryColor,
    secondary: darkSecondaryColor,
    background: darkScaffoldBackgroundColor,
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




// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'colors.dart';

// class AppThemes {
//   static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
//   static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

//   static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor, Brightness.light);
//   static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor, Brightness.dark);

//   static ThemeData themeData(ColorScheme colorScheme, Color focusColor, Brightness brightness) {
//     return ThemeData(
//       primaryColor: colorScheme.primary,
//       primaryColorLight: primaryColorLight,
//       colorScheme: colorScheme,
//       appBarTheme: AppBarTheme(
//         foregroundColor: Colors.white,
//         color: colorScheme.primary,
//         elevation: 0,
//         systemOverlayStyle: SystemUiOverlayStyle.light,
//       ),
//       iconTheme: IconThemeData(color: colorScheme.onSurface),
//       canvasColor: colorScheme.background,
//       scaffoldBackgroundColor: colorScheme.background,
//       highlightColor: Colors.transparent,
//       focusColor: focusColor,
//       buttonTheme: ButtonThemeData(
//         buttonColor: colorScheme.onSurface,
//       ),
//       textTheme: textTheme,
//       fontFamily: 'Roboto',
//       dividerColor: dividerColor,
//       disabledColor: disabledColor,
//       progressIndicatorTheme: ProgressIndicatorThemeData(
//         color: colorScheme.primary,
//       ),
//     );
//   }

//   static const textTheme = TextTheme(
//     titleLarge: TextStyle(fontSize: 15.0, color: Colors.black, height: 1.3),
//     titleMedium: TextStyle(fontSize: 16.0, color: Colors.black, height: 1.3),
//     titleSmall: TextStyle(
//       fontSize: 17.0,
//       fontWeight: FontWeight.w500,
//       color: Colors.black,
//       height: 1.3,
//     ),
//   );

//   static const ColorScheme lightColorScheme = ColorScheme(
//     primary: primaryColor,
//     secondary: secondaryColor,
//     background: scaffoldBackgroundColor,
//     surface: Colors.white,
//     onBackground: Colors.black,
//     error: Colors.red,
//     onError: Colors.white,
//     onPrimary: Colors.white,
//     onSecondary: Colors.black,
//     onSurface: primaryColor,
//     brightness: Brightness.light,
//   );

//   static const ColorScheme darkColorScheme = ColorScheme(
//     primary: primaryColor,
//     secondary: secondaryColor,
//     background: blackColor,
//     surface: Color(0xff1E2746),
//     onBackground: Colors.white,
//     error: Colors.red,
//     onError: Colors.white,
//     onPrimary: Colors.white,
//     onSecondary: Colors.white,
//     onSurface: Colors.white,
//     brightness: Brightness.dark,
//   );
// }
