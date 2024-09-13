import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Activity_Leave_List.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Edit_Text_Controler.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apply_for_leaves extends StatefulWidget {
  @override
  State<Apply_for_leaves> createState() => ApplyForLeavesStates();

}

class ApplyForLeavesStates extends State<Apply_for_leaves> {
  var FromDateController = TextEditingController();
  var ToDateController = TextEditingController();
  var ResposiblePersonController = TextEditingController();
  var ContactNoController = TextEditingController();
  var ReasonController = TextEditingController();
  var strMsg;
  List<Map<String, String>> responsiblePerson = [];
  List<String> responsiblePersonNames = [];

  @override
  void initState() {
    super.initState();
    fetchResponsiblePersons();

  }

  void ShowToast(String Msg) {
    Fluttertoast.showToast(msg: Msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
        backgroundColor: Colors.green,
        textColor: Colors.white);
  }
  
  Future<void> fetchResponsiblePersons() async {
  var pref = await SharedPreferences.getInstance();
  String ? strEmpcd = pref.getString(Constant.Empcd);

  final Map<String, String> requestBody = {
  'Empcd': "$strEmpcd",
  'Tokenno': "${Constant.TokenNo}"
  };

  try {
    final http.Response responseBody = await http.post(
        Uri.parse("${Constant.baseurl + EndPoint.GetEmployee_ResponsiblePerson}"),
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"}
    );

    if (responseBody.statusCode == 200) {
      final List<dynamic> responseData = json.decode(responseBody.body);

      setState(() {
        //_DataList = json.decode(responseBody.body);
        responsiblePerson = responseData.map((person) => {
          'ResPersonEmpcd': person['ResPersonEmpcd'].toString(),
          'ResPersonEmpnm': person['ResPersonEmpnm'].toString(),
        }).toList();
        print("responsiblePerson : $responsiblePerson");

        responsiblePersonNames = responsiblePerson.map((person) => person['ResPersonEmpnm']!).toList();
        print("responsiblePersonNames :  $responsiblePersonNames");
      });
    } else {
      ShowToast("Error: ${responseBody.statusCode} - ${responseBody.reasonPhrase}");
    }

  }catch (error) {
    print("Error: $error");
    ShowToast("An error occurred: $error");
  }

  }

  void LeaveRequestFetchData() async{
    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd);
    final Map<String,String> requestBody = {
      'Empcd' : "$strEmpcd",
      'Tokenno' : "${Constant.TokenNo}",
      'FromDate' : FromDateController.text,
      'TODate' : ToDateController.text,
      'ResPersonEmpcd' : ResposiblePersonController.text,
      'EMobNo' : ContactNoController.text,
      'Reason' : ReasonController.text,
    };

    print("Request Body: $requestBody");

    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext contact){

            return Center(
              child: CircularProgressIndicator(color: Color(0xFFC00018),backgroundColor: Colors.cyanAccent,strokeWidth: 4.0));

          }
      );

      final http.Response responseBody = await http.post(
        Uri.parse("${Constant.baseurl + EndPoint.LeaveApply}"),
        body: jsonEncode(requestBody),
        headers: {"Content-Type": "application/json"}
      );
      print("Status Code: ${responseBody.statusCode}");
      print("Response Body: ${responseBody.body}");

      if(responseBody.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(responseBody.body);
        print(responseData.length);

        setState(() {
          strMsg = responseData;
        });

        strMsg = responseData ['Msg']?? 'No Message Received';
        var strStatus = responseData ['Status'];

        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if(strStatus.toString().toUpperCase() == "OK"){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext contact) {
                return AlertDialog(
                  title: Text("Success",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900,fontSize: 18)),
                  content: Text(strMsg,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Leave_List()));
                    }, child: Text("OK"))

                  ],
                );
              }
          );

        }else{
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext contact) {
                return AlertDialog(
                  title: Text("Alert",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18)),
                  content: Text(strMsg,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Leave_List()));
                    }, child: Text("OK"))

                  ],
                );
              }
          );


        }

      }else{
        ShowToast("Error: ${responseBody.statusCode} - ${responseBody.reasonPhrase}");
      }

    }catch(error){
      print("Error: $error"); // Print the error for debugging
      ShowToast("An error occurred: $error");

    }

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(title: Text("Apply for Leaves",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
         backgroundColor: Color(CustomColor.Corp_Red.value),iconTheme: IconThemeData(color: Colors.white)),
     body: Padding(
       padding: const EdgeInsets.all(12),
       child: Column(
         children: [
           Row(
             children: [
               Expanded(
                   child: Padding(
                     padding: const EdgeInsets.only(right: 2.5),
                     child: EditTextField(
                       controller: FromDateController,
                       lable: "From Date",
                       inputType: TextInputType.none,
                       onTap: () => _selectDate(context,FromDateController),
                       readOnly: true,
                     ),
                   )),


               Expanded(
                   child: Padding(
                     padding: const EdgeInsets.only(right: 2.5),
                     child: EditTextField(
                       controller: ToDateController,
                       lable: "To Date",
                       inputType: TextInputType.none,
                       onTap: () => _selectDate(context,ToDateController),
                       readOnly: true,
                     ),
                   )),
             ],
           ),
           SizedBox(height: 16),


           Autocomplete<String>(
               optionsBuilder: (TextEditingValue textEditingValue){
                 print("Typed: ${textEditingValue.text}");

                 if(textEditingValue.text.isEmpty){
                   return const Iterable<String>.empty();

                 }
                 return responsiblePersonNames.where((person) => person.toLowerCase().contains(textEditingValue.text.toLowerCase()));

           },onSelected: (String selection){
             print("Selected: $selection");
                 ResposiblePersonController.text = selection;
                 final selectedPerson = responsiblePerson.firstWhere((person) => person['ResPersonEmpnm'] == selection,
                     orElse: () => {'ResPersonEmpcd': ''});
                 ResposiblePersonController.text = selectedPerson['ResPersonEmpcd'] ?? '';
           },
             fieldViewBuilder: (context, controller,focusNode,onEditingComplete){
                 return TextFormField(
                     controller: controller,
                     focusNode: focusNode,
                     onEditingComplete: onEditingComplete,
                     decoration: InputDecoration(
                     labelText: "Responsible Person",
                       isDense: true,
                       labelStyle: TextStyle(
                           fontWeight: FontWeight.bold
                       ),
                     border: OutlineInputBorder(),
               ),

                 );
             }

           ),
           SizedBox(height: 16),

           
           EditTextField(
              controller:  ContactNoController,
              lable:  "Contact No",
              readOnly: false,
              inputType:  TextInputType.phone,
              onTap:() => null,
           ),
           SizedBox(height: 16),

           EditTextField(
              controller:  ReasonController,
              lable:  "Reason",
              inputType:  TextInputType.multiline,
              onTap:() => null,
              readOnly: false,
           ),
           SizedBox(height: 50),
           
           ElevatedButton(onPressed: (){
             LeaveRequestFetchData();
             
           },
             style: ElevatedButton.styleFrom(
               backgroundColor: Color(CustomColor.Corp_Red.value),
               minimumSize: const ui.Size(180, 50),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

             ),
               child: Text('SUBMIT',
                 style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)
               ),
           )
         ],
       ),
     ),

   );
  }

}


Future<void> _selectDate(BuildContext context,TextEditingController controller) async{
  DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),

  builder: (context,child){
        return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Color(CustomColor.Corp_Red.value),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Color(CustomColor.Corp_Red.value),
                )
              )

            ),
            child: child!);

  }
  );

  if(selectedDate != null){
    controller.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
  }

}