import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inland_sales_upgrade/Custom_Color_file.dart';
import 'package:inland_sales_upgrade/Network.dart';

class GlobalAutocomplete extends StatelessWidget{
  final List<String> options;
  final TextEditingController controller;
  final String label;
  final ValueChanged <String> onSelected;
  final bool isDense;

  const GlobalAutocomplete({
    Key? key,
    required this.options,
    required this.controller,
    required this.label,
    required this.onSelected,
    required this.isDense

}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
        optionsBuilder: (TextEditingValue value){
          if(value.text.isEmpty){
            return const Iterable<String>.empty();

          }
          return options.where((option) => option.toLowerCase().contains(value.text.toLowerCase())
          );
        },
      onSelected: onSelected,

      fieldViewBuilder: (context,fieldController,focusNode,onEditingComplete){
          return TextFormField(
            controller: fieldController,
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            decoration: InputDecoration(
              labelText: label,
              isDense: isDense,
              labelStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: focusNode.hasFocus ? Colors.black54 : Colors.grey
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  width: 1,
                  color: Colors.grey
                )
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  style: BorderStyle.solid,
                  color: Colors.grey,
                  width: 1
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5))
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black54,
                  width: 2
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
              )
            ),
          );
      },
      optionsViewBuilder: (BuildContext context,AutocompleteOnSelected<String> onSelected,Iterable<String> options){
          return Align(
            alignment: Alignment.topCenter,
            child: Material(
              elevation: 8,
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
                          tileColor: Colors.white,
                          title: Text(option,
                            style: TextStyle(
                              color: Colors.black
                            ),


                          ),
                        ),

                      );
                    }
                    , separatorBuilder: (BuildContext context,int index) =>
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

    );
  }
  
}

class GlobalSpinnerDropdown<T> extends StatelessWidget{
  final T ? value;
  final List<T> items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final bool isDense;
  final VoidCallback? onTap;

  GlobalSpinnerDropdown({
    Key ? key,
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    required this.isDense,
    this.onTap

}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DropdownButtonFormField(
          value: value,
          hint: Text(hint,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.bold
          ),

          ),
          isDense: isDense,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1
              )
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                color: Colors.black54,
                width: 2,
              )
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 12)
          ),
          items: items.map((item){
            return DropdownMenuItem<T>(
            value: item,

            child: Text(
            item.toString(),
            style: TextStyle(
            color: Colors.black)
            ),
            );

          }).toList(),

          onChanged: onChanged,
      ),
    );
  }
  
}

class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter> ? inputFormater;
  final IconData? icon;
  final int? maxLines;

  const EditTextField({super.key,
    required this.controller,
    required this.inputType,
    required this.label,
    this.onTap,
    this.readOnly = false,
    this.inputFormater,
    this.icon,
    this.maxLines

  });

  @override
  State<EditTextField> createState() => _EditTextFieldState();
}

class _EditTextFieldState extends State<EditTextField> {
  FocusNode focusNode = FocusNode();
  bool isFocusNode = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener((){
      setState(() {
        isFocusNode = focusNode.hasFocus;

      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      onTap: (){
        if(widget.onTap != null){
          widget.onTap!();
        }
      },
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormater,
      focusNode: focusNode,
      maxLines: widget.maxLines ?? 1,
      decoration: InputDecoration(
        labelText: widget.label,
        isDense: true,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isFocusNode ? Colors.black54 : Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),

        prefixIcon: widget.icon != null
            ? Icon(widget.icon, color: Colors.black)
            : null,

        border: const OutlineInputBorder(
            borderSide: BorderSide(
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))
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
              color: Colors.black54,
              width: 2
          ),
          borderRadius: const BorderRadius.all(Radius.circular(5),
          ),

        ),
        hintStyle: TextStyle(
            color: isFocusNode ? Theme.of(context).primaryColor : Colors.grey
        ),

      ),

    );
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}

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

  Future<void> selectDate(BuildContext context,TextEditingController controller) async{
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

  Future<void> selectTime(BuildContext context, TextEditingController controller) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
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
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      // Convert TimeOfDay to a formatted string
      final hours = selectedTime.hour.toString().padLeft(2, '0');
      final minutes = selectedTime.minute.toString().padLeft(2, '0');
      controller.text = "$hours:$minutes"; // Format as HH:mm
    }
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
