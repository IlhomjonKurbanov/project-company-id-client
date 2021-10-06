import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';

mixin AppHelper {
  static SpeedDialChild speedDialChild(Function func, Widget icon) =>
      SpeedDialChild(
          child: icon, backgroundColor: AppColors.main, onTap: () => func());
  static Future<dynamic> openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      store.dispatch(
          Notify(NotifyModel(NotificationType.Error, 'Could not launch $url')));
    }
  }
}
