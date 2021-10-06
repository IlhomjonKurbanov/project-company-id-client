import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/auth.service.dart';
import 'package:company_id_new/screens/home/home.screen.dart';
import 'package:company_id_new/screens/login/login.screen.dart';
import 'package:company_id_new/screens/set-password/set-password.screen.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/ui.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> checkTokenEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<CheckTokenPending>().switchMap(
        (CheckTokenPending action) => Stream<UserModel>.fromFuture(
                AuthService.checkToken())
            .expand<dynamic>((UserModel user) => <dynamic>[
                  SetTitle(AppConstants.Statistics),
                  SignInSuccess(user),
                  user.position == Positions.Owner
                      ? GetRequestsPending()
                      : null,
                  PushReplacementAction(
                      user.initialLogin! ? SetPasswordScreen() : HomeScreen(),
                      isExternal: true)
                ])
            .onErrorReturnWith((dynamic e) =>
                PushReplacementAction(LoginScreen(), isExternal: true)));

Stream<void> logoutEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<LogoutPending>().switchMap((LogoutPending action) =>
        Stream<void>.fromFuture(AuthService.logout()).expand<dynamic>((_) =>
            <dynamic>[
              LogoutSuccess(),
              PushReplacementAction(LoginScreen(), isExternal: true)
            ]));

Stream<void> signInEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<SignInPending>().switchMap((SignInPending action) =>
        Stream<UserModel>.fromFuture(AuthService.singIn(action))
            .expand<dynamic>((UserModel user) => <dynamic>[
                  SignInSuccess(user),
                  SetTitle(AppConstants.Statistics),
                  PushReplacementAction(
                      user.initialLogin! ? SetPasswordScreen() : HomeScreen(),
                      isExternal: true)
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(SignInError());
        }));

Stream<void> setPasswordEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<SetPasswordPending>().switchMap(
        (SetPasswordPending action) =>
            Stream<void>.fromFuture(AuthService.setPassword(action.password))
                .expand<dynamic>((_) => <dynamic>[
                      SetPasswordSuccess,
                      PushReplacementAction(HomeScreen(), isExternal: true),
                      SetTitle(AppConstants.Statistics),
                      Notify(NotifyModel(NotificationType.Success,
                          'Your password has been changed')),
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(SetPasswordError());
            }));
