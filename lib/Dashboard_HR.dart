import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_Leave_List.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';

class Activity_Apply_Leaves extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => ActivityApplyLeaves_State();

  }

class ActivityApplyLeaves_State extends State<Activity_Apply_Leaves> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Human Resources",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
      backgroundColor: Color(CustomColor.Corp_Red.value),iconTheme: IconThemeData(color: Colors.white)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height,
          child: GridView.count(crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              MenuCardView(Icons.holiday_village,"Apply Leaves", () async{
                Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Leave_List()));
              }),

              MenuCardView(Icons.local_atm,"Apply For Loan", () async{
                //Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Leave_List()));
              })
            ],
          ),

        ),
      ),

    );
  }

}

Widget MenuCardView(IconData iconData, String MenuName,VoidCallback onPressed){
  return GestureDetector(
  onTap: onPressed,
  child: Card(
    elevation: 8,
    color: Colors.black,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData,color: Colors.white,size: 55),
        Padding(padding: const EdgeInsets.only(top: 10),
        child: Text(MenuName,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)))
      ],
    ),
  ),
  );

}