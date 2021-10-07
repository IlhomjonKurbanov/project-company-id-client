import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
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
      if (deepLink != null) {
        store.dispatch(PushAction(
            SignupScreen(deepLink.queryParameters['token'] as String), ''));
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });

    // final PendingDynamicLinkData? data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
    // final Uri? deepLink = data?.link;
    // print(deepLink);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: StoreConnector<AppState, dynamic>(
          converter: (Store<AppState> store) {},
          onInit: (Store<AppState> store) {
            store.dispatch(CheckTokenPending());
            store.dispatch(GetProjectPrefPending());
          },
          builder: (BuildContext context, dynamic state) =>
              Center(child: Image.asset(AppImages.jsdaddy))));
}
