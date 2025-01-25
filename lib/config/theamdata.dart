import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Define the common light mode and dark mode themes
import 'package:flutter/material.dart';

final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,  // Enabling Material 3
  primaryColor: const Color(0xFF2196F3),  // Blue primary color
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),  // Light Beige background
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xffBC30AA).withOpacity(0.7),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r), // Rounded buttons
      ),
    ),
  ),
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: Colors.white),
    elevation: 0,
    backgroundColor: Colors.deepPurple.withOpacity(0.8),
    surfaceTintColor: Color(0xFF2196F3),  // Blue tint on AppBar
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  buttonTheme: const ButtonThemeData(
    textTheme: ButtonTextTheme.primary,  // Button text color
  ),
  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 22,
      color: Color(0xFF212121),
      fontWeight: FontWeight.bold,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: Color(0xFF757575),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(

    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffBC30AA)),  // Pink border when focused
    ),
    contentPadding: EdgeInsets.all(12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    hintStyle: TextStyle(color: Color(0xFF757575)),
    fillColor: Color(0xFFFAFAFA),
    filled: true,
  ),
);

// Dark Mode Theme
  ThemeData darkMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blueGrey,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.white, fontSize: 14.sp),
    bodyMedium: TextStyle(color: Colors.white, fontSize: 16.sp),
    displayLarge: TextStyle(color: Colors.blue, fontSize: 24.sp),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.blueGrey), // Dark blue color for dark mode
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 20.r, vertical: 12.r)),
      shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r))),
    ),
  ),
);