// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/store/models/badge.model.dart';

class EventMarkersWidget extends StatelessWidget {
  const EventMarkersWidget(this.badges);
  final List<BadgeModel> badges;
  @override
  Widget build(BuildContext context) => badges.isEmpty
      ? const SizedBox()
      : Stack(
          children: badges.map((BadgeModel badge) {
          final int index = badges.indexOf(badge);
          switch (index) {
            case 0:
              return Container(
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: badge.color),
                  width: 24,
                  height: 24,
                  child: Center(
                      child: Text(
                          (badge.value is double) &&
                                  ((badge.value as double).round() -
                                          (badge.value as double) ==
                                      0)
                              ? (badge.value as double).round().toString()
                              : badge.value.toString(),
                          style: const TextStyle(
                              color: AppColors.main2, fontSize: 12))));
            case 1:
              return Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: badge.color),
                      width: 8,
                      height: 8));
            case 2:
              return Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: badge.color),
                      width: 8,
                      height: 8));
            case 3:
              return Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: badge.color),
                      width: 8,
                      height: 8));

            default:
              return const SizedBox();
          }
        }).toList());
}
