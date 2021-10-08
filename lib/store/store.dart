import 'package:company_id_new/store/epics/auth.epics.dart';
import 'package:company_id_new/store/epics/error.epics.dart';
import 'package:company_id_new/store/epics/filter.epics.dart';
import 'package:company_id_new/store/epics/logs.epics.dart';
import 'package:company_id_new/store/epics/projects.epics.dart';
import 'package:company_id_new/store/epics/route.epics.dart';
import 'package:company_id_new/store/epics/rules.epics.dart';
import 'package:company_id_new/store/epics/stack.epics.dart';
import 'package:company_id_new/store/epics/users.epics.dart';
import 'package:company_id_new/store/epics/vacations.epics.dart';
import 'package:company_id_new/store/models/current-day.model.dart';
import 'package:company_id_new/store/models/filter-projects-users-stack.model.dart';
import 'package:company_id_new/store/models/filter-users-projects-logs.model.dart';
import 'package:company_id_new/store/models/log.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/rules.model.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:redux_logging/redux_logging.dart';

final AppState initalState = AppState(
    isLoading: false,
    titles: <String>[],
    rules: <RulesModel>[],
    stack: <StackModel>[],
    projects: <ProjectModel>[],
    logsByDate: <LogModel>[],
    requests: <LogModel>[],
    absentUsers: <UserModel>[],
    usersForCreatingProject: <UserModel>[],
    absentProjects: <ProjectModel>[],
    timelogProjects: <ProjectModel>[],
    currentDate: CurrentDateModel(
        focusedDay: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0),
        currentMohth: DateTime(
            DateTime.now().year, DateTime.now().month, 1, DateTime.now().hour)),
    filterProjectsUsersStack:
        FilterProjectsUsersStack(stack: <StackModel>[], users: <UserModel>[]),
    filterLogsUsersProjects: FilterLogsUsersProjects(
        projects: <ProjectModel>[], users: <UserModel>[]),
    users: <UserModel>[]);
final Store<AppState> store = Store<AppState>(appStateReducer,
    initialState: initalState,
    middleware: <
        dynamic Function(Store<AppState>, dynamic, dynamic Function(dynamic))>[
      LoggingMiddleware<dynamic>.printer(),
      EpicMiddleware<AppState>(checkTokenEpic), //h
      EpicMiddleware<AppState>(errorEpic), //h
      EpicMiddleware<AppState>(signInEpic), //h
      EpicMiddleware<AppState>(logoutEpic), //h
      EpicMiddleware<AppState>(routeEpic), //h
      EpicMiddleware<AppState>(routePopEpic), //h
      EpicMiddleware<AppState>(routePushReplacmentEpic), //h
      EpicMiddleware<AppState>(routePopUntilEpic),
      EpicMiddleware<AppState>(getLogByDateEpic), //h
      EpicMiddleware<AppState>(getLogsEpic), //h
      EpicMiddleware<AppState>(usersEpic), //h
      EpicMiddleware<AppState>(getProjectsEpic), //h
      EpicMiddleware<AppState>(getDetailProjectEpic), //h
      EpicMiddleware<AppState>(userEpic), //h
      EpicMiddleware<AppState>(getLastProjectEpic), //h
      EpicMiddleware<AppState>(setLastProjectEpic),
      EpicMiddleware<AppState>(addUserToProjectEpic),
      EpicMiddleware<AppState>(addLogEpic), //h
      EpicMiddleware<AppState>(editLogEpic), //h
      EpicMiddleware<AppState>(deleteLogEpic), //h
      EpicMiddleware<AppState>(getRequestsEpic), //h
      EpicMiddleware<AppState>(requestVacationEpic), //h
      EpicMiddleware<AppState>(changeStatusVacationEpic), //h
      EpicMiddleware<AppState>(filteredLogUsersEpic), //h
      EpicMiddleware<AppState>(filteredLogProjectsEpic), //h
      EpicMiddleware<AppState>(filteredProjectsUsersEpic), //h
      EpicMiddleware<AppState>(filteredProjectsStackEpic), //h
      EpicMiddleware<AppState>(getRulesEpic), //h
      EpicMiddleware<AppState>(removeUserFromProjectEpic),
      EpicMiddleware<AppState>(removeProjectFromUserEpic),
      EpicMiddleware<AppState>(archiveUserEpic),
      EpicMiddleware<AppState>(getStackEpic),
      EpicMiddleware<AppState>(createProjectEpic),
      EpicMiddleware<AppState>(archiveProjectEpic),
      EpicMiddleware<AppState>(getSignUpLink),
      EpicMiddleware<AppState>(signUpEpic),
      EpicMiddleware<AppState>(forgotPasswordLinkEpic),
      EpicMiddleware<AppState>(changePasswordEpic),
    ]);
