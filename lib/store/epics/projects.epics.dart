import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/local-storage.service.dart';
import 'package:company_id_new/common/services/projects.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/ui.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/project.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> getProjectsEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetProjectsPending>().switchMap((GetProjectsPending
            action) =>
        Stream<List<ProjectModel>>.fromFuture(
                ProjectsService.getProjects(action, store.state.projectsFilter))
            .map((List<ProjectModel> projects) {
          switch (action.projectTypes) {
            case ProjectsType.Default:
              return GetProjectsSuccess(projects);
            case ProjectsType.Filter:
              return GetLogsFilterProjectsSucess(projects);
            case ProjectsType.AddTimelog:
              return GetActiveProjectsByUserSuccess(projects);
            case ProjectsType.Absent:
              return GetAbsentProjectsSuccess(projects, action.projectTypes);
            default:
              return null;
          }
        }).handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(GetProjectsError());
        }));

Stream<void> getDetailProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetDetailProjectPending>().switchMap(
        (GetDetailProjectPending action) => Stream<ProjectModel>.fromFuture(
                    ProjectsService.getDetailProject(action.projectId))
                .map((ProjectModel project) => GetDetailProjectSuccess(project))
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetDetailProjectError());
            }));

Stream<void> createProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<CreateProjectPending>().switchMap((CreateProjectPending
            action) =>
        Stream<void>.fromFuture(ProjectsService.createProject(action.project))
            .expand<dynamic>((_) => <dynamic>[
                  CreateProjectSuccess(),
                  GetProjectsPending(),
                  SetClearTitle('Projects'),
                  PopUntilFirst()
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(CreateProjectError());
        }));

Stream<void> getLastProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetProjectPrefPending>().switchMap(
        (GetProjectPrefPending action) => Stream<String>.fromFuture(
                    localStorageService
                        .getData<String>(AppConstants.lastProject))
                .map((String id) => GetProjectPrefSuccess(id))
                .handleError((dynamic e) {
              s.store.dispatch(GetProjectPrefError());
            }));

Stream<void> setLastProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<SetProjectPrefPending>().switchMap(
        (SetProjectPrefPending action) => Stream<bool>.fromFuture(
                localStorageService.saveData(
                    AppConstants.lastProject, action.lastProjectId))
            .map<dynamic>((_) => SetProjectPrefSuccess(action.lastProjectId)));

Stream<void> addUserToProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<AddUserToProjectPending>().switchMap(
        (AddUserToProjectPending action) => Stream<UserModel>.fromFuture(
                    ProjectsService.addUserToProject(
                        action.user, action.project, action.isActive))
                .expand<dynamic>((UserModel user) => <dynamic>[
                      action.isAddedUserToProject
                          ? AddUserToProjectSuccess(
                              action.isActive ? action.user : user,
                              action.isActive)
                          : AddProjectToUserSuccess(
                              action.project,
                            ),
                      Notify(NotifyModel(NotificationType.Success,
                          'User has been added to the project')),
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(AddUserToProjectError());
            }));

Stream<void> removeUserFromProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<RemoveUserFromProjectPending>().switchMap(
        (RemoveUserFromProjectPending action) => Stream<void>.fromFuture(
                    ProjectsService.removeUserFromActiveProject(
                        action.user, action.projectId))
                .expand<dynamic>((_) => <dynamic>[
                      RemoveUserFromProjectSuccess(action.user),
                      Notify(NotifyModel(NotificationType.Success,
                          'User has been removed from the project')),
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(RemoveUserFromProjectError());
            }));

Stream<void> archiveProjectEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<ArchiveProjectPending>().switchMap(
        (ArchiveProjectPending action) => Stream<void>.fromFuture(
                    ProjectsService.archiveProject(action.id, action.status))
                .expand<dynamic>((_) => <dynamic>[
                      GetProjectsPending(),
                      Notify(NotifyModel(
                          NotificationType.Success,
                          action.status == ProjectStatus.Finished
                              ? 'Project has been finished'
                              : 'Project has been rejected')),
                      ArchiveProjectSuccess(),
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(ArchiveProjectError());
            }));
