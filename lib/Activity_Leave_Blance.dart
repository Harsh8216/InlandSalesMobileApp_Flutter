import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Network.dart';
import 'Utility.dart';

class Activity_Leave_Blance extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const Activity_Leave_Blance({super.key, required this.onThemeChange});
  @override
  State<StatefulWidget> createState() {
    return LeaveBalanceState();
  }

}

class LeaveBalanceState extends State<Activity_Leave_Blance>{
  var arrLeaveBal = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LeaveBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LeaveBalanceData(),

    );
  }


  void LeaveBalance() async{
    var pref = await SharedPreferences.getInstance();
    String? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String, String> requestBody = {
      'Empcd' : "$strEmpcd",
      'Tokenno' : Constant.TokenNo,

    };

    try{
      List<dynamic> responseData = await ApiHelper.postRequest(EndPoint.GetEmployee_LeaveBook, requestBody);
      print(responseData.length);

      setState(() {
        arrLeaveBal = responseData;
        isLoading = false;

      });

    }catch(e){
      print("Error fetching leave history: $e");
      setState(() {
        arrLeaveBal = [];
        isLoading = false;

      });

    }

  }

  Widget LeaveBalanceData(){
    if(isLoading){
      return Center(
          child: Utility().showProcessDialog());
    }else if(arrLeaveBal.isEmpty){
      return Center(
        child: Utility().NoDataFound()
      );

    }else
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        color: Theme.of(context).canvasColor,

        child: Column(
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).primaryColor,
                      style: BorderStyle.solid,
                      width: 1
                  ),
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('Month | Year',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15
                      )
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: VerticalDivider(
                      width: 5,
                      color: Colors.white,
                      thickness: 1,

                    ),
                  ),
                  Text('Leave Balance',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 15
                      )
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1
                  )
              ),
              child: ListView.separated(
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  itemCount: arrLeaveBal.length,
                  itemBuilder: (context,index){
                    var arrBalData = arrLeaveBal[index];

                    return Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('${arrBalData["Month"]} | ${arrBalData["Year"]}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14
                                  )
                              ),
                            ),
                          ),

                          VerticalDivider(
                            thickness: 1,
                            width: 5,
                            color: Colors.black,
                          ),

                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('${arrBalData["LeaveBalance"]}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 14
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, separatorBuilder: (BuildContext context, int index) =>

              const Divider(
                height: 1,
                thickness: 1,
                color: Colors.black,
              )

              ),
            ),
          ],
        ),
      ),
    );

  }

}