import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/logs.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/models/calendar.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/statistic.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> getLogsEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetLogsPending>().switchMap((GetLogsPending action) =>
        Stream<Map<String, dynamic>>.fromFuture(
                LogService.getLogs(action.date, store.state.filter))
            .expand<dynamic>((Map<String, dynamic> full) => <dynamic>[
                  GetLogsSuccess(
                      full['logs'] as Map<DateTime, List<CalendarModel>>),
                  GetHolidaysLogsSuccess(
                      full['logs'] as Map<DateTime, List<CalendarModel>>),
                  GetStatisticSuccess(full['statistic'] as StatisticModel)
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(GetLogsError());
        }));

Stream<void> getLogByDateEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetLogByDatePending>().switchMap(
        (GetLogByDatePending action) => Stream<LogResponse>.fromFuture(
                    LogService.getLogsByDate(action.date, store.state.filter))
                .expand<dynamic>((LogResponse logResponse) => <dynamic>[
                      GetLogByDateSuccess(logResponse.logs),
                      SetVacationSickAvail(VacationSickAvailable(
                          sickAvailable: logResponse.sickAvailable,
                          vacationAvailable: logResponse.vacationAvailable))
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetLogByDateError());
            }));

Stream<void> addLogEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<AddLogPending>().switchMap((AddLogPending action) =>
        Stream<String>.fromFuture(LogService.addLog(action.log))
            .expand<dynamic>((String id) {
          action.log.id = id;
          return <dynamic>[
            Notify(NotifyModel(
                NotificationType.Success, 'Timelog has been added')),
            AddLogSuccess(action.log),
            GetLogsPending(s.store.state.currentDate.currentMohth.toString()),
          ];
        }).handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(AddLogError());
        }));

Stream<void> editLogEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<EditLogPending>().switchMap((EditLogPending action) =>
        Stream<LogModel>.fromFuture(LogService.editLog(action.log))
            .expand<dynamic>((LogModel log) => <dynamic>[
                  EditLogSuccess(log),
                  GetLogsPending(
                      s.store.state.currentDate.currentMohth.toString()),
                  Notify(NotifyModel(
                      NotificationType.Success, 'Timelog has been edited')),
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(EditLogError());
        }));

Stream<void> deleteLogEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<DeleteLogPending>().switchMap((DeleteLogPending action) =>
        Stream<void>.fromFuture(LogService.deleteLog(action.id))
            .expand<dynamic>((_) => <dynamic>[
                  DeleteLogSuccess(action.id),
                  GetLogsPending(
                      s.store.state.currentDate.currentMohth.toString()),
                  Notify(NotifyModel(
                      NotificationType.Success, 'Timelog has been deleted'))
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(DeleteLogError());
        }));

Stream<void> requestVacationEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<RequestVacationPending>().switchMap(
        (RequestVacationPending action) =>
            Stream<void>.fromFuture(LogService.requestVacation(action.vacation))
                .expand<dynamic>((_) => <dynamic>[
                      RequestVacationSuccess(action.vacation),
                      GetLogsPending(
                          s.store.state.currentDate.currentMohth.toString()),
                      Notify(NotifyModel(
                          NotificationType.Success, 'Request has been added')),
                      PopAction(isExternal: true)
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(RequestVacationError());
            }));

Stream<void> getRequestsEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.where((dynamic action) => action is GetRequestsPending).switchMap(
        (dynamic action) =>
            Stream<List<LogModel>>.fromFuture(LogService.getRequests())
                .map((List<LogModel> requests) => GetRequestsSuccess(requests))
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetRequestsError());
            }));
