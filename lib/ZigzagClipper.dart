import 'package:flutter/cupertino.dart';

class ZigzagClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    double step = 10.0;
    double zigzagHeight = 5.0;
    path.moveTo(0, 0);

    for(double i = 0; i< size.width; i+= step){
      path.lineTo(i + step / 2, size.height);
      path.lineTo(i + step, size.height - zigzagHeight);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();


    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
  
}