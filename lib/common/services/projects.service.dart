import 'package:company_id_new/common/helpers/app-api.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:dio/dio.dart';

Future<List<ProjectModel>> getProjects(
    ProjectsType projectTypes, String uid) async {
  Response<dynamic> res;
  if (projectTypes == ProjectsType.Absent) {
    res = await api.dio.get<dynamic>('/projects/absent/users/$uid');
  } else {
    res = await api.dio.get<dynamic>('/projects');
  }
  final List<dynamic> projects = res.data as List<dynamic>;
  return projects.isEmpty
      ? <ProjectModel>[]
      : projects
          .map<ProjectModel>((dynamic project) =>
              ProjectModel.fromJson(project as Map<String, dynamic>))
          .toList();
}

Future<ProjectModel> getDetailProject(String projectId) async {
  final Response<dynamic> res =
      await api.dio.get<dynamic>('/projects/$projectId');
  final Map<String, dynamic> project = res.data as Map<String, dynamic>;
  return ProjectModel.fromJson(project);
}

Future<ProjectModel> createProject(ProjectModel project) async {
  print('gdgdgetettr');
  print(project);
  final Response<dynamic> res = await api.dio.post<dynamic>('/projects'
      // , data: project.toJson()
      );
  final Map<String, dynamic> project1 = res.data as Map<String, dynamic>;
  print('gfgfg');
  print(res);
  return ProjectModel.fromJson(project1);
}

Future<UserModel> addUserToProject(
    UserModel user, ProjectModel project, bool isActive) async {
  final Response<dynamic> res = await api.dio
      .post<dynamic>('/user/${user.id}/projects/${project.id}/$isActive');
  final Map<String, dynamic> newUser = res.data as Map<String, dynamic>;
  return UserModel.fromJson(newUser);
}

Future<void> removeUserFromActiveProject(
    UserModel user, String projectId) async {
  await api.dio.delete<dynamic>('/user/${user.id}/active-project/$projectId');
}
