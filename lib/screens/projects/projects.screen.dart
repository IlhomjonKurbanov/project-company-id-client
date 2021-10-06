import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/common/widgets/app-speed-dial/app-speed-dial.widget.dart';
import 'package:company_id_new/common/widgets/filter-item/filter-item.widget.dart';
import 'package:company_id_new/screens/create-project/create-project.screen.dart';
import 'package:company_id_new/screens/projects/filter/filter.popup.dart';
import 'package:company_id_new/screens/projects/projects-list/project-list.widget.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/project-spec.model.dart';
import 'package:company_id_new/store/models/project-status.model.dart';
import 'package:company_id_new/store/models/projects-filter.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:redux/redux.dart';

class ProjectsScreen extends StatefulWidget {
  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  @override
  void initState() {
    super.initState();
    if (store.state.projects.isNotEmpty) {
      return;
    }
    store.dispatch(GetProjectsPending());
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState,
          ProjectsFilterModel?>(
      converter: (Store<AppState> store) => store.state.projectsFilter,
      onWillChange: (ProjectsFilterModel? prev, ProjectsFilterModel? curr) {
        if (prev != curr) {
          store.dispatch(GetProjectsPending());
        }
      },
      builder: (BuildContext context, ProjectsFilterModel? filter) => Scaffold(
          floatingActionButton: store.state.user!.position == Positions.Owner
              ? AppSpeedDial(icon: Icons.menu, speedDials: _getSpeedDials())
              : AppSpeedDial(
                  icon: Icons.search,
                  onPress: () => showModalBottomSheet<dynamic>(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      builder: (BuildContext context) =>
                          FilterProjectsPopup())),
          body: SmartRefresher(
              controller: RefreshController(initialRefresh: false),
              onRefresh: () => store.dispatch(GetProjectsPending()),
              enablePullDown: true,
              child: ListView(children: <Widget>[
                if (filter != null)
                  Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(children: <Widget>[
                        if (filter.user?.id != null)
                          InkWell(
                              onTap: () {
                                final ProjectsFilterModel projectsFilterModel =
                                    filter.copyWith()..user = null;
                                store.dispatch(
                                    SaveProjectsFilter(projectsFilterModel));
                              },
                              child: FilterItemWidget(
                                  title:
                                      '${filter.user!.name} ${filter.user!.lastName}',
                                  icon: Icons.person)),
                        if (filter.stack?.id != null)
                          InkWell(
                              onTap: () {
                                final ProjectsFilterModel projectsFilterModel =
                                    filter.copyWith()..stack = null;
                                store.dispatch(
                                    SaveProjectsFilter(projectsFilterModel));
                              },
                              child: FilterItemWidget(
                                  title: filter.stack!.name, icon: Icons.menu)),
                        if (filter.spec?.title != null &&
                            filter.spec!.spec != ProjectSpec.All)
                          InkWell(
                              onTap: () {
                                store.dispatch(SaveProjectsFilter(
                                    filter.copyWith(
                                        spec: ProjectSpecModel(AppConstants.All,
                                            ProjectSpec.All))));
                              },
                              child: FilterItemWidget(
                                  title: filter.spec!.title, icon: Icons.menu)),
                        if (filter.status?.title != null &&
                            filter.status!.status != ProjectStatus.All)
                          InkWell(
                              onTap: () {
                                store.dispatch(SaveProjectsFilter(
                                    filter.copyWith(
                                        status: ProjectStatusModel(
                                            AppConstants.All,
                                            ProjectStatus.All))));
                              },
                              child: FilterItemWidget(
                                  title: filter.status!.title,
                                  icon: Icons.menu))
                      ])),
                ProjectListWidget()
              ]))));

  List<SpeedDialChild> _getSpeedDials() => <SpeedDialChild>[
        AppHelper.speedDialChild(
            () => showModalBottomSheet<dynamic>(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                builder: (BuildContext context) => FilterProjectsPopup()),
            const Icon(Icons.search)),
        AppHelper.speedDialChild(
            () => store
                .dispatch(PushAction(CreateProjectScreen(), 'Create project')),
            const Icon(Icons.add))
      ];
}
