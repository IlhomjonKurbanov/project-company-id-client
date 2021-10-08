import 'package:collection/collection.dart';
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-refreshers.dart';
import 'package:company_id_new/common/widgets/stack/stack.widget.dart';
import 'package:company_id_new/common/widgets/user-tile/user-tile.widget.dart';
import 'package:company_id_new/screens/project-details/add-user/add-user.popup.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({this.project, this.user, required this.isLoading});
  ProjectModel? project;
  UserModel? user;
  bool isLoading;
}

class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({required this.projectId});
  final String projectId;

  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          project: store.state.project,
          user: store.state.user,
          isLoading: store.state.isLoading),
      onInit: (Store<AppState> store) {
        if (store.state.project != null &&
            store.state.project!.id == widget.projectId) {
          return;
        }
        store.dispatch(ClearDetailProject());
        store.dispatch(GetDetailProjectPending(widget.projectId));
      },
      builder: (BuildContext context, _ViewModel state) {
        if (state.user == null) {
          return const SizedBox();
        }
        return Scaffold(
            floatingActionButton: state.user!.position == Positions.Owner &&
                    state.project?.endDate == null
                ? FloatingActionButton(
                    foregroundColor: AppColors.main2,
                    child: const Icon(Icons.add),
                    onPressed: () {
                      showModalBottomSheet<dynamic>(
                          context: context,
                          useRootNavigator: true,
                          builder: (BuildContext context) => AddUserPopup());
                    })
                : const SizedBox(),
            body: state.isLoading && state.project == null
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 24),
                    child: SmartRefresher(
                        controller: AppRefreshers.projectdetails,
                        onRefresh: () {
                          store.dispatch(ClearDetailProject());
                          store.dispatch(
                              GetDetailProjectPending(widget.projectId));
                        },
                        enablePullDown: true,
                        child: ListView(children: <Widget>[
                          Text('General info',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18)),
                          const SizedBox(height: 12),
                          _buildProjectInfoTile(
                              'Industry: ', state.project?.industry),
                          state.project?.startDate != null
                              ? _buildProjectInfoTile(
                                  'Duration: ',
                                  _getDuration(state.project!.startDate!,
                                      state.project?.endDate))
                              : const SizedBox(),
                          _buildProjectInfoTile(
                              'Customer: ', state.project?.customer),
                          const SizedBox(height: 12),
                          Text('Stack',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18)),
                          const SizedBox(height: 12),
                          if (state.project?.stack != null &&
                              state.project!.stack!.isNotEmpty)
                            _buildStack(state.project!.stack!),
                          const SizedBox(height: 12),
                          Text('Onboard',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18)),
                          const SizedBox(height: 12),
                          if (state.project?.onboard != null &&
                              state.project!.onboard!.isNotEmpty)
                            _buildUsersList(
                                state.project!,
                                state.project!.onboard!,
                                state.user!.position!,
                                true),
                          const SizedBox(height: 12),
                          Text('History',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18)),
                          const SizedBox(height: 12),
                          if (state.project?.history != null &&
                              state.project!.history!.isNotEmpty)
                            _buildUsersList(
                                state.project!,
                                state.project!.history!,
                                state.user!.position!,
                                false)
                        ]))));
      });

  String _getDuration(DateTime start, DateTime? end) {
    final String startDate = AppConverters.dateFromString((start).toString());
    final String endDate =
        end != null ? AppConverters.dateFromString((end).toString()) : 'now';
    return '$startDate - $endDate';
  }

  Widget _buildStack(List<StackModel> stack) => Wrap(
      children: stack
          .map((StackModel stack) => StackWidget(title: stack.name))
          .toList());

  Widget _buildUsersList(ProjectModel project, List<UserModel> users,
          Positions position, bool isOnboard) =>
      Column(
          children: users
              .map((UserModel user) => UserTileWidget(
                      user: user,
                      authPosition: position,
                      slidableController: _slidableController,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            color: AppColors.bg,
                            icon: isOnboard ? Icons.history : Icons.person_add,
                            onTap: () {
                              if (!isOnboard) {
                                final bool isUserOnboard = project.onboard!.any(
                                    (UserModel userOnBoard) =>
                                        userOnBoard.id ==
                                        project.history!
                                            .firstWhereOrNull(
                                                (UserModel userHis) =>
                                                    userHis.id == user.id)
                                            ?.id);
                                if (!isUserOnboard) {
                                  store.dispatch(AddUserToProjectPending(
                                      user, store.state.project!, true));
                                } else {
                                  store.dispatch(Notify(NotifyModel(
                                      NotificationType.Error,
                                      'This user is already on the project')));
                                }
                              } else {
                                store.dispatch(RemoveUserFromProjectPending(
                                    user, store.state.project!.id!));
                              }
                            })
                      ]))
              .toList());

  Widget _buildProjectInfoTile(String title, String? desc) => RichText(
          text: TextSpan(
              text: title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              children: <TextSpan>[
            TextSpan(
                text: desc ?? '',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white))
          ]));
}
