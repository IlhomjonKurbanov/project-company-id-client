import 'package:flutter/material.dart';

import 'app-colors.dart';

class AppDropDownStyles {
  static const InputDecoration decoration = InputDecoration(
      border: InputBorder.none, fillColor: AppColors.main2, filled: true);
  static const TextStyle style = TextStyle(color: Colors.white);

  static const Widget icon = Icon(Icons.expand_more, color: Colors.white);
  static const bool isExpanded = true;
  static const TextStyle hintStyle = TextStyle(color: Colors.white);
}
