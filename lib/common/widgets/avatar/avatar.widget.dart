// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-constants.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({this.avatar, required this.sizes});
  final String? avatar;
  final double sizes;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: sizes, height: sizes, child: ClipOval(child: _getImage()));
  }

  Widget _getImage() {
    if (avatar!.length > 50) {
      return Image.memory(base64.decode(avatar!.split(',').last),
          gaplessPlayback: true, fit: BoxFit.cover);
    }
    return Image.network('${AppConstants.baseUrl}/user/avatar/$avatar',
        gaplessPlayback: true, fit: BoxFit.cover);
  }
}
