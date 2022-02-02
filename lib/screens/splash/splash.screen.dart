// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-images.dart';
import 'package:company_id_new/store/actions/auth.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/reducers/reducer.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
