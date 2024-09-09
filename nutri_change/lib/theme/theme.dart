import 'package:flutter/material.dart';

// Define your custom colors
const Color kBackgroundColor = Color(0xFF00A1FF);
const Color kTableTopColor = Color(0xFF00D8FF);
const Color kTableBottomColor = Color(0xFFD0F9FF);
const Color kRedButtonColor = Color(0xFFFF6505);
const Color kGreenButtonColor = Color(0xFF7ED957);

// Dark Mode Colors
const Color kBackgroundDarkColor = Color(0xFF003070);
const Color kTableTopDarkColor = Color(0xFF4D4C4E);
const Color kTableBottomDarkColor = Color(0xFF656467);
const Color kTableContentDarkColor = Color(0xFF1D2020);
const Color kDarkRedButtonColor = Color(0xFFCC5200);
const Color kDarkGreenButtonColor = Color(0xFF599B3F);

ThemeData klightTheme = ThemeData(
// Light Theme
  brightness: Brightness.light,
  primaryColor: kBackgroundColor,
  scaffoldBackgroundColor: kBackgroundColor,
  appBarTheme: const AppBarTheme(
    color: kBackgroundColor,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: kRedButtonColor, // Default button color
    textTheme: ButtonTextTheme.primary,
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: Colors.white, fontSize: 20),
    bodySmall: TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
  ),
  colorScheme: const ColorScheme.light(
    primary: kBackgroundColor,
    secondary: kTableTopColor,
    surface: kTableBottomColor,
    error: kRedButtonColor,
  ),
);

ThemeData darkTheme = ThemeData(
  // Dark Theme
  brightness: Brightness.dark,
  primaryColor: kBackgroundDarkColor,
  scaffoldBackgroundColor: kBackgroundDarkColor,
  appBarTheme: const AppBarTheme(
    color: kBackgroundDarkColor,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: kDarkRedButtonColor, // Default button color
    textTheme: ButtonTextTheme.primary,
  ),
  colorScheme: const ColorScheme.dark(
    primary: kBackgroundDarkColor,
    secondary: kTableTopDarkColor,
    surface: kTableBottomDarkColor,
    error: kDarkRedButtonColor,
  ),
);
