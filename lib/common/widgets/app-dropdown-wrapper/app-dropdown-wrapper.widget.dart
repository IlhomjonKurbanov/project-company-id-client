import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:flutter/material.dart';

class AppDropDownWrapperWidget extends StatelessWidget {
  const AppDropDownWrapperWidget({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: AppColors.main2, borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: child);
}
