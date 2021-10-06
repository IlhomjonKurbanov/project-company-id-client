import 'package:company_id_new/common/helpers/app-api.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:dio/dio.dart';

mixin UsersService {
  static Future<List<UserModel>> getUsers(GetUsersPending action) async {
    Response<dynamic> res;
    switch (action.usersType) {
      case UsersType.Absent:
        res = await api.dio
            .get<dynamic>('/user/absent/projects/${action.projectId}');
        break;
      default:
        res = await api.dio.get<dynamic>('/user/all/${!action.isFired}');
    }
    final List<dynamic> users = res.data as List<dynamic>;
    return users.isEmpty
        ? <UserModel>[]
        : users
            .map<UserModel>((dynamic log) =>
                UserModel.fromJson(log as Map<String, dynamic>))
            .toList();
  }

  static Future<UserModel> getUser(String id) async {
    final Response<dynamic> res = await api.dio.get<dynamic>('/user/$id');
    final Map<String, dynamic> user = res.data as Map<String, dynamic>;
    return UserModel.fromJson(user);
  }

  static Future<DateTime> archiveUser(String id) async {
    final Response<dynamic> res = await api.dio.put<dynamic>('/user/$id');
    final Map<String, dynamic> user = res.data as Map<String, dynamic>;
    final DateTime endDate = DateTime.parse(user['endDate'] as String);
    return endDate;
  }

  static Future<void> removeActiveProjectFromUser(
      ProjectModel project, String userId) async {
    await api.dio.delete<dynamic>('/user/$userId/active-project/${project.id}');
  }

  static Future<void> addActiveProjectToUser(
      ProjectModel project, String userId, bool isActive) async {
    await api.dio
        .post<dynamic>('/user/$userId/projects-return/${project.id}/$isActive');
  }
}
