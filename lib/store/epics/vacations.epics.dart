// Package imports:
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/vacations.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/vacations.action.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;

Stream<void> changeStatusVacationEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<ChangeStatusVacationPending>().switchMap(
        (ChangeStatusVacationPending action) => Stream<LogModel>.fromFuture(
                    VacationsService.changeStatusVacation(
                        action.vacationId, action.status))
                .expand<dynamic>((LogModel vacation) => <dynamic>[
                      ChangeStatusVacationSuccess(
                          vacation.id!, vacation.status!),
                      Notify(NotifyModel(
                          NotificationType.Success,
                          action.status == RequestStatus.Approved
                              ? 'Vacation has been approved'
                              : 'Vacation has been rejected')),
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(ChangeStatusVacationError());
            }));
