import 'dart:convert';

import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:flutter/material.dart';

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
