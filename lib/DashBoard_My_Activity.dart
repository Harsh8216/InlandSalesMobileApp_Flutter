import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_Visit_Entry.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';

class DashBoard_My_Activity extends StatefulWidget {
  final Function(ThemeData) onThemeChange;

  const DashBoard_My_Activity({
    super.key, required this.onThemeChange
  });

  @override
  State<DashBoard_My_Activity> createState() => _DashBoard_My_ActivityState();
}

class _DashBoard_My_ActivityState extends State<DashBoard_My_Activity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),
      appBar: Utility().Custom_AppBar(context, "My Activity Dashboard"),

       body: SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: GridView.count(
             crossAxisCount: 3,
             crossAxisSpacing: 15,
             mainAxisSpacing: 15,
             shrinkWrap: true,
             physics: NeverScrollableScrollPhysics(),
             children: [
               Utility().BuildCircleMenuItems("Visit Entry",
                   Icons.note_alt,
                   Theme.of(context).primaryColor,
                   (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ActivityVisitEntry(onThemeChange: widget.onThemeChange)));


                   }),

               Utility().BuildCircleMenuItems("Lead Entry", Icons.note_add_rounded,Theme.of(context).primaryColor,(){

               }),
               Utility().BuildCircleMenuItems("My Office Job", Icons.cases_sharp,Theme.of(context).primaryColor,(){

               }),
               Utility().BuildCircleMenuItems("Send Company Profile", Icons.badge_outlined,Theme.of(context).primaryColor,(){

               }),
               Utility().BuildCircleMenuItems("My Office Job Entry Request", Icons.account_balance_rounded,Theme.of(context).primaryColor,(){

               }),
               Utility().BuildCircleMenuItems("Send Quotation", Icons.quick_contacts_dialer_outlined,Theme.of(context).primaryColor,(){

               }),

             ],

           ),
         ),
       )

    );
  }
}