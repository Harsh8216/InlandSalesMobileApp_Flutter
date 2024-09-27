import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_Bottom_Navigation_Bar.dart';
import 'package:inland_sales_upgrade/Color_Combination_Box.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Login_Activity.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SideNavigationDrawer extends StatefulWidget{
  final Function(ThemeData) onThemeChange;

  SideNavigationDrawer({required this.onThemeChange});

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  String strEmpName = "";
  String strUserId = "";
  String strLocation = "";

  @override
  void initState() {
    super.initState();
    sharedPrefData();
  }

  Future<void> saveTheme(String themeName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('selectedTheme', themeName);

  }

  Future<void> sharedPrefData() async {
    try {
      var pref = await SharedPreferences.getInstance();
      var _strEmpName = pref.getString(Constant.Name) ?? '';
      var _UserId = pref.getString(Constant.Empcd) ?? '';
      var _Location = pref.getString(Constant.CurrBrcd) ?? '';


      setState(() {
        strEmpName = _strEmpName;
        strUserId = _UserId;
        strLocation = _Location;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 220,
              child: UserAccountsDrawerHeader(
                  accountName: Text('$strEmpName',
                      style: TextStyle(
                          color: Theme.of(context).canvasColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),

                  accountEmail: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Id : $strUserId",
                          style: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 4,
                      ),
                      Text('Location : $strLocation',
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(strEmpName.isNotEmpty
                        ? strEmpName[0].toUpperCase()
                        : 'N/A',
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Theme.of(context).primaryColor
                        )),
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor
                  )
              ),
            ),
            BuildDrawerMenuItems(Icons.home, 'Home', () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  BottomNavBar(onThemeChange: widget.onThemeChange,)));
            }),

            BuildDrawerMenuItems(
                Icons.edit_location_alt, 'Change Location', () {

            }),

            BuildDrawerMenuItems(Icons.settings, 'Setting', () {
              OpenAppSetting();
            }),

            BuildDrawerMenuItems(Icons.color_lens_rounded, 'Change Themes', () {
              print("Change Themes tapped");
              _ChangeThemeData();

            }),

            BuildDrawerMenuItems(
                Icons.mobile_friendly_sharp, 'Phone Specification', () {

            }),

            BuildDrawerMenuItems(Icons.password, 'Reset Password', () {

            }),


            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: const Divider(
                color: Colors.black12,
                thickness: 1,
              ),
            ),

            BuildDrawerMenuItems(Icons.logout, 'Logout', () async {
              await _Logout();

            }),

          ],

        ),
      ),
    );
  }

  Future <void> _Logout() async {
    var pref = await SharedPreferences.getInstance();
    await pref.remove("user_id");
    await pref.remove("Password");

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Logged out successfully',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            duration: Duration(seconds: 3)));
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => LoginPage(onThemeChange: widget.onThemeChange)));
  }

  void OpenAppSetting() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String PakageName = packageInfo.packageName;

      final AndroidIntent androidIntent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:$PakageName',
      );
      await androidIntent.launch();
    } catch (error) {
      print("Failed to open app settings: $error");
    }
  }


  Widget BuildDrawerMenuItems(IconData iconData, String title,
      VoidCallback onPress) {
    return ListTile(
        leading: Icon(iconData,
            color: Theme
                .of(context)
                .primaryColor,
            size: 26),
        title: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColorDark)),
        onTap: onPress
    );
  }

  void _ChangeThemeData(){
    showDialog(context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            //backgroundColor: Colors.white,
            title: Center(
              child: Text('Select a Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                ),),
            ),
            content: Container(
              height: 180,
              child: Center(
                child: Wrap(
                  spacing: 20.0, // Spacing between boxes
                  runSpacing: 20.0, // Spacing between rows

                  children: [
                    GestureDetector(
                      onTap: () async {
                        widget.onThemeChange?.call(ThemeData(
                            primaryColor: CustomColor.Corp_Skyblue,
                            canvasColor: Colors.white,
                            primaryColorDark: Colors.black,
                            indicatorColor: CustomColor.Corp_Skyblue,
                            hoverColor: Colors.black,
                            focusColor: CustomColor.Corp_Red
                        ));
                        await saveTheme("Skyblue_white");
                        Navigator.pop(context);

                      },
                      child: Column(
                        children: [
                          Color_Combination_Box(
                            firstColor: CustomColor.Corp_Skyblue,
                            secondColor: Colors.white,
                            isHorizontal: false,
                          )
                        ],
                      ) ,
                    ),

                    GestureDetector(
                      onTap: () async {
                        widget.onThemeChange?.call(ThemeData(
                            primaryColor: CustomColor.Corp_blue,
                            canvasColor: Colors.white,
                            primaryColorDark: Colors.black,
                            indicatorColor: CustomColor.Corp_blue,
                            hoverColor: Colors.black,
                            focusColor: CustomColor.Corp_Red
                        ));
                        await saveTheme("Blue_White");
                        Navigator.pop(context);

                      },
                      child: Column(
                        children: [
                          Color_Combination_Box(
                            firstColor: CustomColor.Corp_blue,
                            secondColor: Colors.white,
                            isHorizontal: false,
                          )
                        ],
                      ) ,
                    ),

                    GestureDetector(
                      onTap: () async {
                        widget.onThemeChange?.call(ThemeData(
                            primaryColor: CustomColor.Corp_Red,
                            canvasColor: Colors.white,
                            primaryColorDark: Colors.black,
                            indicatorColor: CustomColor.Corp_Red,
                            hoverColor: Colors.black,
                            focusColor: CustomColor.Corp_blue
                        ));
                        await saveTheme("Red_White");
                        Navigator.pop(context);

                      },
                      child: Column(
                        children: [
                          Color_Combination_Box(
                            firstColor: CustomColor.Corp_Red,
                            secondColor: Colors.white,
                            isHorizontal: false,
                          )
                        ],
                      ) ,
                    ),

                    GestureDetector(
                      onTap: () async{
                        widget.onThemeChange?.call(ThemeData(
                            primaryColor: CustomColor.Corp_Red,
                            canvasColor: Colors.white,
                            primaryColorDark: Colors.black,
                            cardColor: Colors.black87,
                            indicatorColor: Colors.white,
                            hoverColor: Colors.white,
                            focusColor: CustomColor.Corp_blue
                        ));
                        await saveTheme("Red_Black");
                        Navigator.pop(context);

                      },
                      child: Column(
                        children: [
                          Color_Combination_Box(
                            firstColor: CustomColor.Corp_Red,
                            secondColor: Colors.black,
                            isHorizontal: false,
                          )
                        ],
                      ) ,
                    ),

                    GestureDetector(
                      onTap: () async{
                        widget.onThemeChange?.call(ThemeData(
                            primaryColor: CustomColor.Corp_blue,
                            canvasColor: Colors.white,
                            primaryColorDark: Colors.black,
                            indicatorColor: Colors.white,
                            hoverColor: Colors.white,
                            cardColor: Colors.black87,
                            focusColor: CustomColor.Corp_Red
                        ));
                        await saveTheme("Blue_Black");
                        Navigator.pop(context);

                      },
                      child: Column(
                        children: [
                          Color_Combination_Box(
                            firstColor: CustomColor.Corp_blue,
                            secondColor: Colors.black,
                            isHorizontal: false,
                          )
                        ],
                      ) ,
                    ),

                    GestureDetector(
                      onTap: () async{
                        widget.onThemeChange?.call(ThemeData(
                            primaryColor: CustomColor.Corp_Skyblue,
                            canvasColor: Colors.white,
                            primaryColorDark: Colors.black,
                            indicatorColor: Colors.white,
                            hoverColor: Colors.white,
                            cardColor: Colors.black87,
                            focusColor: CustomColor.Corp_Red
                        ));
                        await saveTheme("Skyblue_Black");
                        Navigator.pop(context);

                      },
                      child: Column(
                        children: [
                          Color_Combination_Box(
                            firstColor: CustomColor.Corp_Skyblue,
                            secondColor: Colors.black,
                            isHorizontal: false,
                          )
                        ],
                      ) ,
                    ),

                  ],
                ),
              ),
            ),
          );
        });
  }
}




