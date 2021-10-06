import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/models/user.model.dart';

class FilterProjectsUsersStack {
  FilterProjectsUsersStack({required this.users, required this.stack});
  List<UserModel> users;
  List<StackModel> stack;

  FilterProjectsUsersStack copyWith(
          {List<UserModel>? users, List<StackModel>? stack}) =>
      FilterProjectsUsersStack(
          stack: stack ?? this.stack, users: users ?? this.users);
}
