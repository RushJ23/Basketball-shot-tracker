import 'package:flutter/material.dart';

// Define color constants for the theme
const Color darkBlue = Color(0xFF003745);
const Color blueBlack = Color(0xFF00171F);
const Color tealBlue = Color(0xFF006D79);
const Color lightTeal = Color(0xFF00B3A4);
const Color lighterTeal = Color(0xFF6ED4C8);
const Color offBlue = Color.fromARGB(255, 179, 208, 215); 
const Color lightGrey = Color(0xFFEDEDED);
const Color accentOrange = Color(0xFFFFA500);

// Light theme configuration
final ThemeData lightThemeData = ThemeData(
  primaryColor: darkBlue,  
  primaryColorLight: tealBlue,  
  primaryColorDark: lightTeal, 
  scaffoldBackgroundColor: lightGrey,
  secondaryHeaderColor: accentOrange,
  
  // Color scheme derived from a seed color for consistency in UI elements.
  colorScheme: ColorScheme.fromSeed(seedColor: tealBlue),
  
  // Button theme for light mode buttons.
  buttonTheme: const ButtonThemeData(
    buttonColor: accentOrange,  
    textTheme: ButtonTextTheme.primary,  
  ),
  
  // Floating action button color settings.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accentOrange,
  ),
  
  // App bar style in light theme.
  appBarTheme: const AppBarTheme(
    color: tealBlue,
  ),
  
  // Bottom navigation bar color and style settings.
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: tealBlue,  
    unselectedItemColor: lightTeal,  
    backgroundColor: lightGrey,
  ),
  
  // Card style in light theme.
  cardTheme: const CardTheme(
    color: offBlue, 
    elevation: 4,  
  ),
  
  // Text styles for different text elements in light mode.
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: offBlue),
    bodyMedium: TextStyle(color: tealBlue),
    bodySmall: TextStyle(color: lightTeal),
    titleLarge: TextStyle(color: offBlue), 
    titleMedium: TextStyle(color: tealBlue),
    labelMedium: TextStyle(color: accentOrange),  
  ),
  
  // Icon color settings.
  iconTheme: const IconThemeData(
    color: offBlue,
  ),
);

// Dark theme configuration
final ThemeData darkThemeData = ThemeData(
  brightness: Brightness.dark,
  primaryColor: lightGrey,  
  primaryColorLight: lighterTeal,  
  primaryColorDark: darkBlue,  
  scaffoldBackgroundColor: darkBlue,  
  secondaryHeaderColor: accentOrange,
  
  // Button theme specifically for dark mode.
  buttonTheme: const ButtonThemeData(
    buttonColor: accentOrange,
    textTheme: ButtonTextTheme.primary,
  ),
  
  // Floating action button style in dark mode.
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: accentOrange,
  ),
  
  // App bar style in dark theme.
  appBarTheme: const AppBarTheme(
    color: darkBlue,
  ),
  
  // Bottom navigation bar colors for dark mode.
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: lighterTeal,  
    unselectedItemColor: lightTeal,  
    backgroundColor: darkBlue,
  ),
  
  // Card style in dark mode.
  cardTheme: const CardTheme(
    color: blueBlack, 
    elevation: 4,
  ),
  
  // Text styles for different text elements in dark mode.
  textTheme: const TextTheme(
    titleLarge: TextStyle(color: lightGrey),  
    titleMedium: TextStyle(color: lighterTeal),
    titleSmall: TextStyle(color: lightTeal),
    bodyLarge: TextStyle(color: lightGrey),
    bodyMedium: TextStyle(color: lighterTeal),
    labelMedium: TextStyle(color: accentOrange),  
  ),
  
  // Icon color settings for dark mode.
  iconTheme: const IconThemeData(
    color: lightGrey,
  ),
);
