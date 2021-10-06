import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:flutter/material.dart';

class StackWidget extends StatelessWidget {
  const StackWidget({required this.title, this.color});
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(
          color: color ?? AppColors.main,
          borderRadius: BorderRadius.circular(10)),
      child: Text(title, style: const TextStyle(color: AppColors.main2)));
}
