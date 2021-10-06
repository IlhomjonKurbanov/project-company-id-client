import 'package:company_id_new/main.dart';
import 'package:company_id_new/screens/home/home.screen.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:flutter/material.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> routeEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<PushAction>().map((PushAction action) {
      navigatorKey.currentState?.push<dynamic>(MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => action.destination));
    });

Stream<void> routePopEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<PopAction>().map((PopAction action) {
      if (action.isExternal) {
        if (action.params != null) {
          mainNavigatorKey.currentState?.pop<dynamic>(action.params);
        } else {
          mainNavigatorKey.currentState?.pop<dynamic>();
        }
      }
      if (action.params != null) {
        navigatorKey.currentState?.pop<dynamic>(action.params);
      } else {
        navigatorKey.currentState?.pop<dynamic>();
      }
    });

Stream<void> routePopUntilEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<PopUntilFirst>().map((PopUntilFirst action) {
      navigatorKey.currentState
          ?.popUntil((Route<dynamic> route) => route.isFirst);
    });

Stream<void> routePushReplacmentEpic(
        Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions
        .whereType<PushReplacementAction>()
        .map((PushReplacementAction action) async {
      if (action.isExternal) {
        mainNavigatorKey.currentState?.pushReplacement<dynamic, dynamic>(
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => action.destination));
      } else {
        navigatorKey.currentState?.pushReplacement<dynamic, dynamic>(
            MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => action.destination));
      }
    });
