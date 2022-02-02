// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-dropdowns.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-dropdown-wrapper/app-dropdown-wrapper.widget.dart';
import 'package:company_id_new/common/wrappers/popup.wrapper.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/log-filter.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class _ViewModel {
  _ViewModel(
      {required this.users,
      required this.projects,
      this.filter,
      required this.isLoading});
  List<ProjectModel> projects;
  List<UserModel> users;
  bool isLoading;
  LogFilterModel? filter;
}

class AdminLogFilterPopup extends StatefulWidget {
  @override
  _AdminLogFilterPopupState createState() => _AdminLogFilterPopupState();
}

class _AdminLogFilterPopupState extends State<AdminLogFilterPopup> {
  late List<String> vacationTypes;
  late List<FilterType> types;
  String? selectedVacationType;
  FilterType? selectedType;
  UserModel? selectedUser;
  ProjectModel? selectedProject;

  @override
  void initState() {
    types = <FilterType>[
      FilterType(AppConstants.All, LogType.All),
      FilterType(AppConstants.Log, LogType.Timelog),
      FilterType(AppConstants.Vacation, LogType.Vacation,
          vacationType: VacationType.VacPaid),
      FilterType(AppConstants.Sickness, LogType.Vacation,
          vacationType: VacationType.SickPaid)
    ];
    vacationTypes = <String>[AppConstants.Paid, AppConstants.NonPaid];
    selectedVacationType = AppConstants.Paid;
    selectedType =
        types.firstWhere((FilterType type) => type.title == AppConstants.All);
    if (store.state.filter?.logType?.title != null) {
      selectedType = types.firstWhere((FilterType type) =>
          type.title == store.state.filter!.logType!.title);
    }
    if (store.state.filter?.logType?.vacationType != null) {
      selectedVacationType =
          _getSelectedVacationType(store.state.filter!.logType!.vacationType!);
    }
    store.dispatch(GetUsersPending(true, usersType: UsersType.Filter));
    store.dispatch(GetProjectsPending(projectTypes: ProjectsType.Filter));
    super.initState();
  }

