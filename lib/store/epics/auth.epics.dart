import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/auth.service.dart';
import 'package:company_id_new/common/services/dynamic-links.service.dart';
import 'package:company_id_new/screens/home/home.screen.dart';
import 'package:company_id_new/screens/login/login.screen.dart';
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
        (CheckTokenPending action) =>
            Stream<UserModel>.fromFuture(AuthService.checkToken())
                .expand<dynamic>((UserModel user) => <dynamic>[
                      SetTitle(AppConstants.Statistics),
                      SignInSuccess(user),
                      user.position == Positions.Owner
                          ? GetRequestsPending()
                          : null,
                      PushReplacementAction(HomeScreen(), isExternal: true)
                    ])
                .onErrorReturnWith((dynamic e) =>
                    PushReplacementAction(LoginScreen(), isExternal: true)));

Stream<dynamic> retrieveDynamicLinkEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<RetrieveDynamicLinkPending>().switchMap<dynamic>(
        (RetrieveDynamicLinkPending action) =>
            Stream<void>.fromFuture(DynamicLinkService.retrieveDynamicLink())
                .map<dynamic>((_) {
              return RetrieveDynamicLinkSucess();
            }).handleError((dynamic e) {
              print(e);
              s.store.dispatch(RetrieveDynamicLinkError());
            }));

Stream<void> logoutEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<LogoutPending>().switchMap((LogoutPending action) =>
        Stream<void>.fromFuture(AuthService.logout()).expand<dynamic>((_) =>
            <dynamic>[
              LogoutSuccess(),
              PushReplacementAction(LoginScreen(), isExternal: true)
            ]));

Stream<void> getSignUpLink(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetSignUpLinkPending>().switchMap(
        (GetSignUpLinkPending action) =>
            Stream<void>.fromFuture(AuthService.getSignUpLink(action.email))
                .expand<dynamic>((_) => <dynamic>[
                      GetSignUpLinkSuccess(),
                      Notify(NotifyModel(
                          NotificationType.Success, 'Please check your email')),
                      PushAction(LoginScreen(), '', isExternal: true)
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(GetSignUpLinkError());
            }));

Stream<void> forgotPasswordLinkEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<ForgotPasswordSendLinkPending>().switchMap(
        (ForgotPasswordSendLinkPending action) => Stream<void>.fromFuture(
                    AuthService.forgotPasswordLink(action.email))
                .expand<dynamic>((_) => <dynamic>[
                      ForgotPasswordSendLinkSuccess(),
                      Notify(NotifyModel(
                          NotificationType.Success, 'Please check your email')),
                      PushAction(LoginScreen(), '', isExternal: true)
                    ])
                .handleError((dynamic e) {
              s.store.dispatch(SetError(e));
              s.store.dispatch(ForgotPasswordSendLinkError());
            }));

Stream<void> changePasswordEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<ChangePasswordPending>().switchMap((ChangePasswordPending
            action) =>
        Stream<UserModel>.fromFuture(AuthService.forgotChangePassword(action))
            .expand<dynamic>((UserModel user) => <dynamic>[
                  ChangePasswordSuccess(),
                  Notify(NotifyModel(
                      NotificationType.Success, 'Password has been changed')),
                  SignInSuccess(user),
                  SetTitle(AppConstants.Statistics),
                  PushReplacementAction(HomeScreen(), isExternal: true)
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(ChangePasswordError());
        }));

Stream<void> signInEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<SignInPending>().switchMap((SignInPending action) =>
        Stream<UserModel>.fromFuture(AuthService.singIn(action))
            .expand<dynamic>((UserModel user) => <dynamic>[
                  SignInSuccess(user),
                  SetTitle(AppConstants.Statistics),
                  PushReplacementAction(HomeScreen(), isExternal: true)
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(SignInError());
        }));

Stream<void> signUpEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<SignupPending>().switchMap((SignupPending action) =>
        Stream<UserModel>.fromFuture(AuthService.singUp(action.signup))
            .expand<dynamic>((UserModel user) => <dynamic>[
                  SignupSuccess(),
                  SignInSuccess(user),
                  SetTitle(AppConstants.Statistics),
                  PushReplacementAction(HomeScreen(), isExternal: true)
                ])
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(SignupError());
        }));
