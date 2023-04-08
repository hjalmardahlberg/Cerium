import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.system;

  get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isDark){
    themeMode = isDark?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    iconTheme:  IconThemeData(color: Colors.black),
    backgroundColor: Colors.white, // Set the AppBar background color for the light mode
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.black, // change the default icon color to black in the light theme
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    iconTheme:  IconThemeData(color: Colors.white),
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.white, // change the default icon color to white in the dark theme
  ),
);

final themeData = ThemeData(
appBarTheme: const AppBarTheme(
backgroundColor: Colors.grey, // Set the AppBar background color for the system mode
),
brightness: Brightness.light,
visualDensity: VisualDensity.adaptivePlatformDensity,
// Set any other properties that you want to apply
);