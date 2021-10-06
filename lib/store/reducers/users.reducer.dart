import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:redux/redux.dart';

final Reducer<List<UserModel>> usersReducers = combineReducers<
    List<UserModel>>(<List<UserModel> Function(List<UserModel>, dynamic)>[
  TypedReducer<List<UserModel>, GetUsersSuccess>(_setUsers),
  TypedReducer<List<UserModel>, ArchiveUserSuccess>(_archiveUser),
]);
List<UserModel> _archiveUser(List<UserModel> users, ArchiveUserSuccess action) {
  return users.map((UserModel user) {
    if (action.id == user.id) {
      user.endDate = action.date;
      return user;
    }
    return user;
  }).toList();
}

List<UserModel> _setUsers(List<UserModel> title, dynamic action) {
  return action.users as List<UserModel>;
}

final Reducer<UserModel?> userReducers =
    combineReducers<UserModel?>(<UserModel? Function(UserModel?, dynamic)>[
  TypedReducer<UserModel?, GetUserSuccess>(_setUser),
  TypedReducer<UserModel?, RemoveProjectFromUserSuccess>(
      _removeProjectFromUser),
  TypedReducer<UserModel?, AddProjectToUserSuccess>(_addProjectToUser),
]);

UserModel? _setUser(UserModel? user, GetUserSuccess action) {
  return action.user;
}

UserModel? _removeProjectFromUser(
    UserModel? user, RemoveProjectFromUserSuccess action) {
  List<ProjectModel> activeProjects = <ProjectModel>[];
  if (user!.activeProjects != null) {
    activeProjects = <ProjectModel>[...user.activeProjects!];
  }
  activeProjects
      .removeWhere((ProjectModel project) => project.id == action.project.id);
  return user.copyWith(activeProjects: activeProjects);
}

UserModel? _addProjectToUser(UserModel? user, AddProjectToUserSuccess action) {
  List<ProjectModel> activeProjects = <ProjectModel>[];
  List<ProjectModel> projects = <ProjectModel>[];
  if (user!.activeProjects != null) {
    activeProjects = <ProjectModel>[...user.activeProjects!];
  }
  if (user.projects != null) {
    projects = <ProjectModel>[...user.projects!];
  }
  activeProjects = <ProjectModel>[...projects, action.project];
  projects = <ProjectModel>[...projects, action.project];
  return user.copyWith(activeProjects: activeProjects, projects: projects);
}

final Reducer<List<UserModel>> absentUsersReducers = combineReducers<
    List<UserModel>>(<List<UserModel> Function(List<UserModel>, dynamic)>[
  TypedReducer<List<UserModel>, GetAbsentUsersSuccess>(_setAbsentUsers),
]);

List<UserModel> _setAbsentUsers(
    List<UserModel> title, GetAbsentUsersSuccess action) {
  return action.absentUsers;
}

final Reducer<List<UserModel>> usersForCreatingProjectReducers =
    combineReducers<
        List<UserModel>>(<List<UserModel> Function(List<UserModel>, dynamic)>[
  TypedReducer<List<UserModel>, GetUsersForCreatingProjectSuccess>(_setUsers),
]);
