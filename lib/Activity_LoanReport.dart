import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Activity_LoanTrxDetails.dart';
import 'Network.dart';
import 'Utility.dart';
import 'ZigzagClipper.dart';

class Activity_LoanReport extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const Activity_LoanReport({
    super.key,
    required this.onThemeChange
  });

  @override
  State<StatefulWidget> createState() {
    return LoanReportState();
  }

}

class LoanReportState extends State<Activity_LoanReport>{
  var arrLoanTRX = [];
  var strLoanId;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoanReportCard(),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoanTrxBody();
  }

  Widget LoanReportCard(){
    if(isLoading){
      return Center(
        child: Utility().showProcessDialog()
      );

    }else if(arrLoanTRX.isEmpty){
      return Center(
        child: Utility().NoDataFound()
      );

    }else{
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
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (Context) => Activity_LoanTrxDetails(
                                onThemeChange: widget.onThemeChange,
                                strLoadId: strLoanId,

                              )));

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
        },
      );

    }

  }

  void LoanTrxBody() async{
    var pref = await SharedPreferences.getInstance();
    String? strEmployeeId = pref.getString(Constant.Empcd);

    try{
      final Map<String,String> requestBody ={
        "Empcd" : "$strEmployeeId",
        "Tokenno" : "2.5"
      };

      List<dynamic> ResponseData = await ApiHelper.postRequest(EndPoint.GetLoanTransaction, requestBody);

      setState(() {
        arrLoanTRX = ResponseData;
        isLoading = false;
      });

    }catch(e){
      print(e);
      setState(() {
        arrLoanTRX = [];
        isLoading = false;

      });

    }
  }

}






