// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
import 'package:company_id_new/common/helpers/app-refreshers.dart';
import 'package:company_id_new/common/widgets/app-speed-dial/app-speed-dial.widget.dart';
import 'package:company_id_new/screens/statistics/add-edit-timelog/add-edit-timelog.popup.dart';
import 'package:company_id_new/screens/statistics/add-vacation/add-vacation.popup.dart';
import 'package:company_id_new/screens/statistics/calendar/calendar.widget.dart';
import 'package:company_id_new/screens/statistics/filter/filter.popup.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/models/log-filter.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';

class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  Widget build(BuildContext context) => SmartRefresher(
      controller: AppRefreshers.statistic,
      onRefresh: () {
        store.dispatch(
            GetLogsPending('${store.state.currentDate.currentMohth}'));
        store.dispatch(
            GetLogByDatePending('${store.state.currentDate.focusedDay}'));
      },
      enablePullDown: true,
      child: Scaffold(
          floatingActionButton:
              AppSpeedDial(icon: Icons.menu, speedDials: _getSpeedDials()),
          body: CalendarWidget()));

  void _addVacation() {
    if (_isExisted(store.state)) {
      store.dispatch(Notify(
          NotifyModel(NotificationType.Error, 'Only one vacation per day')));
      return;
    }
    showModalBottomSheet<dynamic>(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (BuildContext context) =>
            AddVacationPopup(choosedDate: store.state.currentDate.focusedDay));
  }

  List<SpeedDialChild> _getSpeedDials() {
    final List<SpeedDialChild> speedDials = <SpeedDialChild>[
      AppHelper.speedDialChild(() => _addVacation(),
          const Icon(Icons.snooze, color: AppColors.main2)),
      AppHelper.speedDialChild(() {
        final DateTime now = DateTime.now();
        if (store.state.currentDate.focusedDay.month < now.month) {
          store.dispatch(Notify(NotifyModel(
              NotificationType.Error, 'You can\'t track time on past month')));
          return;
        }
        showModalBottomSheet<dynamic>(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            builder: (BuildContext ontext) => AddEditTimelogDialogPopup(
                choosedDate: store.state.currentDate.focusedDay));
      }, const Icon(Icons.alarm_add, color: AppColors.main2))
    ];
    if (store.state.user!.position == Positions.Owner) {
      speedDials.add(AppHelper.speedDialChild(
          () => _filter(),
          Stack(children: <Widget>[
            Center(
                child: Image.asset(AppImages.filter,
                    width: 24, height: 24, color: AppColors.main2))
          ])));
    }
    return speedDials;
  }

  Future<void> _filter() async {
    final LogFilterModel? filter = await showModalBottomSheet<LogFilterModel>(
        context: context,
        useRootNavigator: true,
        builder: (BuildContext context) => AdminLogFilterPopup());
    if (filter != null) {
      store.dispatch(SaveLogFilter(filter));
    }
    store.dispatch(GetLogsPending('${store.state.currentDate.currentMohth}'));
    store
        .dispatch(GetLogByDatePending('${store.state.currentDate.focusedDay}'));
  }

  bool _isExisted(AppState state) {
    final String authId = state.user!.id;
    return state.logsByDate.any(
        (LogModel log) => log.user?.id == authId && log.vacationType != null);
  }
}
