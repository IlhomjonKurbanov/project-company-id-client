import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:flutter/material.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget(
      {required this.title,
      required this.onClick,
      this.isLoading = false,
      this.color = AppColors.main,
      this.width = 100});
  final bool isLoading;
  final Color color;
  final String title;
  final double width;
  final Function onClick;
  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => onClick(),
      child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          width: width,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(22)),
          child: isLoading
              ? Column(children: const <Widget>[
                  SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)))
                ])
              : Text(title,
                  style: const TextStyle(color: AppColors.main2, fontSize: 14),
                  textAlign: TextAlign.center)));
}
