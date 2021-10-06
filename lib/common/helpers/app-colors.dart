import 'package:flutter/material.dart';

mixin AppColors {
  static const Color main = Color(0xffFFCC00);
  static const Color main2 = Color(0xff242422);
  static const Color lightGrey = Color.fromRGBO(204, 204, 204, 1);
  static const Color semiGrey = Color.fromRGBO(204, 204, 204, 0.5);
  static const Color bg = Color(0xff090f2c);
  static const Color secondary = Color.fromRGBO(63, 59, 64, 1);
  static const Color green = Color.fromRGBO(46, 161, 120, 1);
  static const Color darkRed = Color.fromRGBO(227, 76, 76, 1);
  static const Color yellow = Color.fromRGBO(231, 190, 51, 1);
  static const Color orange = Color.fromRGBO(231, 143, 52, 1);

  static Color getColorTextVacation(String text) {
    switch (text) {
      case 'pending':
        return yellow;
      case 'approved':
        return green;
      case 'rejected':
        return darkRed;
      default:
        return Colors.white;
    }
  }
}
