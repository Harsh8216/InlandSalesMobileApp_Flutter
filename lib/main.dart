import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Activity_Splash_Screen.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<ThemeData> _themeNotifier = ValueNotifier(ThemeData.light());

  @override
  void initState() {
    super.initState();
    LoadSavedTheme();
  }


  void _changeTheme(ThemeData theme){
    setState(() {
      _themeNotifier.value = theme;
    });

  }

  Future<void> LoadSavedTheme() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? theme = prefs.getString('selectedTheme');

    if(theme != null){
      switch(theme){
        case 'Skyblue_white':
        _themeNotifier.value = ThemeData(
              primaryColor: CustomColor.Corp_Skyblue,
              canvasColor: Colors.white,
              primaryColorDark: Colors.black,
              indicatorColor: CustomColor.Corp_Skyblue,
              hoverColor: Colors.black,
              focusColor: CustomColor.Corp_Red
          );
          break;
        case 'Blue_White':
      _themeNotifier.value = ThemeData(
            primaryColor: CustomColor.Corp_blue,
            canvasColor: Colors.white,
            primaryColorDark: Colors.black,
            indicatorColor: CustomColor.Corp_blue,
            hoverColor: Colors.black,
            focusColor: CustomColor.Corp_Red
          );
          break;

        case 'Red_White':
      _themeNotifier.value = ThemeData(
            primaryColor: CustomColor.Corp_Red,
            canvasColor: Colors.white,
            primaryColorDark: Colors.black,
            indicatorColor: CustomColor.Corp_Red,
            hoverColor: Colors.black,
            focusColor: CustomColor.Corp_blue
          );
          break;

        case 'Red_Black':
      _themeNotifier.value = ThemeData(
            primaryColor: CustomColor.Corp_Red,
            canvasColor: Colors.white,
            primaryColorDark: Colors.black,
            cardColor: Colors.black87,
            indicatorColor: Colors.white,
            hoverColor: Colors.white,
            focusColor: CustomColor.Corp_blue
          );
          break;

        case 'Blue_Black':
          _themeNotifier.value = ThemeData(
              primaryColor: CustomColor.Corp_blue,
              canvasColor: Colors.white,
              primaryColorDark: Colors.black,
              indicatorColor: Colors.white,
              hoverColor: Colors.white,
              cardColor: Colors.black87,
              focusColor: CustomColor.Corp_Red
          );
          break;

        case 'Skyblue_Black':
          _themeNotifier.value = ThemeData(
              primaryColor: CustomColor.Corp_Skyblue,
              canvasColor: Colors.white,
              primaryColorDark: Colors.black,
              indicatorColor: Colors.white,
              hoverColor: Colors.white,
              cardColor: Colors.black87,
              focusColor: CustomColor.Corp_Red
          );
          break;

        default:
          _themeNotifier.value = ThemeData(
            primaryColor: CustomColor.Corp_Red,
            canvasColor: Colors.white,
            primaryColorDark: Colors.black,
            indicatorColor: CustomColor.Corp_Red,
            hoverColor: Colors.black,
            focusColor: CustomColor.Corp_Skyblue
          );
      }
    }else{
      _themeNotifier.value = ThemeData(
        primaryColor: CustomColor.Corp_Red,
        canvasColor: Colors.white,
        primaryColorDark: Colors.black,
        indicatorColor: CustomColor.Corp_Red,
        hoverColor: Colors.black,
        focusColor: CustomColor.Corp_Skyblue
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _themeNotifier,
        builder: (context,ThemeData currentTheme,_){
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Inland World Logistic',
              theme: currentTheme,
              home: Scaffold(
              body: SplashScreen(onThemeChange: _changeTheme,),
              drawer: SideNavigationDrawer(onThemeChange: _changeTheme),

          ),

          );
        }
    );

  }
}
