import 'package:flutter/cupertino.dart';

class MiddleRoundCutCliper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    double cutRadius = 15.0;  // Radius of the round cuts
    double cutOffset = size.width * 0.20; // Offset from the corners to the middle
    double middleHeight = size.height * 0.5; // Position for the middle of the left and right sides

    // Start at the top-left corner
    path.moveTo(0, 0);

    // Move to the middle left and draw the left rounded cut
    path.lineTo(0,middleHeight - cutRadius);

    path.arcToPoint(
      Offset(0,middleHeight + cutRadius),
      radius: Radius.circular(cutRadius),
      clockwise: false,
    );

    // Continue along the top side to the middle right
    path.lineTo(0,size.height);

    // Move to the bottom-right corner
    path.lineTo(size.width, size.height);

    // Move up the right edge to just before the middle rounded cut
    path.lineTo(size.width, middleHeight + cutRadius);

    // Draw the right rounded cut
    path.arcToPoint(
      Offset(size.width, middleHeight - cutRadius),
      radius: Radius.circular(cutRadius),
      clockwise: false,
    );

    // Move to the top-right corner
    path.lineTo(size.width, 0);


    // Draw the right side, bottom side, and left side of the card
    /*path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);*/
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}