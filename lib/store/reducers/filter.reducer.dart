// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/models/filter-users-projects-logs.model.dart';
import 'package:company_id_new/store/models/log-filter.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';

final Reducer<LogFilterModel?> filterReducers = combineReducers<
    LogFilterModel?>(<LogFilterModel? Function(LogFilterModel?, dynamic)>[
  TypedReducer<LogFilterModel?, SaveLogFilter>(_saveLogFilter),
  TypedReducer<LogFilterModel?, ClearLogFilter>(_clearLogFilter),
]);

LogFilterModel? _saveLogFilter(LogFilterModel? title, SaveLogFilter action) =>
    action.adminFilter;

LogFilterModel? _clearLogFilter(LogFilterModel? state, ClearLogFilter action) =>
    null;

final Reducer<FilterLogsUsersProjects> filterLogsUserProjectsFilterReducers =
    combineReducers<FilterLogsUsersProjects>(<
        FilterLogsUsersProjects Function(FilterLogsUsersProjects, dynamic)>[
  TypedReducer<FilterLogsUsersProjects, GetLogsFilterProjectsSucess>(
      _saveLogsProjectsFilter),
  TypedReducer<FilterLogsUsersProjects, GetLogsFilterUsersSuccess>(
      _saveLogsUserFilter),
  TypedReducer<FilterLogsUsersProjects, ClearLogFilterLogsUsersProjects>(
      _clearLogsProjectsFilter),
]);

FilterLogsUsersProjects _saveLogsProjectsFilter(
        FilterLogsUsersProjects state, GetLogsFilterProjectsSucess action) =>
    state.copyWith(projects: action.projects);

FilterLogsUsersProjects _clearLogsProjectsFilter(FilterLogsUsersProjects state,
        ClearLogFilterLogsUsersProjects action) =>
    FilterLogsUsersProjects(projects: <ProjectModel>[], users: <UserModel>[]);

FilterLogsUsersProjects _saveLogsUserFilter(
        FilterLogsUsersProjects state, GetLogsFilterUsersSuccess action) =>
    state.copyWith(users: action.users);
