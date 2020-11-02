import 'package:company_id_new/common/services/vacations.service.dart';
import 'package:company_id_new/main.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/vacations.action.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/notify.model.dart';

import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> changeStatusVacationEpic(
    Stream<dynamic> actions, EpicStore<dynamic> store) {
  return actions
      .where((dynamic action) => action is ChangeStatusVacationPending)
      .switchMap((dynamic action) => Stream<LogModel>.fromFuture(
                  changeStatusVacation(
                      action.vacationId as String, action.status as String))
              .expand<dynamic>((LogModel vacation) {
            return <dynamic>[
              ChangeStatusVacationSuccess(vacation.id, vacation.status),
              Notify(NotifyModel(NotificationType.success,
                  'Vacation has been ${vacation.status}')),
            ];
          }).onErrorReturnWith((dynamic e) {
            print(e);
            print(e.message);
          }));
}