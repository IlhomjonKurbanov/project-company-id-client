// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/store.dart';

class ConfirmDialogWidget extends StatelessWidget {
  const ConfirmDialogWidget({required this.title, required this.text});
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => AlertDialog(
          title: Text(title),
          content: Builder(
              builder: (BuildContext context) => Container(
                  width: MediaQuery.of(context).size.width,
                  child:
                      Text(text, style: const TextStyle(color: Colors.white)))),
          actions: <Widget>[
            AppButtonWidget(
                color: AppColors.green,
                onClick: () => store.dispatch(const PopAction(
                    params: true, changeTitle: false, isExternal: true)),
                title: 'Confirm'),
            AppButtonWidget(
                title: 'Cancel',
                onClick: () => store.dispatch(const PopAction(
                    params: false, changeTitle: false, isExternal: true)))
          ]);
}
