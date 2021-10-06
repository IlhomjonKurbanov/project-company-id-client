import 'package:flutter/material.dart';

mixin AppValidators {
  static String? validateSize(String? value, int length, String errorText) {
    if (value!.length < length)
      return errorText;
    else
      return null;
  }

  static String? validateIsEmpty(String? value, String errorText) {
    if (value!.isEmpty) {
      return errorText;
    }
    return null;
  }

  static String? validateIsEmptyNull<T>(T? value, String errorText) {
    if (value == null) {
      return errorText;
    }
    return null;
  }

  static String? compareValidate(
      String? value, TextEditingController controller, String errorText) {
    if (value != controller.text) {
      return errorText;
    } else
      return null;
  }

  static String? validateTiming(String? value, String text) {
    final RegExp regex = RegExp(
        r'((([1-9])|([1-2][0-3]))h\s(([0-5][0-9])|[0-9])m)|^((([1-9])|([1-2][0-3]))h)$|^(([0-5][0-9])|([1-9]))m$');
    if (!regex.hasMatch(value!)) {
      return text;
    } else {
      return null;
    }
  }
}
