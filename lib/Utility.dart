import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Network.dart';

class Utility{
  void ShowToast(String Msg){
    Fluttertoast.showToast(msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
        backgroundColor: Colors.black54,
        textColor: Colors.white);
  }

  Center showProcessDialog(){
    return Center(
      child: CircularProgressIndicator(
        color: Color(CustomColor.Corp_Red.value),
        backgroundColor: CustomColor.Corp_Skyblue,
        strokeWidth: 4.0,
      ),
    );
  }

  AppBar Custom_AppBar(BuildContext context,String strTitle){
    return AppBar(
      title: Text(strTitle,
        style: TextStyle(
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: const IconThemeData(
        color: Colors.white
      ),


    );
  }

  Widget BuildMenuItems(BuildContext context,String strText,IconData iconData,String Json_Text){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25),
            child: Text(strText,
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
                  iconData,
                  color: Theme.of(context).primaryColorDark,
                  size: 20
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Text("$Json_Text",
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
    );
  }

  Widget RemarkMessageBox(String strRemark,String JsonRemark){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
                  Text(strRemark,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey
                    ),

                  ),
                  Text("$JsonRemark",
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
      ],
    );

  }

  void CustomAlertDialog(BuildContext context,String label,String strMsg,Function onOkPress){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                )
            ),
            content: Text(strMsg,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                )),

            actions: [
              TextButton(onPressed: (){
                onOkPress();
              }, child: const Text('OK'))
            ],


          );

        });

  }
  
  Widget NoDataFound(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 100,
            width: 100,
            child: Image.asset("assets/images/no_data_found.png")),
        Text(
          "No Record Found",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.red,
              fontFamily: "ProtestRiot"
          ),
        )

      ],
    );
  }

  Widget BuildCircleMenuItems(String name,IconData iconData,Color circleColor,VoidCallback onPressed){
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              color: circleColor,
              shape: BoxShape.circle
            ),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: 10.0,),
          Text(name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
          )
        ],

      ),
    );
  }

}

class ApiHelper {
  static Future<dynamic> postRequest(String endpoint, Map<String, String> requestBody) async {

    try {
      final http.Response response = await http.post(
        Uri.parse("${Constant.baseurl}$endpoint"),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Return parsed response
      } else {
        throw Exception('Failed to load data. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print("Error occurred: $error");
      rethrow; // Rethrow the error to handle it at the caller side
    }
  }
}
