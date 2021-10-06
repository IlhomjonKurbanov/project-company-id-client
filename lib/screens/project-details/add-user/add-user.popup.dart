import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-dropdowns.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-dropdown-wrapper/app-dropdown-wrapper.widget.dart';
import 'package:company_id_new/common/wrappers/popup.wrapper.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel(
      {required this.isLoading, required this.users, required this.project});
  bool isLoading;
  List<UserModel> users;
  ProjectModel project;
}

class AddUserPopup extends StatefulWidget {
  @override
  _AddUserPopupState createState() => _AddUserPopupState();
}

class _AddUserPopupState extends State<AddUserPopup> {
  UserModel? selectedUser;

  @override
  void initState() {
    store.dispatch(GetUsersPending(false,
        usersType: UsersType.Absent, projectId: store.state.project!.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          isLoading: store.state.isLoading,
          users: store.state.absentUsers,
          project: store.state.project!),
      builder: (BuildContext context, _ViewModel state) => PopupWrapper(
          title: 'Add user to project',
          widgets: <Widget>[
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<UserModel>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    hint: const Text('Select user',
                        style: AppDropDownStyles.hintStyle),
                    value: selectedUser,
                    onChanged: (UserModel? value) => setState(() {
                          selectedUser = value;
                        }),
                    items: state.users
                        .map((UserModel user) => DropdownMenuItem<UserModel>(
                            value: user,
                            child: Text('${user.name} ${user.lastName}')))
                        .toList()))
          ],
          buttonSection: AppButtonWidget(
              color: AppColors.green,
              title: 'Add',
              onClick: () {
                store.dispatch(PopAction(isExternal: true));
                store.dispatch(AddUserToProjectPending(
                    selectedUser!, state.project, false));
              })));
}
