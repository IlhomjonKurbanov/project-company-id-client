import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-converters.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-helper.dart';
import 'package:company_id_new/screens/statistics/calendar/event-list/event-list.widget.dart';
import 'package:company_id_new/screens/statistics/calendar/event-markers/event-markers.widget.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/badge.model.dart';
import 'package:company_id_new/store/models/calendar.model.dart';
import 'package:company_id_new/store/models/current-day.model.dart';
import 'package:company_id_new/store/models/log-filter.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/statistic.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:table_calendar/table_calendar.dart';

class _ViewModel {
  _ViewModel(
      {this.logs,
      this.statistic,
      required this.currentDate,
      this.filter,
      this.holidays,
      this.user,
      required this.logsByDate});
  Map<DateTime, List<CalendarModel>>? logs;
  Map<DateTime, List<CalendarModel>>? holidays;
  CurrentDateModel currentDate;
  LogFilterModel? filter;
  StatisticModel? statistic;
  List<LogModel> logsByDate;
  UserModel? user;
}

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final DateTime _today = DateTime.now();
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.aspectRatio);
    return StoreConnector<AppState, _ViewModel>(
        converter: (Store<AppState> store) => _ViewModel(
            statistic: store.state.statistic,
            currentDate: store.state.currentDate,
            holidays: store.state.holidays,
            filter: store.state.filter,
            logs: store.state.logs,
            user: store.state.user,
            logsByDate: store.state.logsByDate),
        onWillChange: (_ViewModel? prev, _ViewModel curr) {
          if (prev!.filter != curr.filter) {
            _updateLogs(curr);
          }
        },
        builder: (BuildContext context, _ViewModel state) =>
            AppHelper.isMac(context)
                ? Row(children: _buildCalendar(state))
                : Column(children: _buildCalendar(state)));
  }

  List<Widget> _buildCalendar(_ViewModel state) {
    return <Widget>[
      SizedBox(
          width: AppHelper.isMac(context)
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          child: TableCalendar<dynamic>(
              onPageChanged: _onPageChanged,
              onCalendarCreated: _onCalendarCreated,
              focusedDay: state.currentDate.focusedDay,
              selectedDayPredicate: (DateTime day) =>
                  isSameDay(state.currentDate.focusedDay, day),
              lastDay: DateTime(_today.year + 10, _today.month, _today.day),
              firstDay: DateTime(_today.year - 10, _today.month, _today.day),
              eventLoader: (DateTime day) =>
                  state.logs?[_modifyDate(day)] ?? <dynamic>[],
              holidayPredicate: (DateTime date) {
                List<DateTime> dates = <DateTime>[];
                if (state.holidays != null && state.holidays!.isNotEmpty) {
                  dates = state.holidays!.keys.toList();
                }
                return dates.contains(_modifyDate(date));
              },
              calendarStyle: _getCalendarStyle(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: _getHeaderStyle(state),
              onDaySelected: _onDaySelected,
              calendarBuilders: _getBuilders())),
      Expanded(child: EventListWidget())
    ];
  }

  CalendarStyle _getCalendarStyle() => const CalendarStyle(
      holidayDecoration: BoxDecoration(),
      outsideDaysVisible: false,
      holidayTextStyle: TextStyle(color: AppColors.main),
      todayDecoration:
          BoxDecoration(shape: BoxShape.circle, color: AppColors.secondary),
      selectedTextStyle: TextStyle(fontSize: 16, color: AppColors.main2),
      selectedDecoration:
          BoxDecoration(shape: BoxShape.circle, color: AppColors.main),
      weekendTextStyle: TextStyle(color: AppColors.main));

  HeaderStyle _getHeaderStyle(_ViewModel state) => HeaderStyle(
      titleCentered: true,
      titleTextFormatter: (DateTime date, dynamic local) {
        final String headerSubTitle = state.filter?.user?.id != null &&
                    state.filter?.project == null &&
                    state.filter?.logType?.logType != LogType.Vacation ||
                state.user?.position! == Positions.Developer
            ? '\n ${state.statistic?.workedOut} / ${state.statistic?.toBeWorkedOut} / ${state.statistic?.overtime} '
            : '';
        final String mmYYYY =
            '${AppConverters.monthYearFromDate(date).split(' ')[0]} ${AppConverters.monthYearFromDate(date).split(' ')[1]}';
        return '$mmYYYY $headerSubTitle';
      },
      leftChevronIcon: const Icon(Icons.arrow_back, color: Colors.white),
      rightChevronIcon: const Icon(Icons.arrow_forward, color: Colors.white),
      titleTextStyle: const TextStyle(fontSize: 16),
      formatButtonVisible: false);

  DateTime _modifyDate(DateTime day) {
    final Duration timeZoneOffset =
        DateTime(day.year, day.month, day.day, day.hour).timeZoneOffset;
    DateTime modifiedDay =
        DateTime(day.year, day.month, day.day, day.hour).toUtc();
    return modifiedDay =
        modifiedDay.add(timeZoneOffset + const Duration(hours: 12));
  }

  void _onDaySelected(DateTime day, DateTime b) {
    store.dispatch(SetFocusedDay(day));
    store.dispatch(GetLogByDatePending('$day'));
  }

  void _onPageChanged(DateTime date) {
    store.dispatch(SetCurrentMonth(date));
    store.dispatch(SetFocusedDay(date));
    store.dispatch(GetLogsPending('$date'));
    store.dispatch(GetLogByDatePending('$date'));
  }

  void _onCalendarCreated(PageController controller) {
    store.dispatch(SetCurrentMonth(store.state.currentDate.currentMohth));
    store.dispatch(GetLogsPending('${store.state.currentDate.currentMohth}'));
    store
        .dispatch(GetLogByDatePending('${store.state.currentDate.focusedDay}'));
    store.dispatch(GetUsersPending(true));
  }

  void _updateLogs(_ViewModel state) {
    store.dispatch(GetLogsPending('${state.currentDate.currentMohth}'));
    store.dispatch(GetLogByDatePending('${state.currentDate.focusedDay}'));
  }

  CalendarBuilders<dynamic> _getBuilders() => CalendarBuilders<dynamic>(
        markerBuilder:
            (BuildContext context, DateTime date, List<dynamic> events) {
          final List<BadgeModel> badges = <BadgeModel>[];
          if (events.isNotEmpty) {
            final CalendarModel calendar = events[0] as CalendarModel;
            if (calendar.timelogs != null) {
              badges.add(BadgeModel(AppColors.main, calendar.timelogs));
            }
            if (calendar.vacations != null) {
              badges.add(BadgeModel(AppColors.green, calendar.vacations));
            }
            if (calendar.birthdays != null) {
              badges.add(BadgeModel(AppColors.orange, ''));
            }
            // badges.add(BadgeModel(Colors.blue, ''));
          }
          return Positioned(
            right: 1,
            bottom: 1,
            child: EventMarkersWidget(badges),
          );
        },
      );
}
