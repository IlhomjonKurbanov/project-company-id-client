import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:flutter/material.dart';

class SocialRowIconWidget extends StatelessWidget {
  const SocialRowIconWidget(
      {this.url, required this.icon, required this.title, this.fullWidth});
  final IconData icon;
  final String title;
  final double? fullWidth;
  final String? url;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          if (url == null) {
            return;
          }
          AppHelper.openUrl(url!);
        },
        child: SizedBox(
            width: fullWidth,
            child: Row(children: <Widget>[
              Icon(icon, color: Colors.grey, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 16, overflow: TextOverflow.ellipsis)),
              )
            ])),
      );
}
