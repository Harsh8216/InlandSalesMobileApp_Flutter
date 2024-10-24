import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditTextField extends StatefulWidget {
  final TextEditingController controller;
  final String lable;
  final TextInputType inputType;
  final VoidCallback? onTap;
  final bool readOnly;
  final List<TextInputFormatter> ? inputFormater;

  const EditTextField({super.key, 
    required this.controller,
    required this.inputType,
    required this.lable,
    this.onTap,
    this.readOnly = false,
    this.inputFormater,

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
      decoration: InputDecoration(
          labelText: widget.lable,
          isDense: true,
          labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: isFocusNode ? Theme.of(context).primaryColor : Colors.grey,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),

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
              color: Theme.of(context).primaryColor,
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