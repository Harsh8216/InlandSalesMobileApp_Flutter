import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Edit_Text_Controler.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility{
  void ShowToast(String Msg){
    Fluttertoast.showToast(msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
        backgroundColor: Colors.black54,
        textColor: Colors.white);
  }

}

class LocationHelper{
  final TextEditingController Txt_locationController = TextEditingController();
  List<Map<String,String>> hmGetLocation = [];
  List<String> arrGetLocation = [];
  bool isFocusNode = false;

  Future<void> getLocation(BuildContext context) async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd);

    final Map<String,String> RequestBody = {
      'empcd' : '$strEmpcd',
      'Tokenno' : '${Constant.TokenNo}'

    };

    try{
      final http.Response response = await http.post(
          Uri.parse("${Constant.baseurl + EndPoint.GetLocation}"),
          body: jsonEncode(RequestBody),
          headers: {"Content-Type": "application/json"}

      );

      if(response.statusCode == 200){
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> getLocationResult  = responseData['GetLocationResult'];
          hmGetLocation = getLocationResult.map((location) => {
            'locationcode' : location['locationcode'].toString(),
            'locationname' : location['locationname'].toString()

          }).toList();
          print('GetLocation : $hmGetLocation' );

          arrGetLocation = hmGetLocation.map((location) => location['locationname']!).toList();

      }else{
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        //Utility().ShowToast("Error: ${response.statusCode} - ${response.reasonPhrase}");
      }


    }catch(e){
      print("An error occurred: $e");
      //Utility().ShowToast("An error occurred: $e");

    }
  }

  void LocationAlertDialog(BuildContext context){
    showDialog(context: context,
        builder: (builder){
          return AlertDialog(
            title: Text('Change Location',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
            ),),
            content: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Autocomplete<String> (
                    optionsBuilder: (TextEditingValue Textvalue){
                      print('Typed: ${Textvalue.text}');

                      if(Textvalue.text.isEmpty){
                        return const Iterable<String>.empty();
                      }else{
                        return arrGetLocation.where((location) => location.toLowerCase().contains(Textvalue.text.toLowerCase()));
                      }

                    },onSelected: (String selection){
                    print("Selected: $selection" );

                    Txt_locationController.text = selection;
                    final selectedLocation = hmGetLocation.firstWhere((location) => location['locationname'] == selection,
                        orElse: () => {'locationcode': ''});

                    Txt_locationController.text = selectedLocation['locationcode'] ?? '';

                  },
                    fieldViewBuilder: (context,controller,focusNode,onEditingComplete){
                      focusNode.addListener((){
                        isFocusNode = focusNode.hasFocus;
                      });


                      return TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        onEditingComplete: onEditingComplete,
                        decoration: InputDecoration(
                            labelText: 'Select Location',
                            isDense: true,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey
                            ),

                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    style: BorderStyle.solid,
                                    color: Colors.grey
                                )
                            ),

                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2,
                                    style: BorderStyle.solid,
                                    color: Theme.of(context).primaryColor
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(5))
                            )

                        ),
                      );
                    },

                  ),
                ),
                Text("Selected Location : ${Txt_locationController.text}")

              ],
            ),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);

              },
                  child: Text('OK',
                  style: TextStyle(
                  color: Theme.of(context).primaryColor
                ),
              ))
            ],
          );
        });
  }

}