import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:inland_sales_upgrade/ZigzagClipper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivityVisitEntry extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const ActivityVisitEntry({
    super.key,
    required this.onThemeChange
  });


  @override
  State<StatefulWidget> createState() {
    return Activity_visit_entry_state();
  }

}

class Activity_visit_entry_state extends State<ActivityVisitEntry>{
  var arrVisitList = [];
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    VisitEntryBody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange),
      appBar: Utility().Custom_AppBar(context, "Visit Entry"),
      body: isLoading
          ? Utility().showProcessDialog() // Show the process dialog when loading
          : arrVisitList.isEmpty
          ? Center(
        child: Utility().NoDataFound(),
      ) :
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            itemCount: arrVisitList.length,
            itemBuilder: (context,index){
              var arrVisitDataList = arrVisitList[index];
              var strCustomerName = arrVisitDataList['CustomerName'];
              var strEndTime = arrVisitDataList['EndTime'];
              var strStartTime = arrVisitDataList['StartTime'];
              var strLastVisitDate = arrVisitDataList['LastVisitDate'];
              var strNextVisitDate = arrVisitDataList['NextVisitDate'];
              var strTotalVisit = arrVisitDataList['TotalVisit'];
              var strVisitId = arrVisitDataList['VisitId'];
              var strVisitRemarks = arrVisitDataList['VisitRemarks'];

              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                  color: Colors.white,
                  elevation: 4,
                  child: Column(
                    children: [
                      ClipPath(
                        clipper: ZigzagClipper(),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0)
                              )
                          ),
                          child: Center(
                            child: Text('$strCustomerName',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utility().BuildMenuItems(context,"Last Visit Date",Icons.calendar_month_sharp,"$strLastVisitDate"),
                          Utility().BuildMenuItems(context,"Next Visit Date",Icons.calendar_month_sharp,"$strNextVisitDate")
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utility().BuildMenuItems(context,"Start Time",Icons.access_time_filled,"$strStartTime"),
                          Utility().BuildMenuItems(context,"End Time",Icons.access_time_filled,"$strEndTime"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Utility().BuildMenuItems(context,"Visit Id",Icons.account_box_rounded,"$strVisitId"),
                          Utility().BuildMenuItems(context,"Total Visit",Icons.villa_sharp,"$strTotalVisit")
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20,top: 10,left: 10,right: 10),
                        child:   Utility().RemarkMessageBox("Visit Remark", "$strVisitRemarks")
                      )

                    ],

                  ),

                ),
              );

            },
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

      },
        backgroundColor: Theme.of(context).focusColor,
        tooltip: "Visit Entry",
        child: Icon(Icons.add,
          size: 25,
          color: Theme.of(context).canvasColor,
        )
      ),

    );
  }

  void VisitEntryBody() async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmployeeId = pref.getString(Constant.Empcd);
    String ? strBranch = pref.getString(Constant.CurrBrcd);
    try{
      final Map<String,String> requestBody = {
        "Empcd" : "$strEmployeeId",
        "Branch" : "$strBranch"
    };

      List <dynamic> responseData = await ApiHelper.postRequest(EndPoint.GetVisitList, requestBody);
      print(responseData.length);

      setState(() {
        arrVisitList = responseData;
        isLoading = false;

      });

    }catch(e){
      setState(() {
        isLoading = false;
        arrVisitList = [];
      });

    }

  }

}

