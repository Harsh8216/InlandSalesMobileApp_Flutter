import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_Bottom_Navigation_Bar.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Login_Activity.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideNavigationDrawer extends StatefulWidget{

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  String strEmpName = "";
  String strUserId = "";

  @override
  void initState() {
    super.initState();
    sharedPrefData();
  }

  Future<void> sharedPrefData() async{
    try{
      var  pref = await SharedPreferences.getInstance();
      var _strEmpName = pref.getString(Constant.Name) ?? '';
      var _UserId = pref.getString(Constant.Empcd) ?? '';

      setState(() {
        strEmpName =_strEmpName;
        strUserId = _UserId;
      });

    }catch(error){
      print(error);

    }
  }

  @override
  Widget build(BuildContext context) {
   return Drawer(
     child: Column(
       children: <Widget>[
         UserAccountsDrawerHeader(
             accountName: Text('$strEmpName',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
             accountEmail: Text("User Id : $strUserId",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
             currentAccountPicture: CircleAvatar(
               backgroundColor: Colors.white,
               child: Text(strEmpName.isNotEmpty ? strEmpName[0].toUpperCase() : 'N/A',
                   style: TextStyle(fontSize: 40.0)) ,
             ),
             decoration: BoxDecoration(
                 color: CustomColor.Corp_Red
             )
         ),
         BuildDrawerMenuItems(Icons.home,'Home',(){
           Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavBar()));

         }),
         BuildDrawerMenuItems(Icons.edit_location_alt,'Change Location',(){

         }),
         BuildDrawerMenuItems(Icons.settings,'Setting',(){

         }),
         BuildDrawerMenuItems(Icons.password,'Reset Password',(){

         }),
         BuildDrawerMenuItems(Icons.logout,'Logout',() async {
           await _Logout();

         })
       ],

     ),
   );
  }
  Future <void> _Logout() async{
    var pref = await SharedPreferences.getInstance();
    await pref.remove("user_id");
    await pref.remove("Password");

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Logged out successfully',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            duration: Duration(seconds: 3)));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}

 Widget BuildDrawerMenuItems(IconData iconData,String text,VoidCallback onPress){
  return ListTile(
    leading: Icon(iconData,color: CustomColor.Corp_Red,size: 26),
    title: Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: CustomColor.Corp_blue),),
    onTap: onPress
  );
}


