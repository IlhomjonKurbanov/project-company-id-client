import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/helpers/app-refreshers.dart';
import 'package:company_id_new/common/services/users.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> usersEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetUsersPending>().switchMap<dynamic>(
        (GetUsersPending action) =>
            Stream<List<UserModel>>.fromFuture(UsersService.getUsers(action))
                .map<dynamic>((List<UserModel> users) {
              AppRefreshers.users.refreshCompleted();
              switch (action.usersType) {
                case UsersType.CreateProject:
                  return GetUsersForCreatingProjectSuccess(users);
                case UsersType.Default:
                  return GetUsersSuccess(users);
                case UsersType.ProjectFilter:
                  return GetProjectsFilterUsersSuccess(users);
                case UsersType.Filter:
                  return GetLogsFilterUsersSuccess(users,
                      usersType: action.usersType);
                case UsersType.Absent:
                  return GetAbsentUsersSuccess(users);
                default:
                  return null;
              }
            }).handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetUsersError());
            }));

Stream<void> userEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetUserPending>().switchMap((GetUserPending action) =>
        Stream<UserModel>.fromFuture(UsersService.getUser(action.id))
            .map((UserModel user) {
          AppRefreshers.user.refreshCompleted();
          return GetUserSuccess(user);
        }).handleError((dynamic e) {
          AppRefreshers.user.refreshCompleted();
          s.store.dispatch(SetError(e));
          s.store.dispatch(GetUserError());
        }));

Stream<void> changeEvalationEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<ChangeEvaluationDatePending>().switchMap(
        (ChangeEvaluationDatePending action) => Stream<void>.fromFuture(
                    UsersService.changeEvaluationDate(
                        action.id, action.date, action.salary))
                .expand<dynamic>((_) {
              return <dynamic>[
                ChangeEvaluationDateSuccess(action.date, action.salary),
                Notify(NotifyModel(NotificationType.Success,
                    'Evaluation and salary has been changed')),
                const PopAction(isExternal: true)
              ];
            }).handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(ChangeEvaluationDateError());
            }));

Stream<void> archiveUserEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<ArchiveUserPending>().switchMap(
        (ArchiveUserPending action) =>
            Stream<DateTime>.fromFuture(UsersService.archiveUser(action.id))
                .expand<dynamic>((DateTime dateTime) => <dynamic>[
                      Notify(NotifyModel(
                          NotificationType.Success, 'User has been archived')),
                      ArchiveUserSuccess(action.id, dateTime)
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(ArchiveUserError());
            }));

Stream<void> removeProjectFromUserEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<RemoveProjectFromUserPending>().switchMap(
        (RemoveProjectFromUserPending action) => Stream<void>.fromFuture(
                    UsersService.removeActiveProjectFromUser(
                        action.project, action.userId))
                .expand<dynamic>((_) => <dynamic>[
                      RemoveProjectFromUserSuccess(action.project),
                      Notify(NotifyModel(NotificationType.Success,
                          'Project has been removed from the active projects')),
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(RemoveProjectFromUserError());
            }));
