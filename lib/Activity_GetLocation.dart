import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';

class Activity_Get_Location extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => Activity_Get_Location_State();

}

class Activity_Get_Location_State extends State<Activity_Get_Location>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Leave List",
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Color(CustomColor.Corp_Red.value),
          iconTheme: IconThemeData(color: Colors.white)),

    );
  }

}