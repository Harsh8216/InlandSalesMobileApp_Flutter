import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inland_sales_upgrade/Dashboard_HR.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Login_Activity.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Activity_Dashboard extends StatefulWidget{
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
      String _name = pref.getString(Constant.Name) ?? "";

      setState(() {
        _Name = _name;

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
                height: 320,
                decoration: BoxDecoration(
                    color: Color(CustomColor.Corp_Red.value),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          offset: Offset(0,5),
                          color: Colors.black.withOpacity(0.5)
                      )
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100),
                        bottomRight: Radius.circular(100)
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60,top: 50),
                      child: Text("Welcome",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Icon(Icons.account_circle,color: Colors.white,size: 35,),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(_Name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Center(
                          child: const Text("Dashboard",
                              style: TextStyle(
                                  color: Colors.white,
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
                padding: const EdgeInsets.only(top: 170),
                child: Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                  child: GridView.count(crossAxisCount: 2,
                    padding: EdgeInsets.all(20),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      buildCard(Icons.account_circle, "My HR",() async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Apply_Leaves()));

                      }),
                      buildCard(Icons.cases_rounded, "My Activity",(){
                        ShowToast("My Activity");
                        //Navigator.push(context, MaterialPageRoute(builder: (context) => MyAppInland()));
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
                      buildCard(Icons.groups_sharp, "My Customer",() async{
                        await _Logout();

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
        child : Card(elevation: 8, color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, color: Colors.white,size: 55,),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white)),
                )

              ]),
        )

    );

  }

  Future <void> _Logout() async{
    var pref = await SharedPreferences.getInstance();
    await pref.remove("user_id");
    await pref.remove("Password");

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logged out successfully',
            style: const TextStyle(fontWeight: FontWeight.bold)),
            duration: Duration(seconds: 3)));
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
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
