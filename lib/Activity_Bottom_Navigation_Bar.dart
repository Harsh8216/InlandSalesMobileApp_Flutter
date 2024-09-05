import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inland_sales_upgrade/Activity_Dashboard.dart';
import 'package:inland_sales_upgrade/Activity_Leave_List.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
class BottomNavBar extends StatefulWidget {
  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Activity_Dashboard(),
    Activity_Leave_List(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        height: 60,
        buttonBackgroundColor: Color(CustomColor.Corp_Red.value),
        color: Color(CustomColor.Corp_Red.value),
        items: [
          Icon(Icons.home,color: Colors.white,size: 30),
          Icon(Icons.edit_location_alt,color: Colors.white,size: 30),
          Icon(Icons.account_circle,color: Colors.white,size: 30),
        ],
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });

        },

        backgroundColor: Colors.white,
      ),
      body: _pages[_selectedIndex],

    );
  }
}