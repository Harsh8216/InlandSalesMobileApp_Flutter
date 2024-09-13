import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Login_Activity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Activity_Bottom_Navigation_Bar.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    isLogedIn();
    _controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2));

    _animation = Tween<double> (begin: 0.0,end: 1.0).animate(_controller);
    _controller.forward();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Colors.white,
          child: AnimatedBuilder(
              animation: _controller,
              builder: (context,child){
                return Transform.scale(
                    scale: _animation.value,
                    child: Center(child: Image.asset("assets/images/splash_logo.png")));

              }
          ),
        ));
  }

  Future<void> isLogedIn() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String ? UserId = pref.getString("user_id");

    Timer(Duration(seconds: 5),(){
      if(UserId != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavBar()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
      }

    });
  }
}