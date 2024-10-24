import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:inland_sales_upgrade/Activity_Dashboard.dart';
import 'package:inland_sales_upgrade/Activity_GetLocation.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';

class BottomNavBar extends StatefulWidget {
  final Function(ThemeData) onThemeChange;  // Add this to receive the callback
  const BottomNavBar({super.key, required this.onThemeChange});  // Adjust the constructor


  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: CurvedNavigationBar(
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.fastEaseInToSlowEaseOut,
        height: 60,
        buttonBackgroundColor: Theme.of(context).primaryColor,
        color: Theme.of(context).primaryColor,
        items: [
          Icon(
              Icons.home,
              color: Theme.of(context).canvasColor,
              size: 30),

          Icon(
              Icons.edit_location_alt,
              color: Theme.of(context).canvasColor,
              size: 30),

          Icon(
              Icons.account_circle,
              color: Theme.of(context).canvasColor,
              size: 30),
        ],
        onTap: (index){
          if(index == 2){
            _scaffoldKey.currentState?.openEndDrawer();
          }else {
            setState(() {
            _selectedIndex = index;
            /*if(index == 1){
              locationHelper.LocationAlertDialog(context);

            }*/

          });
          }
        },
        backgroundColor: Colors.white,
      ),
      body: _selectedIndex == 0 ?
      Activity_Dashboard(onThemeChange: widget.onThemeChange)
      : const Activity_Get_Location(),
      endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),

    );
  }
}