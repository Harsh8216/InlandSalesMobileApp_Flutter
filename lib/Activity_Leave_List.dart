import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Activity_Dashboard.dart';
import 'package:inland_sales_upgrade/Activity_Leave_Blance.dart';
import 'package:inland_sales_upgrade/Apply_for_leaves.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/MiddleRoundCutCliper.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:inland_sales_upgrade/ZigzagClipper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Activity_Leave_List extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const Activity_Leave_List({super.key, required this.onThemeChange});

  @override
  State<Activity_Leave_List> createState() => _Activity_Leave_ListState();
}

class _Activity_Leave_ListState extends State<Activity_Leave_List> {
  var arrData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    leaveRequestBody();
  }

  void leaveRequestBody() async{
    var pref = await SharedPreferences.getInstance();
    String? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String,String> requestBody ={
      "Empcd": "$strEmpcd",
      "Tokenno": Constant.TokenNo
    };

    try{
      final http.Response responseBody = await http.post(
        Uri.parse(Constant.baseurl+EndPoint.GetEmployee_LeaveHistory),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      List<dynamic> responseData = jsonDecode(responseBody.body);
      print(responseData.length);

      setState(() {
        arrData = responseData;
        isLoading = false;

      });

    }catch(error){
      print(error);
      setState(() {
        arrData = [];
        isLoading = false;

      });

    }

  }

  void LeaveDelete(String LeaveId) async{
    var pref = await SharedPreferences.getInstance();
    String? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String, String> requestBody = {
      'Empcd' : "$strEmpcd",
      'Tokenno' : Constant.TokenNo,
      'LeaveID' : LeaveId

    };

    try{
      showDialog(context: context, builder: (BuildContext buildContext){
        return const Center(
          child: CircularProgressIndicator(
            color: CustomColor.Corp_Red,
            backgroundColor: CustomColor.Corp_Skyblue,
            strokeWidth: 4.0,
          ),
        );

      });

      final http.Response JsonDataConvert = await http.post(
        Uri.parse(Constant.baseurl+EndPoint.LeaveDelete),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},

      );

      if(JsonDataConvert.statusCode == 200){
        Map<String, dynamic> responseData = jsonDecode(JsonDataConvert.body);
        print(responseData.length);

        setState(() {
          var strMsg = responseData["Msg"] ?? 'No Message Received';
          var strStatus = responseData["Status"] ?? 'Unknown Status';

          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }

          if(strStatus.toString() == 'OK'){
            showDialog(
                context: context,
                builder: (BuildContext buildContext){
                  return AlertDialog(
                    title: const Text('Success',style: TextStyle(color: Colors.green,fontSize: 20,fontWeight: FontWeight.w900),),
                    content: Text(strMsg,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    actions: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Dashboard(onThemeChange: widget.onThemeChange,)));

                      },
                          child: const Text('OK'))
                    ],

                  );
                }
            );
          }else{
            Utility().ShowToast(strMsg);
          }

        });

      }else{
        Utility().ShowToast("No Response From Server");
      }

    }catch(error){
      Utility().ShowToast("$error");
    }

  }

  Color getColorStatus(String status){
    switch(status.toLowerCase()){
      case  'approved':
        return Colors.green;
      case  'pending':
        return const Color(0xFFCEC123);
      case  'reject':
        return Colors.red;
      default :
        return Colors.black;
    }

  }

  IconData getIconForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Icons.thumb_up;
      case 'pending':
        return Icons.access_time;
      case 'reject':
        return Icons.thumb_down;
      default:
        return Icons.error;
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
            title: const Text("Leave Details",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            bottom: TabBar(
                isScrollable: false,
                indicatorColor: Theme.of(context).focusColor,
                indicator: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(20), // Add roundness to the indicator
                ),
                indicatorPadding: const EdgeInsets.all(5),
                labelPadding: const EdgeInsets.symmetric(horizontal:20),
                labelColor: Theme.of(context).canvasColor,
                unselectedLabelColor: Theme.of(context).primaryColorDark,
                tabs: const [
                  Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Leave History",),
            )
                  ),
                  Tab(
                      child: Align(
                        alignment: Alignment.center,
                          child: Text("Leave Balance")),
                      )

                ]),

            backgroundColor: Theme.of(context).primaryColor,

            iconTheme: IconThemeData(
                color: Theme.of(context).canvasColor
            )),

        body: TabBarView(
          children: [
            LeaveHistory(),
            Activity_Leave_Blance(onThemeChange: widget.onThemeChange)


          ],
        ),

        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Apply_for_leaves(onThemeChange: widget.onThemeChange)));

        },
          backgroundColor: Theme.of(context).focusColor,
          tooltip: "Apply Leave",
          child: Icon(
            Icons.add,
            size: 25,
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }

  Widget buildMenu(String strText,IconData iconData,String _strText){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 10,
              left: 40
          ),

          child: Text(strText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: Theme.of(context).primaryColorDark
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 10
          ),
          child: Row(
            children: [
              Icon(iconData,
                color: Theme.of(context).primaryColorDark,
                size: 25
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 5
                ),

                child: Text(_strText,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark
                    )),

              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildMenuShapeChange(String strText,IconData iconData,String _strText){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10
          ),

          child: Text(strText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).canvasColor
              )),

        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(iconData,
                color: Theme.of(context).canvasColor,
                size: 15,
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 5
                ),

                child: Text(_strText,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor
                    )),

              ),
            ],
          ),
        )
      ],
    );
  }

  Widget buildMenuShapeChangeColor(String strText,IconData iconData,String _strText){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 10
          ),

          child: Text(strText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColorDark
              )),

        ),
        Padding(
          padding: const EdgeInsets.only(
              left: 10
          ),

          child: Row(
            children: [
              Icon(iconData,
                color: Theme.of(context).primaryColorDark,
                size: 15
              ),

              Padding(
                padding: const EdgeInsets.only(
                    left: 5
                ),

                child: Text(_strText,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark
                    )),

              ),
            ],
          ),
        )
      ],
    );
  }

  Widget LeaveHistory(){
    if(isLoading){
      return Center(
        child: Utility().showProcessDialog(),
            );
    }else if(arrData.isEmpty){
      return Center(
        child: Utility().NoDataFound()
      );

    }else
     return ListView.builder(
      itemBuilder: (context, index) {
        var dataList = arrData[index];
        String LeaveID = dataList['LeaveID'];
        IconData statusIcon = getIconForStatus(dataList['Status']);
        Icon StatusWidget = Icon(statusIcon,color: getColorStatus(dataList['Status']));
        Color colorStatus = getColorStatus(dataList['Status']);

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 340,
            child: ClipPath(
              clipper: MiddleRoundCutCliper(),
              child: Card(
                color: Theme.of(context).canvasColor,
                elevation: 4,
                child: Column(
                  children: [
                    ClipPath(
                      clipper: ZigzagClipper(),
                      child: Container(
                        width: double.infinity,
                        height: 120,

                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0)
                            ),

                            color: Theme.of(context).primaryColor
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    buildMenuShapeChange("From Date",
                                        Icons.calendar_month,
                                        dataList['FromDate']),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 100),
                                      child: buildMenuShapeChange("To Date",
                                          Icons.calendar_month,
                                          dataList['TODate']),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20,left: 10),
                                child: Row(
                                  children: [
                                    Text("No. of Days : "+dataList['Days'],
                                        style: TextStyle(fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).canvasColor
                                        )),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 80),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Theme.of(context).canvasColor,
                                              size: 20,),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 5),
                                              child: Text(
                                                  dataList['EMobNo'],
                                                  style: TextStyle(fontWeight: FontWeight.bold,
                                                      fontSize: 14,
                                                      color: Theme.of(context).canvasColor
                                                  )),
                                            ),
                                          ],
                                        )
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),


                        ),

                      ),
                    ),
                    Row(
                      children: [
                        buildMenu("Leave Apply Date",
                            Icons.calendar_month,
                            dataList['EntryDate']),

                        Padding(
                            padding: const EdgeInsets.only(
                                left: 90,
                                top: 10
                            ),

                            child: Row(
                              children: [
                                Icon(StatusWidget.icon),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5
                                  ),

                                  child: Text(dataList['Status'],
                                      style: TextStyle(
                                          color: colorStatus,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                      )),
                                ),
                              ],
                            )
                        ),

                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10
                      ),
                      child: buildMenu("Responsible Person",
                          Icons.account_circle,
                          dataList['ResPersonEmpnm']),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                right: 10
                            ),

                            child: dataList ['Status'] == 'Pending' ?

                            InkWell(onTap : (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext buildContext){
                                    return AlertDialog(
                                      title: const Text('Alert',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w900
                                          )),
                                      content: const Text('Do you really want to delete pending leave',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16
                                          )),

                                      actions: [
                                        TextButton(onPressed: (){
                                          LeaveDelete(LeaveID);

                                        },
                                            child: const Text('OK')),
                                        TextButton(onPressed: (){
                                          Navigator.of(context).pop();


                                        }, child: const Text('Cancel'))
                                      ],
                                    );

                                  });

                            },
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                )) : const SizedBox.shrink()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10,
                          left: 5,
                          right: 5
                      ),

                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey
                            ),

                            borderRadius: BorderRadius.circular(8.0)
                        ),

                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10
                          ),

                          child: buildMenuShapeChangeColor("Reason",
                              Icons.receipt,
                              dataList['Reason']
                          ),

                        ),

                      ),
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      },
      itemCount: arrData.length,

    );

  }

}

