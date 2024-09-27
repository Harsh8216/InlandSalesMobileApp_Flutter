import 'package:flutter/cupertino.dart';

class Color_Combination_Box extends StatelessWidget{
  final Color firstColor;
  final Color secondColor;
  final bool isHorizontal;


  Color_Combination_Box({
      required this.firstColor,
      required this.secondColor,
      this.isHorizontal = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,

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