import 'dart:ui' as ui;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Activity_Leave_List.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Edit_Text_Controler.dart';
import 'package:inland_sales_upgrade/Network.dart';
import 'package:inland_sales_upgrade/Side_Navigation_Drawer.dart';
import 'package:inland_sales_upgrade/Utility.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Apply_for_leaves extends StatefulWidget {
  final Function(ThemeData) onThemeChange;
  const Apply_for_leaves({super.key, required this.onThemeChange});

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
  bool isFocusNode = false;
  List<Map<String, String>> responsiblePerson = [];
  List<String> responsiblePersonNames = [];

  @override
  void dispose() {
    ResposiblePersonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchResponsiblePersons();

  }

  Future<void> fetchResponsiblePersons() async {
  var pref = await SharedPreferences.getInstance();
  String ? strEmpcd = pref.getString(Constant.Empcd);

  final Map<String, String> requestBody = {
  'Empcd': "$strEmpcd",
  'Tokenno': Constant.TokenNo
  };

  try {
    final http.Response responseBody = await http.post(
        Uri.parse(Constant.baseurl + EndPoint.GetEmployee_ResponsiblePerson),
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
      Utility().ShowToast("Error: ${responseBody.statusCode} - ${responseBody.reasonPhrase}");
    }

  }catch (error) {
    print("Error: $error");
    Utility().ShowToast("An error occurred: $error");
  }

  }

  void LeaveRequestFetchData() async{
    if(FromDateController.text.isEmpty){
      Utility().ShowToast("Please select a From Date.");
      return;
    }
    if (ToDateController.text.isEmpty) {
      Utility().ShowToast("Please select a To Date.");
      return;
    }

    if (ResposiblePersonController.text.isEmpty) {
      Utility().ShowToast("Please select a Responsible Person.");
      return;
    }

    if(!RegExp(r'^[0-9]{10}$').hasMatch(ContactNoController.text)){
      Utility().ShowToast("Please enter a valid 10-digit Contact Number.");
      return;

    }
    if (ReasonController.text.isEmpty) {
      Utility().ShowToast("Please provide a reason for leave.");
      return;
    }

    DateTime fromDate = DateFormat('dd/mm/yyyy').parse(FromDateController.text);
    DateTime ToDate = DateFormat('dd/mm/yyyy').parse(ToDateController.text);

    if(fromDate.isAfter(ToDate)){
      Utility().ShowToast("From Date cannot be after To Date.");
      return;
    }


    var pref = await SharedPreferences.getInstance();
    String ? strEmpcd = pref.getString(Constant.Empcd);
    final Map<String,String> requestBody = {
      'Empcd' : "$strEmpcd",
      'Tokenno' : Constant.TokenNo,
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

            return const Center(
              child: CircularProgressIndicator(
                  color: CustomColor.Corp_Red,
                  backgroundColor: CustomColor.Corp_Skyblue,
                  strokeWidth: 4.0
              ));

          }
      );

      final http.Response responseBody = await http.post(
        Uri.parse(Constant.baseurl + EndPoint.LeaveApply),
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
                  title: const Text("Success",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900,fontSize: 18)),
                  content: Text(strMsg,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      //Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Leave_List(onThemeChange: widget.onThemeChange)));
                    }, child: const Text("OK"))

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
                  title: const Text("Alert",style: TextStyle(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 18)),
                  content: Text(strMsg,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                  actions: <Widget>[
                    TextButton(onPressed: () {
                      //Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Activity_Leave_List(onThemeChange: widget.onThemeChange,)));
                    }, child: const Text("OK"))

                  ],
                );
              }
          );

        }

      }else{
        Utility().ShowToast("Error: ${responseBody.statusCode} - ${responseBody.reasonPhrase}");
      }

    }catch(error){
      print("Error: $error"); // Print the error for debugging
      Utility().ShowToast("An error occurred: $error");

    }

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     endDrawer: SideNavigationDrawer(onThemeChange: widget.onThemeChange,),
     appBar: AppBar(title: Text("Apply for Leaves",
         style: TextStyle(
             color: Theme.of(context).canvasColor,
             fontWeight: FontWeight.bold,
             fontSize: 18
         )
     ),

         backgroundColor: Theme.of(context).primaryColor,
         iconTheme: IconThemeData(
             color: Theme.of(context).canvasColor
         )),

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
           const SizedBox(height: 16),


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
                 focusNode.addListener((){
                   setState(() {
                     isFocusNode = focusNode.hasFocus;

                   });

                 });

                 return TextFormField(
                     controller: controller,
                     focusNode: focusNode,
                     onEditingComplete: onEditingComplete,
                     decoration: InputDecoration(
                     labelText: "Responsible Person",
                       isDense: true,
                       labelStyle: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: focusNode.hasFocus ? Theme.of(context).primaryColor : Colors.grey
                       ),
                     border: const OutlineInputBorder(
                       borderSide: BorderSide(
                         style: BorderStyle.solid,
                         width: 2,
                         color: Colors.grey,
                       )

                     ),
                       enabledBorder: const OutlineInputBorder(
                           borderSide: BorderSide(
                             style: BorderStyle.solid,
                             width: 1,
                             color: Colors.grey,
                           ),
                           borderRadius: BorderRadius.all(Radius.circular(5))
                       ),

                       focusedBorder: OutlineInputBorder(
                         borderSide: BorderSide(
                             color: Theme.of(context).primaryColor,
                             width: 2,
                         ),
                         borderRadius: const BorderRadius.all(Radius.circular(5),
                         ),

                       ),

               ),

                 );
             },
             optionsViewBuilder: (BuildContext context,AutocompleteOnSelected<String> onSelected,Iterable<String> options){
                 return Align(
                   alignment: Alignment.topCenter,
                   child: Material(
                     elevation: 8.0,
                     child: SizedBox(
                       height: 300,
                       child: ListView.separated(
                           itemBuilder: (BuildContext context,int index){
                             final String option = options.elementAt(index);
                             return GestureDetector(
                               onTap: (){
                                 onSelected(option);
                               },
                               child: ListTile(
                                 title: Text(option,
                                 style: const TextStyle(
                                 color: Colors.black
                                 ),
                                 ),
                                 tileColor: Colors.white,
                               ),
                             );

                           },
                           separatorBuilder: (BuildContext context, int index) =>
                           const Divider(
                             color: Colors.grey,
                             height: 1,
                           ),
                           itemCount: options.length
                       ),
                     ),
                   ),
                 );
             },

           ),
           const SizedBox(height: 16),

           
           EditTextField(
              controller:  ContactNoController,
              lable:  "Contact No",
              readOnly: false,
              inputType:  TextInputType.phone,
              onTap:() {},
              inputFormater: [LengthLimitingTextInputFormatter(10)]
           ),
           const SizedBox(height: 16),

           EditTextField(
              controller:  ReasonController,
              lable:  "Reason",
              inputType:  TextInputType.multiline,
              onTap:() {},
              readOnly: false,
           ),
           const SizedBox(height: 50),
           
           ElevatedButton(onPressed: (){
             LeaveRequestFetchData();
             
           },
             style: ElevatedButton.styleFrom(
               backgroundColor: Theme.of(context).primaryColor,
               minimumSize: const ui.Size(180, 50),
               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),

             ),
               child: const Text('SUBMIT',
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
                primary: Theme.of(context).primaryColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
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