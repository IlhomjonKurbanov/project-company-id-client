// Package imports:
import 'package:collection/collection.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/vacations.action.dart';
import 'package:company_id_new/store/models/calendar.model.dart';
import 'package:company_id_new/store/models/current-day.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/statistic.model.dart';

final Reducer<Map<DateTime, List<CalendarModel>>?> logsReducer =
    combineReducers<Map<DateTime, List<CalendarModel>>?>(<
        Map<DateTime, List<CalendarModel>>? Function(
            Map<DateTime, List<CalendarModel>>?, dynamic)>[
  TypedReducer<Map<DateTime, List<CalendarModel>>?, GetLogsSuccess>(_saveLogs),
]);

Map<DateTime, List<CalendarModel>>? _saveLogs(
        Map<DateTime, List<CalendarModel>>? logs, GetLogsSuccess action) =>
    action.logs;

final Reducer<StatisticModel?> statisticReducers = combineReducers<
    StatisticModel?>(<StatisticModel? Function(StatisticModel?, dynamic)>[
  TypedReducer<StatisticModel?, GetStatisticSuccess>(_saveStatistic)
]);

StatisticModel? _saveStatistic(
        StatisticModel? logs, GetStatisticSuccess action) =>
    action.statistic;

final Reducer<VacationSickAvailable?> vacacationSickReducers =
    combineReducers<VacationSickAvailable?>(<
        VacationSickAvailable? Function(VacationSickAvailable?, dynamic)>[
  TypedReducer<VacationSickAvailable?, SetVacationSickAvail>(
      _saveVacationSickAvail)
]);

VacationSickAvailable? _saveVacationSickAvail(
        VacationSickAvailable? state, SetVacationSickAvail action) =>
    action.vacationSickAvailable;

final Reducer<List<LogModel>> logsbyDateReducers = combineReducers<
    List<LogModel>>(<List<LogModel> Function(List<LogModel>, dynamic)>[
  TypedReducer<List<LogModel>, GetLogByDateSuccess>(_saveLogsByDate),
  TypedReducer<List<LogModel>, AddLogSuccess>(_saveLogByDate),
  TypedReducer<List<LogModel>, EditLogSuccess>(_editLogByDate),
  TypedReducer<List<LogModel>, DeleteLogSuccess>(_deleteLogByDate),
  TypedReducer<List<LogModel>, RequestVacationSuccess>(_addRequest),
  TypedReducer<List<LogModel>, ChangeStatusVacationSuccess>(
      _changeVacationStatus),
]);

List<LogModel> _saveLogsByDate(
        List<LogModel> logs, GetLogByDateSuccess action) =>
    action.logs;

List<LogModel> _addRequest(
        List<LogModel> logs, RequestVacationSuccess action) =>
    <LogModel>[action.vacation, ...logs];

List<LogModel> _saveLogByDate(List<LogModel> logs, AddLogSuccess action) =>
    <LogModel>[action.log, ...logs];

List<LogModel> _editLogByDate(List<LogModel> logs, EditLogSuccess action) {
  final List<LogModel> newLogs = <LogModel>[...logs];
  newLogs.removeWhere((LogModel log) => log.id == action.log.id);
  return <LogModel>[action.log, ...newLogs];
}

List<LogModel> _changeVacationStatus(
    List<LogModel> logs, ChangeStatusVacationSuccess action) {
  final List<LogModel> newLogs = <LogModel>[...logs];
  final int index =
      newLogs.indexWhere((LogModel log) => log.id == action.vacationId);
  if (index != -1) {
    newLogs[index].status = action.status;
  }
  return newLogs;
}

List<LogModel> _deleteLogByDate(List<LogModel> logs, DeleteLogSuccess action) {
  final List<LogModel> newLogs = <LogModel>[...logs];
  newLogs.removeWhere((LogModel log) => log.id == action.id);
  return newLogs;
}

final Reducer<Map<DateTime, List<CalendarModel>>?> holidaysReducers =
    combineReducers<Map<DateTime, List<CalendarModel>>?>(<
        Map<DateTime, List<CalendarModel>>? Function(
            Map<DateTime, List<CalendarModel>>?, dynamic)>[
  TypedReducer<Map<DateTime, List<CalendarModel>>?, GetHolidaysLogsSuccess>(
      _saveHolidays),
]);

Map<DateTime, List<CalendarModel>>? _saveHolidays(
    Map<DateTime, List<CalendarModel>>? holidays,
    GetHolidaysLogsSuccess action) {
  final Map<DateTime, List<CalendarModel>>? newHolidays =
      <DateTime, List<CalendarModel>>{};
  for (final MapEntry<DateTime, List<CalendarModel>> log
      in action.holidays.entries) {
    if (log.value
            .firstWhereOrNull((CalendarModel log) => log.holiday != null) !=
        null) {
      newHolidays!.addAll(<DateTime, List<CalendarModel>>{log.key: log.value});
    }
  }
  return newHolidays;
}

final Reducer<CurrentDateModel> currentDateReducers = combineReducers<
    CurrentDateModel>(<CurrentDateModel Function(CurrentDateModel, dynamic)>[
  TypedReducer<CurrentDateModel, SetFocusedDay>(_setFocused),
  TypedReducer<CurrentDateModel, SetCurrentMonth>(_setMonth)
]);

CurrentDateModel _setFocused(CurrentDateModel state, SetFocusedDay action) =>
    state.copyWith(focusedDay: action.focusedDay);

CurrentDateModel _setMonth(CurrentDateModel state, SetCurrentMonth action) =>
    state.copyWith(currentMohth: action.currentMonth);
