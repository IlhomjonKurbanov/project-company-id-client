import 'package:company_id_new/common/services/filter.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> filteredLogUsersEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetLogsFilterUsersPending>().switchMap(
        (GetLogsFilterUsersPending action) =>
            Stream<List<UserModel>>.fromFuture(
                    FilterService.getLogFilteredUsers(action.projectId))
                .map(
                    (List<UserModel> users) => GetLogsFilterUsersSuccess(users))
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetLogsFilterUsersError());
            }));

Stream<void> filteredLogProjectsEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetLogsFilterProjectsPending>().switchMap(
        (GetLogsFilterProjectsPending action) =>
            Stream<List<ProjectModel>>.fromFuture(
                    FilterService.getFilteredProjects(action.userId))
                .map((List<ProjectModel> projects) =>
                    GetLogsFilterProjectsSucess(projects))
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetLogsFilterProjectsError());
            }));

Stream<void> filteredProjectsUsersEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetProjectsFilterUsersPending>().switchMap(
        (GetProjectsFilterUsersPending action) =>
            Stream<List<UserModel>>.fromFuture(
                    FilterService.getProjectsFilteredUsers(action.stackId))
                .map((List<UserModel> users) =>
                    GetProjectsFilterUsersSuccess(users))
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetProjectsFilterUsersError());
            }));

Stream<void> filteredProjectsStackEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetProjectsFilterStackPending>().switchMap(
        (GetProjectsFilterStackPending action) =>
            Stream<List<StackModel>>.fromFuture(
                    FilterService.getProjectsFilteredStack(action.userId))
                .map((List<StackModel> stack) =>
                    GetProjectsFilterStackSuccess(stack))
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetProjectsFilterStackError());
            }));
