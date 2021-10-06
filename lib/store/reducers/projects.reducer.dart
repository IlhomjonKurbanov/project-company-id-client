import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:redux/redux.dart';

final Reducer<List<ProjectModel>> projectsReducers =
    combineReducers<List<ProjectModel>>(<
        List<ProjectModel> Function(List<ProjectModel>, dynamic)>[
  TypedReducer<List<ProjectModel>, GetProjectsSuccess>(_setProjects),
]);

List<ProjectModel> _setProjects(List<ProjectModel> title, dynamic action) =>
    action.projects as List<ProjectModel>;

final Reducer<ProjectModel?> projectReducers = combineReducers<
    ProjectModel?>(<ProjectModel? Function(ProjectModel?, dynamic)>[
  TypedReducer<ProjectModel?, GetDetailProjectSuccess>(_setProject),
  TypedReducer<ProjectModel?, AddUserToProjectSuccess>(_addUserToProject),
  TypedReducer<ProjectModel?, ClearDetailProject>(_clearProject),
  TypedReducer<ProjectModel?, RemoveUserFromProjectSuccess>(
      _removeUserFromProject),
]);

ProjectModel? _setProject(
        ProjectModel? project, GetDetailProjectSuccess action) =>
    action.project;

ProjectModel? _clearProject(ProjectModel? project, ClearDetailProject action) =>
    null;

ProjectModel? _addUserToProject(
    ProjectModel? project, AddUserToProjectSuccess action) {
  List<UserModel> history = <UserModel>[];
  List<UserModel> onboard = <UserModel>[];
  if (project!.history != null) {
    history = <UserModel>[...project.history!];
  }
  if (project.onboard != null) {
    onboard = <UserModel>[...project.history!];
  }
  if (!action.isActive) {
    history = <UserModel>[...history, action.user];
  }
  onboard = <UserModel>[...onboard, action.user];
  return project.copyWith(history: history, onboard: onboard);
}

ProjectModel? _removeUserFromProject(
    ProjectModel? project, RemoveUserFromProjectSuccess action) {
  List<UserModel> onboard = <UserModel>[];
  if (project!.onboard != null) {
    onboard = <UserModel>[...project.onboard!];
  }
  onboard
      .removeWhere((UserModel userOnBoard) => userOnBoard.id == action.user.id);
  return project.copyWith(onboard: onboard);
}

final Reducer<String?> lastProjectReducers =
    combineReducers<String?>(<String? Function(String?, dynamic)>[
  TypedReducer<String?, GetProjectPrefSuccess>(_getLastProject),
  TypedReducer<String?, SetProjectPrefSuccess>(_setLastProject),
]);
String? _getLastProject(String? state, GetProjectPrefSuccess action) =>
    action.lastProjectId;

String? _setLastProject(String? state, SetProjectPrefSuccess action) =>
    action.lastProjectId;

final Reducer<List<ProjectModel>> absentProjectsReducers =
    combineReducers<List<ProjectModel>>(<
        List<ProjectModel> Function(List<ProjectModel>, dynamic)>[
  TypedReducer<List<ProjectModel>, GetAbsentProjectsSuccess>(
      _setAbsentProjects),
]);

List<ProjectModel> _setAbsentProjects(
        List<ProjectModel> title, GetAbsentProjectsSuccess action) =>
    action.absentProjects;

final Reducer<List<ProjectModel>> timelogProjectsReducers =
    combineReducers<List<ProjectModel>>(<
        List<ProjectModel> Function(List<ProjectModel>, dynamic)>[
  TypedReducer<List<ProjectModel>, GetActiveProjectsByUserSuccess>(
      _setProjects),
]);
