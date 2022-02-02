// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-dropdowns.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-validators.dart';
import 'package:company_id_new/common/widgets/app-button/app-button.widget.dart';
import 'package:company_id_new/common/widgets/app-dropdown-wrapper/app-dropdown-wrapper.widget.dart';
import 'package:company_id_new/common/widgets/app-input/app-input.widget.dart';
import 'package:company_id_new/common/wrappers/popup.wrapper.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class _ViewModel {
  _ViewModel(
      {required this.isLoading,
      required this.projects,
      required this.user,
      this.lastProject});
  bool isLoading;
  List<ProjectModel> projects;
  String? lastProject;
  UserModel user;
}

class AddEditTimelogDialogPopup extends StatefulWidget {
  const AddEditTimelogDialogPopup({
    required this.choosedDate,
    this.log,
  });

  final DateTime choosedDate;
  final LogModel? log;

  @override
  _AddEditTimelogDialogPopupState createState() =>
      _AddEditTimelogDialogPopupState();
}

class _AddEditTimelogDialogPopupState extends State<AddEditTimelogDialogPopup> {
  ProjectModel? selectedProject;
  List<ProjectModel> projects = <ProjectModel>[];
  final TextEditingController _descController = TextEditingController(text: '');
  final TextEditingController _hhController = TextEditingController(text: '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _descController.text = widget.log?.desc ?? '';
    _hhController.text = widget.log?.time ?? '';
    store.dispatch(GetProjectsPending(
        projectTypes: ProjectsType.AddTimelog, userId: store.state.user!.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          isLoading: store.state.isLoading,
          user: store.state.user!,
          projects: store.state.timelogProjects,
          lastProject: store.state.lastProject),
      onDidChange: (_ViewModel? state, _ViewModel b) {
        if (widget.log?.project != null) {
          setState(() {
            selectedProject = state!.projects.firstWhereOrNull(
                (ProjectModel project) =>
                    project.name == widget.log?.project?.name);
          });
        } else if (widget.log?.project == null && state!.lastProject != null) {
          setState(() {
            selectedProject = state.projects.firstWhereOrNull(
                (ProjectModel project) => project.name == state.lastProject);
          });
        }
      },
      builder: (BuildContext context, _ViewModel state) => PopupWrapper(
          title: 'Timelog',
          widgets: <Widget>[
            Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      AppDropDownWrapperWidget(
                          child: DropdownButtonFormField<ProjectModel>(
                        decoration: AppDropDownStyles.decoration,
                        style: AppDropDownStyles.style,
                        icon: AppDropDownStyles.icon,
                        validator: (ProjectModel? value) =>
                            AppValidators.validateIsEmptyNull<ProjectModel>(
                                value, 'Please select project'),
                        isExpanded: AppDropDownStyles.isExpanded,
                        hint: const Text('Select project',
                            style: AppDropDownStyles.hintStyle),
                        value: selectedProject,
                        onChanged: (ProjectModel? value) {
                          setState(() {
                            selectedProject = value;
                          });
                        },
                        items: state.projects
                            .map((ProjectModel project) =>
                                DropdownMenuItem<ProjectModel>(
                                    value: project,
                                    child: Text(
                                      project.name,
                                      style: TextStyle(
                                          color: project.isInternal! ||
                                                  project.endDate != null
                                              ? AppColors.semiGrey
                                              : Colors.white),
                                    )))
                            .toList(),
                      )),
                      const SizedBox(height: 16),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateIsEmpty(
                                  value, 'Please enter description'),
                          maxLines: 4,
                          myController: _descController,
                          labelText: 'Description'),
                      const SizedBox(height: 12),
                      AppInput(
                          validator: (String? value) =>
                              AppValidators.validateTiming(
                                  value, 'Enter valid time'),
                          myController: _hhController,
                          labelText: 'hh mm'),
                      const SizedBox(height: 16),
                      const Align(
                          child: Text('Available format is 1h 30m',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)))
                    ])))
          ],
          buttonSection: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AppButtonWidget(
                    color: AppColors.green,
                    onClick: () => _addUpdateTimeLog(state.user),
                    title: 'Add'),
                const SizedBox(width: 12),
                AppButtonWidget(
                    title: 'Cancel',
                    onClick: () => store.dispatch(
                        const PopAction(changeTitle: false, isExternal: true)))
              ])));

  void _addUpdateTimeLog(UserModel user) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    store.dispatch(SetProjectPrefPending(selectedProject!.name));

    widget.log?.id == null
        ? store.dispatch(AddLogPending(LogModel(
            project: selectedProject,
            date: widget.choosedDate,
            time: _hhController.text,
            type: LogType.Timelog,
            user: user,
            desc: _descController.text)))
        : store.dispatch(EditLogPending(LogModel(
            id: widget.log!.id!,
            project: selectedProject,
            date: widget.choosedDate,
            time: _hhController.text,
            type: LogType.Timelog,
            user: user,
            desc: _descController.text)));
  }
}
