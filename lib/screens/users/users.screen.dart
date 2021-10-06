import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/widgets/user-tile/user-tile.widget.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({required this.users, required this.user});
  List<UserModel> users;
  UserModel user;
}

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final SlidableController _slidableController = SlidableController();

  @override
  void initState() {
    super.initState();
    if (store.state.users.isNotEmpty) {
      return;
    }
    store.dispatch(GetUsersPending(true));
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) =>
          _ViewModel(users: store.state.users, user: store.state.user!),
      builder: (BuildContext context, _ViewModel state) => SmartRefresher(
          controller: RefreshController(initialRefresh: false),
          onRefresh: () => store.dispatch(GetUsersPending(true)),
          enablePullDown: true,
          child: ListView(
              children: state.users
                  .where((UserModel user) => user.id != state.user.id)
                  .map((UserModel user) => UserTileWidget(
                          user: user,
                          authPosition: state.user.position!,
                          slidableController: _slidableController,
                          secondaryActions: <Widget>[
                            IconSlideAction(
                                color: AppColors.bg,
                                icon: Icons.archive,
                                onTap: () =>
                                    store.dispatch(ArchiveUserPending(user.id)))
                          ]))
                  .toList())));
}
