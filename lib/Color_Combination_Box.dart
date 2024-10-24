import 'package:flutter/material.dart';

class Color_Combination_Box extends StatelessWidget{
  final Color firstColor;
  final Color secondColor;
  final bool isHorizontal;


  const Color_Combination_Box({super.key, 
      required this.firstColor,
      required this.secondColor,
      this.isHorizontal = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
          style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.circular(2)
      ),

      child: isHorizontal ? Row(
        children: [
          Expanded(
              child: Container(
                color: firstColor,
              ),
          ),
          Expanded(
              child: Container(
                color: secondColor,

          ))
        ],

      ) : Column(
        children: [
          Expanded(
            child: Container(
              color: firstColor,
            ),
          ),
          Expanded(
            child: Container(
              color: secondColor,
            ),
          ),
        ],

      )

    );
  }
  
}