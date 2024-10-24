import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Activity_LoanTrxDetails extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoanTrxDetails();

}

class LoanTrxDetails extends State<Activity_LoanTrxDetails>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Loan Transaction Details",
         style: TextStyle(
             color: Theme.of(context).canvasColor,
             fontWeight: FontWeight.bold,
             fontSize: 18
         )
     ),

         backgroundColor: Theme.of(context).primaryColor,
         iconTheme: IconThemeData(
             color: Theme.of(context).canvasColor
         )),

   );
  }

}