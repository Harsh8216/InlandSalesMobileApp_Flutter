import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inland_sales_upgrade/DashBoard_My_Activity.dart';
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
  var UserImage = '';

  @override
  void initState() {
    super.initState();
    getSharedPreferenceData();
  }

  Future<void> getSharedPreferenceData() async{
    try{
      var pref = await SharedPreferences.getInstance();
      String name = pref.getString(Constant.Name) ?? "";
      String imageURL = pref.getString(Constant.UserImage) ?? "";

      setState(() {
        _Name = name;
        UserImage = imageURL;

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
                      padding: const EdgeInsets.only(left: 70,top: 45),
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
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(UserImage),
                            onBackgroundImageError: (_,__){
                              debugPrint("Failed to load profile image.");

                            },
                            backgroundColor: Colors.grey.shade200,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DashBoard_My_Activity(onThemeChange: widget.onThemeChange)));
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
