import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_AppliedLoanList.dart';
import 'package:inland_sales_upgrade/Activity_Leave_List.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';

class Activity_Apply_Leaves extends StatefulWidget {
  final Function(ThemeData) onThemeChange;
  const Activity_Apply_Leaves({super.key, required this.onThemeChange});

  @override
  State<StatefulWidget> createState() => ActivityApplyLeaves_State();

  }

class ActivityApplyLeaves_State extends State<Activity_Apply_Leaves> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),
      appBar: AppBar(
          title: Text("Human Resources",
          style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.bold
          )),

          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: const IconThemeData(
              color: Colors.white
          )),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery
              .of(context)
              .size
              .height, //MediaQuery.of(context).size.height
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: [
              Utility().BuildCircleMenuItems("Apply Leaves", Icons.holiday_village, Theme.of(context).primaryColor, () async {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Activity_Leave_List(onThemeChange: widget.onThemeChange,)));
              }),

              Utility().BuildCircleMenuItems("Apply For Loan", Icons.local_atm, Theme.of(context).primaryColor, () async {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => Activity_Leave_List(onThemeChange: widget.onThemeChange,)));
              }),
            ],
          ),

        ),
      ),

    );
  }
}