import 'package:flutter/material.dart';

class PopupWrapper extends StatelessWidget {
  const PopupWrapper(
      {required this.title,
      required this.widgets,
      required this.buttonSection});
  final String title;
  final List<Widget> widgets;
  final Widget buttonSection;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
            24,
            24,
            24,
            MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text(title, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          ...widgets,
          const SizedBox(height: 32),
          buttonSection
        ]));
  }
}
