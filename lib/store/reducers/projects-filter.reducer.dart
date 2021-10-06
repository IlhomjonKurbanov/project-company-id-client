import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/models/filter-projects-users-stack.model.dart';
import 'package:company_id_new/store/models/projects-filter.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:redux/redux.dart';

final Reducer<ProjectsFilterModel?> projectFilterReducers =
    combineReducers<ProjectsFilterModel?>(<
        ProjectsFilterModel? Function(ProjectsFilterModel?, dynamic)>[
  TypedReducer<ProjectsFilterModel?, SaveProjectsFilter>(_saveProjectsFilter),
  TypedReducer<ProjectsFilterModel?, ClearProjectsFilter>(_clearLogFilter),
]);

ProjectsFilterModel? _saveProjectsFilter(
        ProjectsFilterModel? title, SaveProjectsFilter action) =>
    action.filter;

ProjectsFilterModel? _clearLogFilter(
        ProjectsFilterModel? state, ClearProjectsFilter action) =>
    null;

final Reducer<FilterProjectsUsersStack> filterProjectsUsersStackReducers =
    combineReducers<FilterProjectsUsersStack>(<
        FilterProjectsUsersStack Function(FilterProjectsUsersStack, dynamic)>[
  TypedReducer<FilterProjectsUsersStack, GetProjectsFilterStackSuccess>(
      _saveProjectsProjectsFilter),
  TypedReducer<FilterProjectsUsersStack, GetProjectsFilterUsersSuccess>(
      _saveProjectsUserFilter),
  TypedReducer<FilterProjectsUsersStack, ClearProjectsFilterLogsUsersStack>(
      _clearProjectsProjectsFilter),
]);

FilterProjectsUsersStack _saveProjectsProjectsFilter(
        FilterProjectsUsersStack state, GetProjectsFilterStackSuccess action) =>
    state.copyWith(stack: action.stack);

FilterProjectsUsersStack _saveProjectsUserFilter(
        FilterProjectsUsersStack state, GetProjectsFilterUsersSuccess action) =>
    state.copyWith(users: action.users);

FilterProjectsUsersStack _clearProjectsProjectsFilter(
        FilterProjectsUsersStack state,
        ClearProjectsFilterLogsUsersStack action) =>
    FilterProjectsUsersStack(users: <UserModel>[], stack: <StackModel>[]);
