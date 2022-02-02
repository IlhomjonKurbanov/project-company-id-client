// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-helper.dart';

class SocialRowWidget extends StatelessWidget {
  const SocialRowWidget(
      {required this.iconName, required this.title, this.url, this.fullWidth});
  final String iconName;
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
              Image.asset(iconName, color: Colors.grey, width: 16, height: 16),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(title,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis))
            ])),
      );
}
