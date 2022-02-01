import 'package:company_id_new/common/services/local-storage.service.dart';
import 'package:company_id_new/screens/change-password/change-password.screen.dart';
import 'package:company_id_new/screens/signup/signup.screen.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/store.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

mixin DynamicLinkService {
  static Future<void> retrieveDynamicLink() async {
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      _handleLink(data);
      FirebaseDynamicLinks.instance.onLink(
          onSuccess: (PendingDynamicLinkData? data) async {
        _handleLink(data);
      }, onError: (OnLinkErrorException e) async {
        print(e.message);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<void> _handleLink(PendingDynamicLinkData? data) async {
    if (data == null) {
      return;
    }
    final Uri deepLink = data.link;
    final String? forgotToken = deepLink.queryParameters['forgotToken'];
    final String? registerToken = deepLink.queryParameters['registerToken'];
    await localStorageService.saveTokenKey('');
    if (forgotToken != null) {
      store.dispatch(PushReplacementAction(ChangePasswordScreen(forgotToken),
          isExternal: true));
    }
    if (registerToken != null) {
      store.dispatch(
          PushReplacementAction(SignupScreen(registerToken), isExternal: true));
    }
  }
}
