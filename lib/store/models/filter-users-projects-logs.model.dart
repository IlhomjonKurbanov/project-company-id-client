// Project imports:
import 'project.model.dart';
import 'user.model.dart';

class FilterLogsUsersProjects {
  FilterLogsUsersProjects({required this.users, required this.projects});
  List<UserModel> users;
  List<ProjectModel> projects;

  FilterLogsUsersProjects copyWith(
          {List<UserModel>? users, List<ProjectModel>? projects}) =>
      FilterLogsUsersProjects(
          projects: projects ?? this.projects, users: users ?? this.users);
}
