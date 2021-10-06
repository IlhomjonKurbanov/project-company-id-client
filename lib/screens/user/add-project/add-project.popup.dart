import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-dropdowns.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-dropdown-wrapper/app-dropdown-wrapper.widget.dart';
import 'package:company_id_new/common/wrappers/popup.wrapper.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({required this.isLoading, required this.projects});
  bool isLoading;
  List<ProjectModel> projects;
}

class AddProjectPopup extends StatefulWidget {
  @override
  _AddProjectPopupState createState() => _AddProjectPopupState();
}

class _AddProjectPopupState extends State<AddProjectPopup> {
  ProjectModel? selectedProject;

  @override
  void initState() {
    store.dispatch(GetProjectsPending(
        projectTypes: ProjectsType.Absent,
        userId: store.state.currentUser!.id));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          isLoading: store.state.isLoading,
          projects: store.state.absentProjects),
      onWillChange: (_, _ViewModel state) {},
      builder: (BuildContext context, _ViewModel state) => PopupWrapper(
          title: 'Add project to user',
          widgets: <Widget>[
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<ProjectModel>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    hint: const Text('Select project',
                        style: AppDropDownStyles.hintStyle),
                    value: selectedProject,
                    onChanged: (ProjectModel? value) => setState(() {
                          selectedProject = value;
                        }),
                    items: state.projects
                        .map((ProjectModel project) =>
                            DropdownMenuItem<ProjectModel>(
                                value: project,
                                child: Text('${project.name} ')))
                        .toList()))
          ],
          buttonSection: AppButtonWidget(
              color: AppColors.green,
              title: 'Add',
              onClick: () {
                store.dispatch(PopAction(isExternal: true));
                store.dispatch(AddUserToProjectPending(
                    store.state.currentUser!, selectedProject!, false,
                    isAddedUserToProject: false));
              })));
}
