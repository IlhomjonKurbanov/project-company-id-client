import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AppSpeedDial extends StatelessWidget {
  const AppSpeedDial({this.speedDials, required this.icon, this.onPress});
  final List<SpeedDialChild>? speedDials;
  final IconData icon;
  final Function? onPress;

  @override
  Widget build(BuildContext context) => SpeedDial(
      foregroundColor: AppColors.main2,
      child: Icon(icon),
      elevation: 8.0,
      shape: const CircleBorder(),
      curve: Curves.bounceIn,
      onPress: onPress != null ? () => onPress!() : null,
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22.0),
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: speedDials ?? <SpeedDialChild>[]);
}
