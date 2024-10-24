import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inland_sales_upgrade/Dashboard_HR.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity_Dashboard extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  const Activity_Dashboard({super.key, required this.onThemeChange});

  @override
  State<Activity_Dashboard> createState() => _Activity_DashboardState();
}

class _Activity_DashboardState extends State<Activity_Dashboard> {
  String _Name = '';

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData();
  }

  Future<void> getSharedPreferenceData() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String name = pref.getString(Constant.Name) ?? "";

      setState(() {
        _Name = name;

      });

    }catch(error){
      print(error);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
            children: [
              Container(
                width: double.maxFinite,
                height: 300,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: const Offset(0,5),
                          color: Colors.black.withOpacity(0.5)
                      )
                    ],
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 62,top: 45),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text("Welcome",
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.notifications_active_rounded,
                              color: Theme.of(context).canvasColor,
                              size: 30,

                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.account_circle,
                            color: Theme.of(context).canvasColor,
                            size: 35,),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(_Name,
                                style: TextStyle(
                                    color: Theme.of(context).canvasColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                          child:  Text("Dashboard",
                              style: TextStyle(
                                  color: Theme.of(context).canvasColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  fontFamily: 'Sora')
                          )
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:  const EdgeInsets.only(top: 170),
                child: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                  child: GridView.count(crossAxisCount: 2,
                    padding: const EdgeInsets.all(20),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      buildCard(Icons.cases_rounded, "My Activity",(){
                        ShowToast("My Activity");
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppInland()));
                      }),

                      buildCard(Icons.account_circle, "My HR",() async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Apply_Leaves(onThemeChange: widget.onThemeChange,)));

                      }),

                      buildCard(Icons.access_time_filled, "Attendance",(){
                        ShowToast("Attendance");

                      }),
                      buildCard(Icons.note_alt, "Request",(){
                        ShowToast("Report");

                      }),
                      buildCard(Icons.currency_rupee, "Finance",(){
                        ShowToast("Finance");

                      }),
                      buildCard(Icons.class_outlined, "My Customer",() {
                        ShowToast("My Customer");

                      }),
                    ],
                  ),
                ),
              )
            ]
        ),
      ),
    );
  }

  Widget buildCard(IconData iconData,String text,VoidCallback onPressed){
    return GestureDetector(
        onTap: onPressed,
        child : Card(
          elevation: 8,
          color: Theme.of(context).cardColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData,
                  color: Theme.of(context).indicatorColor,
                  size: 50,),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(text,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hoverColor)),
                )

              ]),
        )

    );

  }

  void ShowToast(String Msg){
    Fluttertoast.showToast(msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
        backgroundColor: Colors.black54,
        textColor: Colors.white);
  }
}
