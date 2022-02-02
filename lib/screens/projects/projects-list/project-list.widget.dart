// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/confirm-dialog/confirm-dialog.widget.dart';
import 'package:company_id_new/common/widgets/project-tile/project-tile.widget.dart';
import 'package:company_id_new/screens/project-details/project-details.screen.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/ui.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/projects-filter.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class _ViewModel {
  _ViewModel(
      {required this.projects,
      required this.isLoading,
      this.filter,
      this.user});
  List<ProjectModel> projects;
  UserModel? user;
  bool isLoading;
  ProjectsFilterModel? filter;
}

class ProjectListWidget extends StatefulWidget {
  @override
  State<ProjectListWidget> createState() => _ProjectListWidgetState();
}

class _ProjectListWidgetState extends State<ProjectListWidget> {
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          projects: store.state.projects,
          isLoading: store.state.isLoading,
          user: store.state.user,
          filter: store.state.projectsFilter),
      onWillChange: (_ViewModel? prev, _ViewModel curr) {
        if (prev!.filter != curr.filter) {
          store.dispatch(GetProjectsPending());
        }
      },
      builder: (BuildContext context, _ViewModel state) =>
          state.isLoading && state.projects.isEmpty || state.user == null
              ? const SizedBox()
              : state.projects.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Center(
                          child: Text('No projects',
                              style: TextStyle(
                                  fontSize: 18, color: AppColors.main))))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.projects.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ProjectModel project = state.projects[index];
                        return ProjectTileWidget(
                            slidableController: _slidableController,
                            onTap: () {
                              store.dispatch(SetTitle(project.name));
                              store.dispatch(PushAction(
                                  ProjectDetailsScreen(projectId: project.id!),
                                  project.name));
                            },
                            project: project,
                            secondaryActions: _buildSceondaryActions(project));
                      }));

  List<Widget> _buildSceondaryActions(ProjectModel project) => <Widget>[
        IconSlideAction(
            color: AppColors.bg,
            iconWidget: IconButton(
                icon: const Icon(Icons.archive),
                color: Colors.white,
                onPressed: () async {
                  final bool? isConfirm = await showDialog<bool>(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          const ConfirmDialogWidget(
                              title: 'Project',
                              text: 'Are you sure to finish the project?'));
                  store.dispatch(SetTitle('Projects'));
                  if (isConfirm != null && !isConfirm) {
                    return;
                  }
                  store.dispatch(ArchiveProjectPending(
                      project.id!, ProjectStatus.Finished));
                })),
        IconSlideAction(
            color: AppColors.bg,
            iconWidget: IconButton(
                icon: const Icon(Icons.cancel),
                color: Colors.white,
                onPressed: () async {
                  final bool? isConfirm = await showDialog<bool>(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) =>
                          const ConfirmDialogWidget(
                              title: 'Project',
                              text: 'Are you sure to reject the project?'));
                  store.dispatch(SetTitle('Projects'));
                  if (isConfirm != null && !isConfirm) {
                    return;
                  }
                  store.dispatch(ArchiveProjectPending(
                      project.id!, ProjectStatus.Rejected));
                }))
      ];
}
