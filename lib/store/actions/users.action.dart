// Project imports:
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';

class GetUsersPending {
  GetUsersPending(this.isFired,
      {this.usersType = UsersType.Default, this.projectId});
  UsersType usersType;
  bool isFired;
  String? projectId;
}

class GetUsersSuccess {
  GetUsersSuccess(this.users);
  List<UserModel> users;
}

class GetUsersForCreatingProjectSuccess {
  GetUsersForCreatingProjectSuccess(this.users);
  List<UserModel> users;
}

class GetAbsentUsersSuccess {
  GetAbsentUsersSuccess(this.absentUsers);
  List<UserModel> absentUsers;
}

class GetUsersError {}

class GetUserPending {
  GetUserPending(this.id);
  String id;
}

class GetUserSuccess {
  GetUserSuccess(this.user);
  UserModel user;
}

class GetUserError {}

class ArchiveUserPending {
  ArchiveUserPending(this.id);
  String id;
}

class ArchiveUserSuccess {
  ArchiveUserSuccess(this.id, this.date);
  String id;
  DateTime date;
}

class ArchiveUserError {}

class RemoveProjectFromUserPending {
  RemoveProjectFromUserPending(this.userId, this.project);
  String userId;
  ProjectModel project;
}

class RemoveProjectFromUserSuccess {
  RemoveProjectFromUserSuccess(this.project);
  ProjectModel project;
}

class RemoveProjectFromUserError {}

class ChangeEvaluationDatePending {
  const ChangeEvaluationDatePending(this.id, this.date, this.salary);
  final String id;
  final DateTime date;
  final int salary;
}

class ChangeEvaluationDateSuccess {
  const ChangeEvaluationDateSuccess(this.date, this.salary);
  final DateTime date;
  final int salary;
}

class ChangeEvaluationDateError {}
