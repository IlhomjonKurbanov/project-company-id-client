import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/avatar/avatar.widget.dart';
import 'package:company_id_new/common/widgets/confirm-dialog/confirm-dialog.widget.dart';
import 'package:company_id_new/screens/requests/requests.screen.dart';
import 'package:company_id_new/screens/user/user.screen.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({this.user, required this.titles, required this.requests});
  List<String> titles;
  UserModel? user;
  List<LogModel> requests;
}

class AppBarWidget extends StatefulWidget with PreferredSizeWidget {
  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          user: store.state.user,
          titles: store.state.titles,
          requests: store.state.requests),
      builder: (BuildContext context, _ViewModel state) {
        if (state.user == null) {
          return const SizedBox();
        }
        return AppBar(
            leading: GestureDetector(
                onTap: () {
                  final String fullName =
                      '${state.user?.name} ${state.user?.lastName}';
                  if (fullName == state.titles.last) {
                    return;
                  }
                  store.dispatch(
                      PushAction(UserScreen(uid: state.user!.id), fullName));
                },
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        AvatarWidget(avatar: state.user?.avatar, sizes: 20))),
            title: Text(state.titles.isNotEmpty ? state.titles.last : ''),
            actions: <Widget>[
              state.requests.isEmpty ||
                      store.state.user!.position != Positions.Owner
                  ? const SizedBox()
                  : Stack(children: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.notifications),
                          onPressed: () {
                            store.dispatch(
                                PushAction(RequestsScreen(), 'Requests'));
                          }),
                      _buildRequestsBadge(state.requests.length.toString())
                    ]),
              _buildLogout(context)
            ],
            automaticallyImplyLeading: false);
      });

  Widget _buildRequestsBadge(String text) => Positioned(
      right: 8,
      top: 8,
      child: Container(
          padding: const EdgeInsets.all(1),
          decoration: const BoxDecoration(
              color: AppColors.main2, shape: BoxShape.circle),
          constraints: const BoxConstraints(minWidth: 13, minHeight: 13),
          child: Center(
              child: Text(text,
                  style: const TextStyle(fontSize: 9),
                  textAlign: TextAlign.center))));

  Widget _buildLogout(BuildContext context) => Stack(children: <Widget>[
        IconButton(
            icon: const Icon(Icons.exit_to_app, color: AppColors.main2),
            onPressed: () async {
              final bool? isConfirm = await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => const ConfirmDialogWidget(
                      title: 'Logout', text: 'Are you sure to logout'));
              if (isConfirm != null && !isConfirm) {
                return;
              }
              store.dispatch(LogoutPending());
            })
      ]);
}
