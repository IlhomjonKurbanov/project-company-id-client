import 'package:company_id_new/store/models/calendar.model.dart';
import 'package:company_id_new/store/models/current-day.model.dart';
import 'package:company_id_new/store/models/filter-projects-users-stack.model.dart';
import 'package:company_id_new/store/models/filter-users-projects-logs.model.dart';
import 'package:company_id_new/store/models/log-filter.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/projects-filter.model.dart';
import 'package:company_id_new/store/models/rules.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/statistic.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/auth.reducer.dart';
import 'package:company_id_new/store/reducers/filter.reducer.dart';
import 'package:company_id_new/store/reducers/loading.reducer.dart';
import 'package:company_id_new/store/reducers/logs.reducer.dart';
import 'package:company_id_new/store/reducers/notify.reducer.dart';
import 'package:company_id_new/store/reducers/projects-filter.reducer.dart';
import 'package:company_id_new/store/reducers/projects.reducer.dart';
import 'package:company_id_new/store/reducers/requests.reducer.dart';
import 'package:company_id_new/store/reducers/rules.reducer.dart';
import 'package:company_id_new/store/reducers/stack.reducer.dart';
import 'package:company_id_new/store/reducers/ui.reducer.dart';
import 'package:company_id_new/store/reducers/users.reducer.dart';
import 'projects.reducer.dart';

class AppState {
  AppState(
      {required this.isLoading,
      this.notify,
      required this.users,
      required this.titles,
      this.user,
      this.filter,
      this.holidays,
      this.logs,
      required this.logsByDate,
      required this.projects,
      this.project,
      this.currentUser,
      this.lastProject,
      required this.absentUsers,
      required this.absentProjects,
      required this.currentDate,
      this.vacationSickAvailable,
      required this.filterLogsUsersProjects,
      required this.filterProjectsUsersStack,
      this.statistic,
      required this.rules,
      required this.stack,
      required this.usersForCreatingProject,
      required this.timelogProjects,
      required this.requests,
      this.projectsFilter});

  bool isLoading;
  String? lastProject;
  List<String> titles;
  List<ProjectModel> projects;
  ProjectModel? project;
  UserModel? user;
  NotifyModel? notify;
  List<LogModel> logsByDate;
  UserModel? currentUser;
  List<ProjectModel> timelogProjects;
  StatisticModel? statistic;
  LogFilterModel? filter;
  ProjectsFilterModel? projectsFilter;
  List<UserModel> users;
  FilterLogsUsersProjects filterLogsUsersProjects;
  FilterProjectsUsersStack filterProjectsUsersStack;
  CurrentDateModel currentDate;
  List<UserModel> absentUsers;
  List<ProjectModel> absentProjects;
  Map<DateTime, List<CalendarModel>>? holidays;
  VacationSickAvailable? vacationSickAvailable;
  Map<DateTime, List<CalendarModel>>? logs;
  List<RulesModel> rules;
  List<UserModel> usersForCreatingProject;
  List<StackModel> stack;
  List<LogModel> requests;
}

AppState appStateReducer(AppState state, dynamic action) => AppState(
    isLoading: loadingReducers(state.isLoading, action),
    usersForCreatingProject:
        usersForCreatingProjectReducers(state.usersForCreatingProject, action),
    vacationSickAvailable:
        vacacationSickReducers(state.vacationSickAvailable, action),
    filter: filterReducers(state.filter, action),
    projectsFilter: projectFilterReducers(state.projectsFilter, action),
    titles: titleReducer(state.titles, action),
    timelogProjects: timelogProjectsReducers(state.timelogProjects, action),
    filterLogsUsersProjects: filterLogsUserProjectsFilterReducers(
        state.filterLogsUsersProjects, action),
    filterProjectsUsersStack: filterProjectsUsersStackReducers(
        state.filterProjectsUsersStack, action),
    holidays: holidaysReducers(state.holidays, action),
    project: projectReducers(state.project, action),
    lastProject: lastProjectReducers(state.lastProject, action),
    currentDate: currentDateReducers(state.currentDate, action),
    absentUsers: absentUsersReducers(state.absentUsers, action),
    absentProjects: absentProjectsReducers(state.absentProjects, action),
    projects: projectsReducers(state.projects, action),
    users: usersReducers(state.users, action),
    currentUser: userReducers(state.currentUser, action),
    logsByDate: logsbyDateReducers(state.logsByDate, action),
    statistic: statisticReducers(state.statistic, action),
    logs: logsReducer(state.logs, action),
    user: authReducers(state.user, action),
    stack: stackReducers(state.stack, action),
    rules: rulesReducers(state.rules, action),
    requests: requestsReducer(state.requests, action),
    notify: notifyReducers(state.notify, action));
