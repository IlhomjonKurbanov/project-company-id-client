// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/vacations.action.dart';
import 'package:company_id_new/store/models/log.model.dart';

final Reducer<List<LogModel>> requestsReducer = combineReducers<
    List<LogModel>>(<List<LogModel> Function(List<LogModel>, dynamic)>[
  TypedReducer<List<LogModel>, GetRequestsSuccess>(_getRequests),
  TypedReducer<List<LogModel>, ChangeStatusVacationSuccess>(
      _changeVacationStatus),
  TypedReducer<List<LogModel>, RequestVacationSuccess>(_addRequest),
]);
List<LogModel> _getRequests(
        List<LogModel> requests, GetRequestsSuccess action) =>
    action.requests;

List<LogModel> _changeVacationStatus(
    List<LogModel> requests, ChangeStatusVacationSuccess action) {
  List<LogModel> newRequests = <LogModel>[...requests];
  newRequests = newRequests
      .where((LogModel request) => request.id != action.vacationId)
      .toList();
  return newRequests;
}

List<LogModel> _addRequest(
        List<LogModel> requests, RequestVacationSuccess action) =>
    <LogModel>[action.vacation, ...requests];
