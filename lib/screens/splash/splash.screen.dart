import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
import 'package:company_id_new/common/services/local-storage.service.dart';
import 'package:company_id_new/screens/change-password/change-password.screen.dart';
import 'package:company_id_new/screens/signup/signup.screen.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;
      final String? forgotToken = deepLink?.queryParameters['forgotToken'];
      final String? registerToken = deepLink?.queryParameters['registerToken'];
      await localStorageService.saveTokenKey('');
      if (forgotToken != null) {
        store.dispatch(PushReplacementAction(ChangePasswordScreen(forgotToken),
            isExternal: true));
      }
      if (registerToken != null) {
        store.dispatch(PushReplacementAction(SignupScreen(registerToken),
            isExternal: true));
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });

    await FirebaseDynamicLinks.instance.getInitialLink();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: AppColors.bg,
      body: StoreConnector<AppState, dynamic>(
          converter: (Store<AppState> store) {},
          onInit: (Store<AppState> store) {
            store.dispatch(CheckTokenPending());
            store.dispatch(GetProjectPrefPending());
          },
          builder: (BuildContext context, dynamic state) =>
              Center(child: Image.asset(AppImages.jsdaddy))));
}
