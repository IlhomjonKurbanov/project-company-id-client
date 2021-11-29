import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-converting.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
import 'package:company_id_new/common/helpers/app-refreshers.dart';
import 'package:company_id_new/common/widgets/app-speed-dial/app-speed-dial.widget.dart';
import 'package:company_id_new/common/widgets/project-tile/project-tile.widget.dart';
import 'package:company_id_new/screens/project-details/project-details.screen.dart';
import 'package:company_id_new/screens/user/add-project/add-project.popup.dart';
import 'package:company_id_new/screens/user/eval-salary/eval-salary.popup.dart';
import 'package:company_id_new/screens/user/socials-rows/social-row-icon/social-row-icon.widget.dart';
import 'package:company_id_new/screens/user/socials-rows/social-row.widget.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({this.user, this.authUser});
  UserModel? user;
  UserModel? authUser;
}

class UserScreen extends StatefulWidget {
  const UserScreen({required this.uid});
  final String uid;

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final SlidableController _slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    final double tileWidth = MediaQuery.of(context).size.width / 2 - 18;
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel(
            user: store.state.currentUser, authUser: store.state.user),
        onInit: (Store<AppState> store) {
          store.dispatch(GetUserPending(widget.uid));
        },
        builder: (BuildContext context, _ViewModel state) {
          if (state.authUser == null) {
            return const SizedBox();
          }
          final bool show = state.authUser?.position == Positions.Owner ||
              state.authUser?.id == state.user?.id;
          return Scaffold(
              floatingActionButton: state.authUser!.position == Positions.Owner
                  ? AppSpeedDial(icon: Icons.menu, speedDials: _getSpeedDials())
                  : const SizedBox(),
              body: state.user == null
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: SmartRefresher(
                          controller: AppRefreshers.user,
                          onRefresh: () =>
                              store.dispatch(GetUserPending(widget.uid)),
                          enablePullDown: true,
                          child: ListView(children: <Widget>[
                            const SizedBox(height: 16),
                            const Text('Personal details',
                                style: TextStyle(
                                    color: AppColors.lightGrey, fontSize: 16)),
                            const SizedBox(height: 8),
                            Wrap(spacing: 12, runSpacing: 8, children: <Widget>[
                              if (state.user?.date != null)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.cake,
                                    title: DateFormat('dd/MM/yyyy')
                                        .format(state.user!.date!)),
                            ]),
                            const SizedBox(height: 16),
                            const Text('Work details',
                                style: TextStyle(
                                    color: AppColors.lightGrey, fontSize: 16)),
                            const SizedBox(height: 8),
                            Wrap(spacing: 12, runSpacing: 8, children: <Widget>[
                              if (state.user?.startDate != null)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.calendar_today,
                                    title: DateFormat('dd/MM/yyyy')
                                        .format(state.user!.startDate!)),
                              if (state.user?.startDate != null)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.date_range,
                                    title: AppConverters.countYearMonth(
                                        state.user!.startDate!)),
                              if (show)
                                SocialRowIconWidget(
                                    icon: Icons.pool,
                                    fullWidth: tileWidth,
                                    title:
                                        '${state.user!.vacationAvailable}/${state.user!.vacationCount}'),
                              if (show)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.local_hospital,
                                    title: '${state.user!.sickAvailable}/5'),
                              if (state.user?.evaluationDate != null && show)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.date_range,
                                    title: DateFormat('dd/MM/yyyy')
                                        .format(state.user!.evaluationDate!)),
                              if (state.user?.salary != null && show)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.price_check,
                                    title:
                                        '${state.user!.salary.toString()} \$'),
                              SocialRowIconWidget(
                                  fullWidth: tileWidth,
                                  icon: Icons.supervised_user_circle,
                                  title: AppConverting.getPositionFromString(
                                      state.user!.position)),
                              if (state.user?.englishLevel != null)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    icon: Icons.language,
                                    title: state.user!.englishLevel!)
                            ]),
                            const SizedBox(height: 16),
                            const Text('Contacts',
                                style: TextStyle(
                                    color: AppColors.lightGrey, fontSize: 16)),
                            const SizedBox(height: 8),
                            Wrap(spacing: 12, runSpacing: 8, children: <Widget>[
                              if (state.user?.github != null)
                                SocialRowWidget(
                                    fullWidth: tileWidth,
                                    url:
                                        'https://github.com/${state.user!.github}',
                                    iconName: AppImages.github,
                                    title: state.user!.github!),
                              if (state.user?.slack != null)
                                SocialRowWidget(
                                    url:
                                        '${AppConstants.slackUrl}/${state.user!.slack}',
                                    fullWidth: tileWidth,
                                    iconName: AppImages.slack,
                                    title: state.user!.lastName),
                              if (state.user?.skype != null)
                                SocialRowWidget(
                                    fullWidth: tileWidth,
                                    url: 'skype:${state.user!.skype}',
                                    iconName: AppImages.skype,
                                    title: state.user!.skype!),
                              if (state.user?.email != null)
                                SocialRowIconWidget(
                                    fullWidth: tileWidth,
                                    url: 'mailto:${state.user!.email}',
                                    icon: Icons.email,
                                    title: state.user!.email!),
                              if (state.user?.phone != null)
                                SocialRowIconWidget(
                                    url: 'tel:${state.user!.phone}',
                                    fullWidth: tileWidth,
                                    icon: Icons.phone,
                                    title: state.user!.phone!),
                            ]),
                            const SizedBox(height: 16),
                            ..._buildProjects(
                                state.user!,
                                state.user!.activeProjects,
                                state.authUser!.position!,
                                true),
                            ..._buildProjects(state.user!, state.user!.projects,
                                state.authUser!.position!, false)
                          ]))));
        });
  }

  List<SpeedDialChild> _getSpeedDials() => <SpeedDialChild>[
        AppHelper.speedDialChild(
            () => showModalBottomSheet<dynamic>(
                context: context,
                useRootNavigator: true,
                builder: (BuildContext context) => AddProjectPopup()),
            const Icon(Icons.add)),
        AppHelper.speedDialChild(
            () => showModalBottomSheet<dynamic>(
                context: context,
                useRootNavigator: true,
                builder: (BuildContext context) => EvalSalaryPopup()),
            const Icon(Icons.edit))
      ];

  List<Widget> _buildProjects(UserModel user, List<ProjectModel>? projects,
          Positions position, bool isActive) =>
      projects != null && projects.isNotEmpty
          ? <Widget>[
              const SizedBox(height: 16),
              Text(isActive ? 'Active projects' : 'Projects',
                  style: const TextStyle(
                      color: AppColors.lightGrey, fontSize: 18)),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: projects.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ProjectModel project = projects[index];
                    return ProjectTileWidget(
                        slidableController: _slidableController,
                        onTap: () {
                          store.dispatch(PushAction(
                              ProjectDetailsScreen(projectId: project.id!),
                              project.name));
                        },
                        project: project,
                        secondaryActions: <Widget>[
                          IconSlideAction(
                              color: AppColors.bg,
                              icon: isActive ? Icons.history : Icons.person_add,
                              onTap: () =>
                                  _onActionClick(isActive, project, user))
                        ]);
                  })
            ]
          : <Widget>[];

  void _onActionClick(bool isActive, ProjectModel project, UserModel user) {
    if (isActive) {
      store.dispatch(RemoveProjectFromUserPending(widget.uid, project));
    } else {
      final bool isUserOnBoard = user.activeProjects?.any(
              (ProjectModel selectedProject) =>
                  selectedProject.id == project.id) ??
          false;
      if (isUserOnBoard) {
        store.dispatch(Notify(NotifyModel(NotificationType.Error,
            'This project is already in the active projects')));
      } else {
        store.dispatch(AddUserToProjectPending(user, project, true,
            isAddedUserToProject: false));
      }
    }
  }
}
