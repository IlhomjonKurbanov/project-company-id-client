import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converting.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-list-tile/app-list-tile.widget.dart';
import 'package:company_id_new/common/widgets/app-vacation-tile/app-vacation.tile.widget.dart';
import 'package:company_id_new/common/widgets/avatar/avatar.widget.dart';
import 'package:company_id_new/common/widgets/filter-item/filter-item.widget.dart';
import 'package:company_id_new/screens/project-details/project-details.screen.dart';
import 'package:company_id_new/screens/statistics/add-edit-timelog/add-edit-timelog.popup.dart';
import 'package:company_id_new/screens/user/user.screen.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/current-day.model.dart';
import 'package:company_id_new/store/models/log-filter.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel(
      {this.filter,
      required this.logs,
      required this.currentDate,
      this.authUser,
      this.vacationSickAvailable});
  LogFilterModel? filter;
  CurrentDateModel currentDate;
  List<LogModel> logs;
  VacationSickAvailable? vacationSickAvailable;
  UserModel? authUser;
}

class EventListWidget extends StatefulWidget {
  @override
  _EventListWidgetState createState() => _EventListWidgetState();
}

class _EventListWidgetState extends State<EventListWidget> {
  SlidableController? _slidableController;
  LogModel? holiday;
  @override
  void initState() {
    _slidableController = SlidableController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          authUser: store.state.user,
          filter: store.state.filter,
          currentDate: store.state.currentDate,
          vacationSickAvailable: store.state.vacationSickAvailable,
          logs: store.state.logsByDate),
      builder: (BuildContext context, _ViewModel state) =>
          ListView(children: <Widget>[
            if (state.filter?.user?.id != null ||
                state.authUser?.position == Positions.Developer &&
                    state.vacationSickAvailable != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _buildVacations(state),
              ),
            if (state.filter != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildFilter(state),
              ),
            if (state.logs
                .where((LogModel log) => log.type == LogType.Holiday)
                .toList()
                .isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                    child: Text(
                        state.logs
                            .where(
                                (LogModel log) => log.type == LogType.Holiday)
                            .toList()[0]
                            .name!,
                        style: const TextStyle(
                            fontSize: 24, color: AppColors.main))),
              ),
            if (state.logs
                .where((LogModel log) => log.type == LogType.Birthday)
                .toList()
                .isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Center(
                    child: Text(_getBirthdays(state.logs),
                        style: const TextStyle(
                            fontSize: 18, color: AppColors.orange))),
              ),
            if (state.logs.isEmpty)
              const Center(
                  child: Text('No data',
                      style: TextStyle(fontSize: 18, color: AppColors.main))),
            ...state.logs
                .where((LogModel log) => log.type == LogType.Vacation)
                .map((LogModel log) =>
                    AppVacationTileWidget(log, _slidableController!))
                .toList(),
            ...state.logs
                .where((LogModel log) => log.type == LogType.Timelog)
                .map((LogModel log) => Slidable(
                    controller: _slidableController,
                    enabled: state.authUser?.id == log.user!.id,
                    actionPane: const SlidableDrawerActionPane(),
                    actionExtentRatio: 0.1,
                    secondaryActions: _buildSecondaryActions(log, state),
                    child: AppListTile(
                        leading: state.authUser?.id != log.user!.id ||
                                state.authUser?.position == Positions.Owner
                            ? InkWell(
                                onTap: () => store.dispatch(PushAction(
                                    UserScreen(uid: log.user!.id),
                                    '${log.user!.name} ${log.user!.lastName}')),
                                child: AvatarWidget(
                                    avatar: log.user!.avatar, sizes: 50))
                            : null,
                        textSpan: TextSpan(
                            text: log.project!.name,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                        textSpan2: TextSpan(text: ' - ${log.desc}', style: const TextStyle(color: Colors.white)),
                        onTap: () => store.dispatch(PushAction(ProjectDetailsScreen(projectId: log.project!.id!), log.project!.name)),
                        trailing: Text(log.time!))))
                .toList()
          ]));

  List<IconSlideAction> _buildSecondaryActions(
          LogModel log, _ViewModel state) =>
      <IconSlideAction>[
        IconSlideAction(
            color: AppColors.bg,
            iconWidget: IconButton(
                icon: const Icon(Icons.edit),
                color: Colors.brown,
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                      context: context,
                      isScrollControlled: true,
                      useRootNavigator: true,
                      builder: (BuildContext ontext) =>
                          AddEditTimelogDialogPopup(
                              log: log,
                              choosedDate: state.currentDate.focusedDay));
                  const Icon(Icons.alarm_add);
                  _slidableController!.activeState?.close();
                })),
        IconSlideAction(
            color: AppColors.bg,
            iconWidget: IconButton(
                icon: const Icon(Icons.delete),
                color: AppColors.main,
                onPressed: () {
                  store.dispatch(DeleteLogPending(log.id!));
                  _slidableController!.activeState?.close();
                }))
      ];

  Widget _buildFilter(_ViewModel state) => Wrap(children: <Widget>[
        if (state.filter?.logType?.logType == LogType.Timelog)
          InkWell(
              onTap: () {
                store.dispatch(SaveLogFilter(store.state.filter!
                    .copyWith(logType: FilterType('All', LogType.All))));
              },
              child: FilterItemWidget(
                  title: state.filter!.logType!.title, icon: Icons.history)),
        if (state.filter?.logType?.logType == LogType.Vacation)
          InkWell(
              onTap: () {
                store.dispatch(SaveLogFilter(store.state.filter!
                    .copyWith(logType: FilterType('All', LogType.All))));
              },
              child: FilterItemWidget(
                  title: AppConverting.getVacationTypeString(
                      state.filter!.logType!.vacationType!),
                  icon: Icons.history)),
        if (state.filter?.user?.id != null)
          InkWell(
              onTap: () {
                final LogFilterModel filter = store.state.filter!.copyWith()
                  ..user = null;
                store.dispatch(SaveLogFilter(filter));
              },
              child: FilterItemWidget(
                  title:
                      '${state.filter!.user!.name} ${state.filter!.user!.lastName}',
                  icon: Icons.person)),
        if (state.filter?.project?.id != null)
          InkWell(
              onTap: () {
                final LogFilterModel filter = store.state.filter!.copyWith()
                  ..project = null;
                store.dispatch(SaveLogFilter(filter));
              },
              child: FilterItemWidget(
                  title: state.filter!.project!.name, icon: Icons.desktop_mac))
      ]);

  Widget _buildVacations(_ViewModel state) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  'Vacations available: ${state.vacationSickAvailable!.vacationAvailable} of 18'),
              Text(
                  'Sick available: ${state.vacationSickAvailable!.sickAvailable} of 5'),
            ]),
      );

  String _getBirthdays(List<LogModel> logs) {
    final List<LogModel> birthdays =
        logs.where((LogModel log) => log.type == LogType.Birthday).toList();
    String result = birthdays.length > 1 ? 'Birthdays: ' : 'Birthday: ';
    for (final LogModel log in birthdays) {
      result += '${log.fullName}, ';
    }
    result = result.substring(0, result.length - 2);
    return birthdays.isEmpty ? '' : result;
  }
}
