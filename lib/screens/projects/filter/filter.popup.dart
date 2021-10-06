import 'package:collection/collection.dart';
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-dropdowns.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-dropdown-wrapper/app-dropdown-wrapper.widget.dart';
import 'package:company_id_new/common/wrappers/popup.wrapper.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/stack.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/project-spec.model.dart';
import 'package:company_id_new/store/models/project-status.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/projects-filter.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel(
      {required this.user,
      required this.users,
      required this.stack,
      required this.projects,
      this.filter});
  UserModel user;
  ProjectsFilterModel? filter;
  List<UserModel> users;
  List<StackModel> stack;
  List<ProjectModel> projects;
}

class FilterProjectsPopup extends StatefulWidget {
  @override
  _FilterProjectsPopupState createState() => _FilterProjectsPopupState();
}

class _FilterProjectsPopupState extends State<FilterProjectsPopup> {
  StackModel? selectedStack;
  UserModel? selectedUser;
  List<ProjectStatusModel> statuses = <ProjectStatusModel>[
    ProjectStatusModel(AppConstants.All, ProjectStatus.All),
    ProjectStatusModel(AppConstants.Ongoing, ProjectStatus.Ongoing),
    ProjectStatusModel(AppConstants.Finished, ProjectStatus.Finished),
    ProjectStatusModel(AppConstants.Rejected, ProjectStatus.Rejected)
  ];
  List<ProjectSpecModel> specs = <ProjectSpecModel>[
    ProjectSpecModel(AppConstants.All, ProjectSpec.All),
    ProjectSpecModel(AppConstants.Commercial, ProjectSpec.Commercial),
    ProjectSpecModel(AppConstants.Internal, ProjectSpec.Internal),
  ];
  ProjectSpecModel? selectedProjectSpec;
  ProjectStatusModel? selectedProjectStatus;
  @override
  void initState() {
    selectedProjectStatus = statuses.firstWhere(
        (ProjectStatusModel projectStatus) =>
            projectStatus.status == ProjectStatus.All);
    selectedProjectSpec = specs.firstWhere((ProjectSpecModel projectStatus) =>
        projectStatus.spec == ProjectSpec.All);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          user: store.state.user!,
          projects: store.state.projects,
          filter: store.state.projectsFilter,
          users: store.state.filterProjectsUsersStack.users,
          stack: store.state.filterProjectsUsersStack.stack),
      onWillChange: (_, _ViewModel state) {
        if (selectedStack != null) {
          setState(() {
            selectedStack = state.stack.firstWhereOrNull(
                (StackModel stack) => stack.id == selectedStack!.id);
          });
        }
        if (selectedUser != null) {
          setState(() {
            selectedUser = state.users.firstWhereOrNull(
                (UserModel user) => user.id == selectedUser!.id);
          });
        }
        if (state.stack.isNotEmpty &&
            state.filter?.stack?.id != null &&
            selectedStack == null) {
          setState(() {
            selectedStack = state.stack.firstWhereOrNull(
                (StackModel stack) => stack.id == state.filter!.stack!.id);
          });
        }
        if (state.users.isNotEmpty &&
            state.filter?.user?.id != null &&
            selectedUser == null) {
          setState(() {
            selectedUser = state.users.firstWhereOrNull(
                (UserModel user) => user.id == state.filter!.user!.id);
          });
        }
      },
      onInit: (Store<AppState> store) {
        store.dispatch(
            GetUsersPending(false, usersType: UsersType.ProjectFilter));
        store.dispatch(GetStackPending(stackTypes: StackTypes.ProjectFilter));
        if (store.state.projectsFilter?.spec != null) {
          selectedProjectSpec = specs.firstWhere(
              (ProjectSpecModel projectStatus) =>
                  projectStatus.spec == store.state.projectsFilter!.spec!.spec);
        }
        if (store.state.projectsFilter?.status != null) {
          selectedProjectStatus = statuses.firstWhere(
              (ProjectStatusModel projectStatus) =>
                  projectStatus.status ==
                  store.state.projectsFilter!.status!.status);
        }
      },
      builder: (BuildContext context, _ViewModel state) => PopupWrapper(
          title: 'Filters',
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
                    onChanged: (UserModel? value) {
                      store.dispatch(GetProjectsFilterStackPending(value!.id));
                      setState(() {
                        selectedUser = value;
                      });
                    },
                    items: state.users
                        .map((UserModel user) => DropdownMenuItem<UserModel>(
                            value: user,
                            child: Text('${user.name} ${user.lastName}')))
                        .toList())),
            const SizedBox(height: 8),
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<StackModel>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    hint: const Text('Select stack',
                        style: AppDropDownStyles.hintStyle),
                    value: selectedStack,
                    onChanged: (StackModel? value) {
                      store.dispatch(GetProjectsFilterUsersPending(value!.id));
                      setState(() {
                        selectedStack = value;
                      });
                    },
                    items: state.stack
                        .map((StackModel stack) => DropdownMenuItem<StackModel>(
                            value: stack, child: Text(stack.name)))
                        .toList())),
            const SizedBox(height: 8),
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<ProjectSpecModel>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    value: selectedProjectSpec,
                    onChanged: (ProjectSpecModel? value) {
                      setState(() {
                        selectedProjectSpec = value;
                      });
                    },
                    items: specs
                        .map((ProjectSpecModel spec) =>
                            DropdownMenuItem<ProjectSpecModel>(
                                value: spec, child: Text(spec.title)))
                        .toList())),
            const SizedBox(height: 8),
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<ProjectStatusModel>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    value: selectedProjectStatus,
                    onChanged: (ProjectStatusModel? value) {
                      setState(() {
                        selectedProjectStatus = value;
                      });
                    },
                    items: statuses
                        .map((ProjectStatusModel status) =>
                            DropdownMenuItem<ProjectStatusModel>(
                                value: status, child: Text(status.title)))
                        .toList()))
          ],
          buttonSection: AppButtonWidget(
              color: AppColors.green,
              title: 'Apply',
              onClick: () => _applyFilter(state))));

  void _applyFilter(_ViewModel state) {
    store.dispatch(PopAction(isExternal: true));
    store.dispatch(SaveProjectsFilter(ProjectsFilterModel(
        spec: selectedProjectSpec,
        stack: selectedStack,
        user: selectedUser,
        status: selectedProjectStatus)));
  }
}
