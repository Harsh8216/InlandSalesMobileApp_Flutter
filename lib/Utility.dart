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
