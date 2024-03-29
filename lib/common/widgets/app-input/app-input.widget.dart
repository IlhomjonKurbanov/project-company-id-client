// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';

class AppInput extends StatefulWidget {
  const AppInput(
      {required this.myController,
      required this.labelText,
      this.func,
      this.validator,
      this.errorText,
      this.maxLines = 1,
      this.isDisabledBorder = false,
      this.keyboardType = TextInputType.text,
      this.obscureText = false});
  final String labelText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Function? func;
  final String? errorText;
  final TextInputType keyboardType;
  final int maxLines;
  final bool isDisabledBorder;
  final TextEditingController myController;
  @override
  _AppInputState createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  @override
  Widget build(BuildContext context) => TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      controller: widget.myController,
      maxLines: widget.maxLines,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: AppColors.lightGrey)),
          errorText: widget.errorText,
          errorStyle: const TextStyle(color: AppColors.main),
          focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.main)),
          errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.main)),
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: widget.isDisabledBorder
              ? InputBorder.none
              : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: const BorderSide(color: AppColors.lightGrey))));
}
