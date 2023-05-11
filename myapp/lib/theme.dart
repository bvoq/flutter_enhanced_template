import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.grey,
  fontFamily: fontFamily,
  fontFamilyFallback: const ['Roboto'],
  useMaterial3: true,
  textTheme: typography,
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    outline: Colors.orange,
    error: Colors.red,
    onError: Colors.white,
    inversePrimary: Colors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.grey,
  fontFamily: fontFamily,
  fontFamilyFallback: const ['Roboto'],
  useMaterial3: true,
  textTheme: typography,
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: Colors.orange,
    onPrimary: Colors.black,
    background: Colors.black,
    onBackground: Colors.white,
    outline: Colors.orange,
    error: Colors.red,
    onError: Colors.red,
    inversePrimary: Colors.black,
  ),
);

final ThemeData highcontrastLightTheme = ThemeData(
  primarySwatch: Colors.grey,
  fontFamily: fontFamily,
  fontFamilyFallback: const ['Roboto'],
  useMaterial3: true,
  textTheme: typography,
  colorScheme: const ColorScheme.highContrastLight(
    brightness: Brightness.light,
    primary: Colors.green,
    onPrimary: Colors.white,
    background: Colors.white,
    onBackground: Colors.black,
    outline: Colors.orange,
    error: Colors.red,
    onError: Colors.white,
    inversePrimary: Colors.white,
  ),
);

final ThemeData highcontrastDarkTheme = ThemeData(
  primarySwatch: Colors.grey,
  fontFamily: fontFamily,
  fontFamilyFallback: const ['Roboto'],
  useMaterial3: true,
  textTheme: typography,
  colorScheme: const ColorScheme.highContrastDark(
    brightness: Brightness.dark,
    primary: Colors.orange,
    onPrimary: Colors.black,
    background: Colors.black,
    onBackground: Colors.white,
    outline: Colors.orange,
    error: Colors.red,
    onError: Colors.red,
    inversePrimary: Colors.black,
  ),
);

const String fontFamily = 'Roboto';

TextTheme typography = const TextTheme(
  headlineLarge: TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    wordSpacing: 0.16,
  ),
  titleLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    wordSpacing: 0.16,
  ),
  titleMedium: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    wordSpacing: 0.16,
  ),
  titleSmall: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    wordSpacing: 0.16,
  ),
  labelLarge: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    wordSpacing: 0.16,
  ),
  labelMedium: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    wordSpacing: 0.16,
  ),
  labelSmall: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    wordSpacing: 0.16,
  ),
);
