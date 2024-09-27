import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Activity_Bottom_Navigation_Bar.dart';
import 'package:inland_sales_upgrade/Activity_Dashboard.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget{
  final Function(ThemeData) onThemeChange;
  LoginPage({required this.onThemeChange});

  @override
  _LoginPage createState() =>  _LoginPage();

}

class _LoginPage extends State<LoginPage>{
  var UserIdController = TextEditingController();
  var PassWordController = TextEditingController();
  var _Branch_Address,_Name,_Empcd,_Branch_Lat,_Branch_Long,_Branch_Radious,_CurrBrcd,_IsFinance,_IsSalesMan,_LAST_PWDUPDT,_PwdDays,strEmpcd,strPassword;

  void _login() async {
    final Map<String,String> requestBody = {
      "Empcd": UserIdController.text,
      "Password": PassWordController.text,
      "Version": "OK",
      "Imeino": ""
    };

    print(requestBody.length);

    try{
      showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
        return Center(
            child: CircularProgressIndicator(
              color: CustomColor.Corp_Red,
              backgroundColor: CustomColor.Corp_Skyblue,
              strokeWidth: 4.0,)
        );
      },
      );
      final http.Response response = await http.post(
          Uri.parse("${Constant.baseurl+EndPoint.EmployeeLogin}"),
          body: jsonEncode(requestBody),
          headers: {"Content-Type": "application/json"}
      );
      print(response.body);

      final Map<String,dynamic> responseData = jsonDecode(response.body);
      print(responseData.length);

      final _statusCode = int.parse(responseData['Status']);
      _Branch_Address = responseData['Branch_Address'];
      _Name = responseData['Name'];
      _Empcd = responseData['Empcd'];
      _Branch_Lat = responseData['Branch_Lat'];
      _Branch_Long = responseData['Branch_Long'];
      _Branch_Radious = responseData['Branch_Radious'];
      _CurrBrcd = responseData['CurrBrcd'];
      _IsFinance = responseData['IsFinance'];
      _IsSalesMan = responseData['IsSalesMan'];
      _LAST_PWDUPDT = responseData['LAST_PWDUPDT'];
      _PwdDays = responseData['PwdDays'];

      strEmpcd = requestBody['Empcd'];
      strPassword = requestBody['Password'];

      if(_statusCode == 5001){
        Navigator.pop(context);
        Fluttertoast.showToast(msg: 'Please Check your UserID and Password',toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,textColor: Colors.white);
      }else
      if(response.statusCode == 200){
        await saveUserData(responseData);
        await saveID_PW(requestBody);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBar(onThemeChange: widget.onThemeChange,)));

      }else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: responseData['Message']??'Login Failed',toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,textColor: Colors.white);
      }

    } catch(error){
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'An error occurred. Please try again later.',toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,textColor: Colors.white);
    }
  }

  Future<void> saveUserData(Map<String,dynamic> userData) async{
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString(Constant.Branch_Address, _Branch_Address);
      await pref.setString(Constant.Name, _Name);
      await pref.setString(Constant.Empcd, _Empcd);
      await pref.setString(Constant.Branch_Lat, _Branch_Lat);
      await pref.setString(Constant.Branch_Long, _Branch_Long);
      await pref.setString(Constant.CurrBrcd, _CurrBrcd);
      await pref.setString(Constant.IsFinance, _IsFinance);
      await pref.setString(Constant.Branch_Radious, _Branch_Radious);
      await pref.setString(Constant.IsSalesMan, _IsSalesMan);
      await pref.setString(Constant.LAST_PWDUPDT, _LAST_PWDUPDT);
      await pref.setString(Constant.PwdDays, _PwdDays);

    }catch(error){

    }
  }

  Future<void> saveID_PW(Map<String,String> _userData) async{
    try{
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('user_id', strEmpcd);
      await pref.setString('Password', strPassword);

    }catch(error){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  height: 350,
                  decoration: BoxDecoration(
                      color: Color(CustomColor.Corp_Skyblue_Fade.value),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          offset: Offset(0,5),
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(100),
                          bottomRight: Radius.circular(100))
                  ),
                  child: Image.asset("assets/images/splash_logo.png"),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 280,left: 40,right: 40),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 85,
                              offset: Offset(0, 8),
                              color: Colors.black.withOpacity(0.5)
                          )
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(20))

                    ),
                    child: Container(
                      height: 300,
                      width: 500,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Login", style: TextStyle
                                (color: Color(CustomColor.Corp_Red.value),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontStyle: FontStyle.normal,
                                  letterSpacing: 0.5,
                                  fontFamily: "Roboto")),
                              Padding(
                                padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                                child: SizedBox(
                                  height: 55,
                                  child: TextFormField(
                                    controller: UserIdController,
                                    inputFormatters: [LengthLimitingTextInputFormatter(5)],
                                    keyboardType: TextInputType.number,
                                    decoration:  InputDecoration(
                                        prefixIcon: Icon(
                                            Icons.account_circle
                                        ),
                                        labelText: "User ID",
                                        labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(style: BorderStyle.solid,width: 2,color: Color(CustomColor.Corp_blue.value)),
                                            borderRadius: BorderRadius.all(Radius.circular(5)))),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),

                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10),
                                child: SizedBox(
                                  height: 55,
                                  child: TextFormField(controller: PassWordController,
                                    obscureText: true,
                                    //errorText: _validateUserId ? "Enter Valid User ID" : null,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(5))),
                                      prefixIcon: Icon(
                                        Icons.key,
                                        color: Colors.lightGreen,
                                      ),
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: 200,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: (){
                                        _login();
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(CustomColor.Corp_Red.value),
                                          textStyle: TextStyle(fontWeight: FontWeight.bold)
                                      ),
                                      child: Text("LOGIN",style: TextStyle(color: Colors.white,fontSize: 16))
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  ),
                ),

                Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _buildVersionContainer()
                )

              ],
            ),
          ),
        )
    );
  }

  void ShowToast(String Msg){
    Fluttertoast.showToast(msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
        backgroundColor: Color(0xFFC00018),
        textColor: Colors.white);
  }

  Widget _buildVersionContainer() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: Color(CustomColor.Corp_Skyblue_Fade.value),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: Colors.black.withOpacity(0.8),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(80),
          topRight: Radius.circular(80),
        ),
      ),
      child: Center(
        child: Text(
          "Version : V1.1.1.0",
          style: TextStyle(
            color: Color(CustomColor.Corp_Red.value),
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
