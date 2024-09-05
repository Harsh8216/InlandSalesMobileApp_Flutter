import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Custom_Color_file.dart';

class Activity_Leave_List extends StatefulWidget{
  @override
  State<Activity_Leave_List> createState() => _Activity_Leave_ListState();
}

class _Activity_Leave_ListState extends State<Activity_Leave_List> {
  var arrData = [];

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
      "Tokenno": "${Constant.TokenNo}"
    };

    try{
      final http.Response responseBody = await http.post(
        Uri.parse("${Constant.baseurl+"/GetEmployee_LeaveHistory"}"),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      List<dynamic> responseData = jsonDecode(responseBody.body);
      print(responseData.length);

      setState(() {
        arrData = responseData;

      });

    }catch(error){
      print(error);

    }

  }
  Color getColorStatus(String status){
    switch(status.toLowerCase()){
      case  'approved':
        return Colors.green;
      case  'pending':
        return Color(0xFFCEC123);
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
    return Scaffold(
      appBar: AppBar(title: Text("Leave List",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          backgroundColor: Color(CustomColor.Corp_Red.value),iconTheme: IconThemeData(color: Colors.white)),
      body: arrData.isEmpty ? Center(child: CircularProgressIndicator(color: Color(CustomColor.Corp_Red.value),backgroundColor: Colors.cyan,strokeWidth: 4.0,)) :
      ListView.builder(itemBuilder: (context, index) {
        var dataList = arrData[index];
        IconData statusIcon = getIconForStatus(dataList['Status']);
        Icon StatusWidget = Icon(statusIcon,color: getColorStatus(dataList['Status']));
        Color colorStatus = getColorStatus(dataList['Status']);

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: double.infinity,
            height: 350,
            child: Card(
              color: Colors.white,
              elevation: 8,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0),topRight: Radius.circular(8.0)),
                        color: Color(CustomColor.Corp_Red.value)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                buildMenuShapeChange("From Date",Icons.calendar_month,dataList['FromDate']),

                                Padding(
                                  padding: const EdgeInsets.only(left: 100),
                                  child: buildMenuShapeChange("To Date",Icons.calendar_month,dataList['TODate']),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20,left: 10),
                            child: Row(
                              children: [
                                Text("No. of Days : "+dataList['Days'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                                Padding(
                                    padding: const EdgeInsets.only(left: 80),
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone,color: Colors.white,size: 20,),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: Text(dataList['EMobNo'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.white)),
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
                  Row(
                    children: [
                      buildMenu("Leave Apply Date",Icons.calendar_month,dataList['EntryDate']),
                      Padding(
                          padding: const EdgeInsets.only(left: 90,top: 10),
                          child: Row(
                            children: [
                              Icon(StatusWidget.icon),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(dataList['Status'],style: TextStyle(color: colorStatus,fontWeight: FontWeight.bold,fontSize: 16)),
                              ),
                            ],
                          )
                      ),

                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: buildMenu("Responsible Person",Icons.account_circle,dataList['ResPersonEmpnm']),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 5,right: 5),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: buildMenuShapeChangeColor("Reason",Icons.receipt,dataList['Reason']),
                      ),

                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
        itemCount: arrData.length,

      ),
    );
  }

  Widget buildMenu(String strText,IconData iconData,String _strText){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10,left: 40),
          child: Text(strText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10,color: Colors.black87)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(iconData,color: Colors.black87,size: 25,),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(_strText,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.black)),
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
          padding: const EdgeInsets.only(left: 10),
          child: Text(strText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(iconData,color: Colors.white,size: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(_strText,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.white)),
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
          padding: const EdgeInsets.only(left: 10),
          child: Text(strText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              Icon(iconData,color: Colors.black,size: 15,),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text(_strText,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black)),
              ),
            ],
          ),
        )
      ],
    );
  }

}