  @override
  void dispose() {
    store.dispatch(ClearLogFilterLogsUsersProjects());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          projects: store.state.filterLogsUsersProjects.projects,
          users: store.state.filterLogsUsersProjects.users,
          isLoading: store.state.isLoading,
          filter: store.state.filter),
      onWillChange: (_, _ViewModel state) {
        if (selectedProject != null) {
          setState(() {
            selectedProject = state.projects.firstWhereOrNull(
                (ProjectModel project) => project.id == selectedProject!.id);
          });
        }
        if (selectedUser != null) {
          setState(() {
            selectedUser = state.users.firstWhereOrNull(
                (UserModel user) => user.id == selectedUser!.id);
          });
        }
        if (state.projects.isNotEmpty &&
            state.filter?.project?.id != null &&
            selectedProject == null) {
          setState(() {
            selectedProject = state.projects.firstWhereOrNull(
                (ProjectModel project) =>
                    project.id == state.filter!.project!.id);
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
      builder: (BuildContext context, _ViewModel state) => PopupWrapper(
          title: 'Filters',
          widgets: <Widget>[
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<FilterType>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    hint: const Text('Select type',
                        style: AppDropDownStyles.hintStyle),
                    value: selectedType,
                    onChanged: (FilterType? value) => setState(() {
                          selectedType = value;
                        }),
                    items: types
                        .map((FilterType value) => DropdownMenuItem<FilterType>(
                            value: value, child: Text(value.title)))
                        .toList())),
            selectedType?.logType == LogType.Vacation
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: AppDropDownWrapperWidget(
                        child: DropdownButtonFormField<String>(
                            decoration: AppDropDownStyles.decoration,
                            style: AppDropDownStyles.style,
                            icon: AppDropDownStyles.icon,
                            isExpanded: AppDropDownStyles.isExpanded,
                            hint: const Text('Select vacation type',
                                style: AppDropDownStyles.hintStyle),
                            value: selectedVacationType,
                            onChanged: (String? value) =>
                                _onChangedVacation(value),
                            items: vacationTypes
                                .map((String value) => DropdownMenuItem<String>(
                                    value: value, child: Text(value)))
                                .toList())))
                : const SizedBox(height: 16),
            AppDropDownWrapperWidget(
                child: DropdownButtonFormField<UserModel>(
                    decoration: AppDropDownStyles.decoration,
                    style: AppDropDownStyles.style,
                    icon: AppDropDownStyles.icon,
                    isExpanded: AppDropDownStyles.isExpanded,
                    hint: const Text('Select user',
                        style: AppDropDownStyles.hintStyle),
                    value: selectedUser,
                    onChanged: (UserModel? value) => _onChnagedUser(value),
                    items: state.users.isEmpty
                        ? <DropdownMenuItem<UserModel>>[]
                        : state.users
                            .map((UserModel user) =>
                                DropdownMenuItem<UserModel>(
                                    value: user,
                                    child: Text('${user.name} ${user.lastName}',
                                        style: TextStyle(
                                            color: user.endDate != null
                                                ? AppColors.semiGrey
                                                : Colors.white))))
                            .toList())),
            if (selectedType?.logType != LogType.Vacation)
              Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: AppDropDownWrapperWidget(
                      child: DropdownButtonFormField<ProjectModel>(
                          decoration: AppDropDownStyles.decoration,
                          style: AppDropDownStyles.style,
                          icon: AppDropDownStyles.icon,
                          isExpanded: AppDropDownStyles.isExpanded,
                          hint: const Text('Select project',
                              style: AppDropDownStyles.hintStyle),
                          value: selectedProject,
                          onChanged: (ProjectModel? value) =>
                              _onChangedProject(value),
                          items: state.projects.isNotEmpty && state.projects[0].id == null
                              ? <DropdownMenuItem<ProjectModel>>[]
                              : state.projects
                                  .map((ProjectModel project) =>
                                      DropdownMenuItem<ProjectModel>(
                                          value: project,
                                          child: Text(project.name,
                                              style: TextStyle(
                                                  color: project.endDate != null ||
                                                          project.isInternal!
                                                      ? AppColors.semiGrey
                                                      : Colors.white))))
                                  .toList())))
          ],
          buttonSection: AppButtonWidget(
              color: AppColors.green,
              title: 'Apply',
              onClick: () => _apply())));

  void _onChangedVacation(String? value) {
    setState(() {
      // ignore: avoid_function_literals_in_foreach_calls
      types.forEach((FilterType type) {
        if (type.title == AppConstants.Vacation) {
          if (value == AppConstants.NonPaid) {
            type.vacationType = VacationType.VacNonPaid;
          } else {
            type.vacationType = VacationType.VacPaid;
          }
        }
        if (type.title == AppConstants.Sickness) {
          if (value == AppConstants.NonPaid) {
            type.vacationType = VacationType.SickNonPaid;
          } else {
            type.vacationType = VacationType.SickPaid;
          }
        }
      });
      selectedVacationType = value;
    });
  }

  void _onChnagedUser(UserModel? value) {
    store.dispatch(GetLogsFilterProjectsPending(value!.id));
    setState(() {
      selectedUser = value;
    });
  }

  void _onChangedProject(ProjectModel? value) {
    {
      store.dispatch(GetLogsFilterUsersPending(value!.id!));
      setState(() {
        selectedProject = value;
      });
    }
  }

  void _apply() {
    {
      if (selectedType?.logType == LogType.All &&
          selectedUser == null &&
          selectedProject == null) {
        store.dispatch(const PopAction(changeTitle: false, isExternal: true));
        return;
      }
      final LogFilterModel filter =
          LogFilterModel(logType: selectedType, user: selectedUser);
      if (selectedType?.logType != LogType.Vacation) {
        filter.project = selectedProject;
      }
      store.dispatch(
          PopAction(changeTitle: false, params: filter, isExternal: true));
    }
  }

  String _getSelectedVacationType(VacationType vacationType) {
    if (vacationType == VacationType.VacPaid ||
        vacationType == VacationType.SickPaid) {
      return AppConstants.Paid;
    } else {
      return AppConstants.NonPaid;
    }
  }
}
