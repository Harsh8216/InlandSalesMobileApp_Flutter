import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_LoanTrxDetails.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:inland_sales_upgrade/ZigzagClipper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Custom_Color_file.dart';

class Activity_AppliedLoanList extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const Activity_AppliedLoanList({super.key, required this.onThemeChange});
  
  @override
  State<StatefulWidget> createState() => State_AppliedLoanList();

}

class State_AppliedLoanList extends State<Activity_AppliedLoanList>{
  var arrLoanDetails = [];
  var arrLoanTRX = [];
  var strLoanId;

  @override
  void initState() {
    super.initState();
    LoanListBody();
    LoanTrxBody();

  }

  void LoanListBody() async{
    var pref = await SharedPreferences.getInstance();
    String? strEmployeeId = pref.getString(Constant.Empcd);

    final Map<String,String> requestBody = {
      'Empcd' : "$strEmployeeId",
      'Tokenno' : "2.5"
    };

    try{
      List<dynamic> responseData  = await ApiHelper.postRequest(EndPoint.GetLoanDetails, requestBody);
      print(responseData.length);

      setState(() {
        arrLoanDetails = responseData;

      });

    }catch(e){
      print("$e");

    }
  }

  void LoanTrxBody() async{
    var pref = await SharedPreferences.getInstance();
    String? strEmployeeId = pref.getString(Constant.Empcd);

   final Map<String,String> requestBody ={
     "Empcd" : "$strEmployeeId",
     "Tokenno" : "2.5"
   };

   try{
     List<dynamic> ResponseData = await ApiHelper.postRequest(EndPoint.GetLoanTransaction, requestBody);

     setState(() {
       arrLoanTRX = ResponseData;
     });

   }catch(e){
     print(e);
     Utility().ShowToast("$e");

   }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),
        appBar: AppBar(
          title: const Text('Loan Details',
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),
          ),
          bottom: TabBar(
              indicatorColor: Theme.of(context).canvasColor,
              isScrollable: false,
              indicator: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
                borderRadius: BorderRadius.circular(20)
              ),
              indicatorPadding: EdgeInsets.all(5),
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              labelColor: Theme.of(context).canvasColor,
              unselectedLabelColor: Theme.of(context).primaryColorDark,
              tabs: const [
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text('Applied Loan List'),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text('Loan Report Card'),
              ),
            )
          ]),

          backgroundColor: Theme.of(context).primaryColor,
          iconTheme: IconThemeData(
            color: Theme.of(context).canvasColor
          ),
          
        ),

        body: TabBarView(children: [
          LoanAppliedList(),
          LoanReportCard()


        ]),

        floatingActionButton: FloatingActionButton(onPressed: (){

        },
          backgroundColor: Theme.of(context).focusColor,
          tooltip: 'Apply for Loan',
          child: Icon(
            Icons.add,
            size: 25,
            color: Theme.of(context).canvasColor,
          ),

        ),
      ),
    );
  }

  Widget LoanAppliedList(){
    if(arrLoanDetails.isEmpty){
      return Center(
      child: CircularProgressIndicator(
        color: Color(CustomColor.Corp_Red.value),
        backgroundColor: CustomColor.Corp_Skyblue,
        strokeWidth: 4.0,
      ),
      );

    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.builder(
        itemCount: arrLoanDetails.length,
          itemBuilder: (context,index){
            var arrLoanDataList = arrLoanDetails[index];
            var strEmpnm = arrLoanDataList['Empnm'];
            var strApplyAmount = arrLoanDataList['ApplyAmount'];
            var strApprovedAmount = arrLoanDataList['ApprovedAmount'];
            var strApplyDate= arrLoanDataList['ApplyDate'];
            var strCompleteInMonth = arrLoanDataList['CompleteInMonth'];
            var strReason = arrLoanDataList['Reason'];

            return Card(
              color: Colors.white,
              elevation: 4,
              child: Column(
                children: [
                  ClipPath(
                    clipper: ZigzagClipper(),
                    child: Container(
                      child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle_sharp,
                                size: 18,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text("$strEmpnm",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ],
                          )),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8.0),
                          topRight: Radius.circular(8.0)
                        )
                      ),
                      height: 50,
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: const Text("Apply Date",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 10
                                  )
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.calendar_month_sharp,
                                  size: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text("$strApplyDate",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          fontSize: 15

                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: const Text("Total Tenure",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10

                                ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 23),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_calendar_sharp,
                                    size: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text("$strCompleteInMonth"+" Month",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15

                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: const Text("Apply Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 10
                                  )),
                            ),

                            Row(
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  size: 15,
                                  color: Colors.black,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text("$strApplyAmount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                          fontSize: 15

                                      )
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 17),
                              child: const Text("Approved Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 10
                                  )),
                            ),

                            Row(
                              children: [
                                Icon(
                                  Icons.currency_rupee,
                                  size: 15,
                                  color: Colors.black,),
                                Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: Text("$strApprovedAmount",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                          fontSize: 15

                                      )),
                                ),
                              ],
                            ),
                          ],
                        )

                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Reason:",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),

                              ),
                              Text("$strReason",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 12
                                  ),
                              ),
                            ],
                          ),
                        )
                    ),
                  )
                ],
              ),
            );

      }),
    );
  }

  Widget LoanReportCard(){
    if(arrLoanTRX.isEmpty){
      return Center(
        child: CircularProgressIndicator(
          color: Color(CustomColor.Corp_Red.value),
          backgroundColor: CustomColor.Corp_Skyblue,
          strokeWidth: 4.0,
        ),
      );

    }
    return ListView.builder(
      itemCount: arrLoanTRX.length,
        itemBuilder: (context, index){
        var arrData = arrLoanTRX[index];
        var strApplyAmount = arrData['ApplyAmount'];
        var strApprovedAmount = arrData['ApprovedAmount'];
        var strBranch = arrData['Branch'];
        var strEmpnm = arrData['Empnm'];
        var strPendingamount = arrData['Pendingamount'];
        strLoanId = arrData['LoanID'];

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            elevation: 6,
            color: Colors.white,
            child: Column(
              children: [
                ClipPath(
                  clipper: ZigzagClipper(),
                  child: Container(
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.account_circle_sharp,
                              size: 18,
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text("$strEmpnm",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                            ),
                          ],
                        )),
                    height: 50,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: const Text("Applied Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10
                                )
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text("$strApplyAmount",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 15

                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 17),
                            child: const Text("Approved Amount",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10
                                )
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 15,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 2),
                                child: Text("$strApprovedAmount",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: 15

                                    )
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 22),
                           child: const Text("Branch",
                               style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.grey,
                                   fontSize: 10
                               )
                           ),
                         ),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.account_balance,
                               size: 15,
                             ),
                             Padding(
                               padding: const EdgeInsets.only(left: 5),
                               child: Text("$strBranch",
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: Colors.black,
                                       fontSize: 15

                                   )
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),

                     Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Padding(
                           padding: const EdgeInsets.only(left: 19),
                           child: const Text("Pending Amount",
                               style: TextStyle(
                                   fontWeight: FontWeight.bold,
                                   color: Colors.grey,
                                   fontSize: 10
                               )
                           ),
                         ),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Icon(
                               Icons.currency_exchange_rounded,
                               size: 15,
                             ),
                             Padding(
                               padding: const EdgeInsets.only(left: 5),
                               child: Text("$strPendingamount",
                                   style: TextStyle(
                                       fontWeight: FontWeight.bold,
                                       color: Colors.amber,
                                       fontSize: 15

                                   )
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ]
                  ),
                ),

                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (Context) => Activity_LoanTrxDetails()));

                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: Theme.of(context).focusColor,
                            size: 25,
                          ),
                          Text("Click to view loan transaction in details",
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                              decorationColor: Theme.of(context).focusColor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

              ],
            ),

          ),
        );
    });
  }
}