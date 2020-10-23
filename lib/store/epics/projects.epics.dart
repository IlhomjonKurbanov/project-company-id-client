import 'package:company_id_new/common/services/projects.service.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> getProjectsEpic(
    Stream<dynamic> actions, EpicStore<dynamic> store) {
  return actions
      .where((dynamic action) => action is GetProjectsPending)
      .switchMap((dynamic action) =>
          Stream<List<ProjectModel>>.fromFuture(getProjects())
              .map((List<ProjectModel> projects) {
            return GetProjectsSuccess(projects);
          }))
      .handleError((dynamic e) => print(e));
}

Stream<void> getDetailProjectEpic(
    Stream<dynamic> actions, EpicStore<dynamic> store) {
  return actions
      .where((dynamic action) => action is GetDetailProjectPending)
      .switchMap((dynamic action) => Stream<ProjectModel>.fromFuture(
                  getDetailProject(action.projectId as String))
              .map((ProjectModel project) {
            return GetDetailProjectSuccess(project);
          }))
      .handleError((dynamic e) => print(e));
}
