import 'package:amir_optic/constants/colors.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

var lightTheme = AppTheme(
    id: "light_theme",
    data: ThemeData(
      // primaryColor: ,
      primaryColor: kLightPrimaryColor,
      appBarTheme: AppBarTheme(
        backgroundColor: kLightPrimaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: kLightPrimaryColor),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kLightPrimaryColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: kLightPrimaryColor),
      ),
      brightness: Brightness.light,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.fuchsia: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.linux: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
        },
      ),
      fontFamily: "Heebo",
      textTheme: const TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.w100,
        ),
        headline4: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        bodyText1: TextStyle(
          fontWeight: FontWeight.w100,
        ),
        subtitle1: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        subtitle2: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
    description: "light theme");

var darkTheme = AppTheme(
    id: "dark_theme",
    data: ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(primary: Colors.purple[200]),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.purple[200],
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.purple[200],
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
      ),
      brightness: Brightness.dark,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.fuchsia: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.linux: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.macOS: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
          TargetPlatform.windows: SharedAxisPageTransitionsBuilder(
            transitionType: SharedAxisTransitionType.horizontal,
          ),
        },
      ),
      fontFamily: "Heebo",
      textTheme: const TextTheme(
        headline6: TextStyle(
          fontWeight: FontWeight.w100,
        ),
        headline4: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        bodyText1: TextStyle(
          fontWeight: FontWeight.w100,
        ),
        subtitle1: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        subtitle2: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        floatingLabelStyle: TextStyle(
          fontWeight: FontWeight.w400,
        ),
        errorStyle: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
    ),
    description: "dark theme");
