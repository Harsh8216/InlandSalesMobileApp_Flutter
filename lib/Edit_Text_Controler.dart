import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inland_sales_upgrade/Custom_Color_file.dart';

class EditTextField extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final TextInputType inputType;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter> ? inputFormater;

  EditTextField({
    required this.controller,
    required this.inputType,
    required this.lable,
    this.onTap,
    this.readOnly = false,
    this.inputFormater

});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      onTap: (){
        if(onTap != null){
          onTap!();
        }
      },
      readOnly: readOnly,
      inputFormatters: inputFormater,
      decoration: InputDecoration(
          labelText: lable,
          isDense: true,
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
          border: OutlineInputBorder(
              borderSide: BorderSide(style: BorderStyle.solid,width: 2,color: Color(CustomColor.Corp_Skyblue.value)),
              borderRadius: BorderRadius.all(Radius.circular(5))
          )
      ),

    );
  }

}