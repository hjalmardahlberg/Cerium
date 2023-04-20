import 'package:flutter/material.dart';

class ThemeManager with ChangeNotifier{
  ThemeMode themeMode = ThemeMode.light;

  get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(bool isDark){
    themeMode = isDark?ThemeMode.dark:ThemeMode.light;
    notifyListeners();
  }
}

final lightTheme = ThemeData(
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
      backgroundColor: Colors.white,
    ),
    iconTheme:  IconThemeData(color: Colors.black),
   // backgroundColor: Colors.white,
    // Set the AppBar background color for the light mode
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white, // set the background color of the BottomNavigationBar
    selectedItemColor: Colors.black, // set the color of the selected item
    unselectedItemColor: Colors.grey, // set the color of the unselected item
  ),
  primaryIconTheme: const IconThemeData(
    color: Colors.black, // change the default icon color to black in the light theme
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.white, // set the text color to black
    ),
    iconTheme:  IconThemeData(color: Colors.white),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey.shade800, // set the background color of the BottomNavigationBar
    selectedItemColor: Colors.black, // set the color of the selected item
    unselectedItemColor: Colors.grey, // set the color of the unselected item
  ),
);

final themeData = ThemeData(
appBarTheme: const AppBarTheme(
//backgroundColor: Colors.grey, // Set the AppBar background color for the system mode
),
brightness: Brightness.light,
visualDensity: VisualDensity.adaptivePlatformDensity,
// Set any other properties that you want to apply
);