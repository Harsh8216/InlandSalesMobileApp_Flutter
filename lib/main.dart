import 'package:flutter/material.dart';
import 'Activity_Splash_Screen.dart';
import 'Custom_Color_file.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(

          primaryColor: Color(CustomColor.Corp_Red.value),
          primarySwatch: Colors.blue
      ),
      home: SplashScreen(),
    );
  }
}
