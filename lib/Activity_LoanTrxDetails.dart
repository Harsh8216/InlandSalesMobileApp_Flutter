import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity_LoanTrxDetails extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  final String strLoadId;

  Activity_LoanTrxDetails({
    super.key,
    required this.onThemeChange,
    required this.strLoadId
  });

  @override
  State<Activity_LoanTrxDetails> createState() => LoanTrxDetails();

}

class LoanTrxDetails extends State<Activity_LoanTrxDetails>{
  var arrDataList = [];
  var _strLoadId;

  @override
  void initState() {
    super.initState();
    LoanTrxBody ();
    _strLoadId = widget.strLoadId;
  }
  
  void LoanTrxBody () async{
    var pref = await SharedPreferences.getInstance ();
    String ? strEmployeeId = pref.getString(Constant.Empcd);

    try{

   Map<String,String> requestBody = {
     "Empcd" : '$strEmployeeId',
     "Tokenno" : "2.5",
     "LoanID" : "$_strLoadId",
     
    };
   
   List<dynamic> ResponseBody = await ApiHelper.postRequest(EndPoint.GetLoanTransactionDetails, requestBody);
   print('$ResponseBody');

      setState(() {
     arrDataList = ResponseBody;
   });

    }catch(e){
      Utility().ShowToast("$e");

    }

  }


  @override
  Widget build(BuildContext context) {
   return Scaffold(
     endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),
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

     body: Padding(
       padding: const EdgeInsets.all(10.0),
       child: Container(
         height: 400,
         child: Card(
           elevation: 6,
           color: Colors.white,
           child: Column(
             children: [
               Container(
                 height: 50,
                 child: Row(
                   //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     Expanded(
                       child: Center(
                         child: Text("Month",
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                               fontSize: 14
                           ),
                         ),
                       ),
                     ),

                     VerticalDivider(
                       thickness: 1,
                       width: 5,
                       color: Colors.white,
                     ),

                     Expanded(
                       child: Center(
                         child: Text("Amount",
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                               fontSize: 14
                           ),),
                       ),
                     ),

                     VerticalDivider(
                       thickness: 1,
                       width: 5,
                       color: Colors.white,
                     ),

                     Expanded(
                       child: Center(
                         child: Text("Status",
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                               fontSize: 14
                           ),),
                       ),
                     ),

                     VerticalDivider(
                       thickness: 1,
                       width: 5,
                       color: Colors.white,
                     ),

                     Expanded(
                       child: Center(
                         child: Text("EMI Mode",
                           style: TextStyle(
                               fontWeight: FontWeight.bold,
                               color: Colors.white,
                               fontSize: 14
                           )),
                       ),
                     ),

                   ],
                 ),

                 decoration: BoxDecoration(
                     border: Border.all(
                         color: Theme.of(context).primaryColor,
                         style: BorderStyle.solid,
                         width: 1
                     ),
                     color: Theme.of(context).primaryColor,
                     borderRadius: BorderRadius.only(
                         topLeft: Radius.circular(8.0),
                         topRight: Radius.circular(8.0)
                     )
                 ),
               ),

               Expanded(
                 child: ListView.builder(
                   itemCount: arrDataList.length,
                   itemBuilder: (context, index) {
                     var arrData = arrDataList[index];
                     var strMonth = arrData['Month'];
                     var strAmount = arrData['Amount'];
                     var strStatus = arrData['Status'];
                     var strDeductionMode = arrData['Deductionmode'];

                     return Container(
                       decoration: BoxDecoration(
                           border: Border.all(
                               color: Colors.black,
                               style: BorderStyle.solid,
                               width: 0.5
                           )
                       ),
                       height: 50,
                       child: Row(
                         //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Expanded(
                             child: Center(
                               child: Text("$strMonth",
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                     fontSize: 12
                                 ),
                               ),
                             ),
                           ),

                           VerticalDivider(
                             thickness: 1,
                             width: 5,
                             color: Colors.black,
                           ),

                           Expanded(
                             child: Center(
                               child: Text("$strAmount",
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                     fontSize: 12
                                 ),),
                             ),
                           ),

                           VerticalDivider(
                             thickness: 1,
                             width: 5,
                             color: Colors.black,
                           ),

                           Expanded(
                             child: Center(
                               child: Text("$strStatus",
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                     fontSize: 12
                                 ),),
                             ),
                           ),

                           VerticalDivider(
                             thickness: 1,
                             width: 5,
                             color: Colors.black,
                           ),

                           Expanded(
                             child: Center(
                               child: Text("$strDeductionMode",
                                 style: TextStyle(
                                     fontWeight: FontWeight.bold,
                                     color: Colors.black,
                                     fontSize: 12
                                 ),),
                             ),
                           ),

                         ],
                       ),
                     );

                   },

                 ),
               )
             ],
           ),
         ),
       ),
     ),

   );
  }

}