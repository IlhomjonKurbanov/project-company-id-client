// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';

class AdminWrapper extends StatelessWidget {
  const AdminWrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, UserModel?>(
        converter: (Store<AppState> store) => store.state.user,
        builder: (BuildContext context, UserModel? user) {
          if (user?.position == Positions.Owner) {
            return const SizedBox();
          }
          return child;
        });
  }
}
