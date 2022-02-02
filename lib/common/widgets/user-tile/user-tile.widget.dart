// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converting.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-list-tile/app-list-tile.widget.dart';
import 'package:company_id_new/common/widgets/avatar/avatar.widget.dart';
import 'package:company_id_new/screens/user/user.screen.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/store.dart';

class UserTileWidget extends StatelessWidget {
  const UserTileWidget(
      {this.secondaryActions,
      required this.slidableController,
      required this.authPosition,
      required this.user});
  final List<Widget>? secondaryActions;
  final SlidableController slidableController;
  final UserModel user;
  final Positions authPosition;

  @override
  Widget build(BuildContext context) => Slidable(
      controller: slidableController,
      actionPane: const SlidableDrawerActionPane(),
      enabled: authPosition == Positions.Owner && user.endDate == null,
      actionExtentRatio: 0.1,
      secondaryActions: secondaryActions,
      child: AppListTile(
          onTap: () {
            if (user.endDate != null && authPosition != Positions.Owner) {
              return;
            }
            store.dispatch(PushAction(
                UserScreen(uid: user.id), '${user.name} ${user.lastName}'));
          },
          leading: AvatarWidget(avatar: user.avatar, sizes: 50),
          trailing: Text(AppConverting.getPositionFromString(user.position),
              style: TextStyle(
                  color: user.endDate != null
                      ? AppColors.semiGrey
                      : Colors.white)),
          textSpan: TextSpan(
              text: '${user.name} ${user.lastName}',
              style: TextStyle(
                  color:
                      user.endDate != null ? AppColors.semiGrey : Colors.white,
                  fontSize: 16))));
}
