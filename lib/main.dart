import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:post/config/theamdata.dart';
import 'package:post/view/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Ensure you have the correct design size
      minTextAdapt: true, // Text scaling enabled
      splitScreenMode: true, // For multiple screens support
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Social media',
          theme: lightMode,
         // darkTheme: darkMode,
          home: SplashScreen(),
        );
      },
    );
  }
}
