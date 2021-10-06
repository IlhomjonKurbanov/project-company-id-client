import 'package:bot_toast/bot_toast.dart';
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/notifier/notifier.widget.dart';
import 'package:company_id_new/common/wrappers/loader.wrapper.dart';
import 'package:company_id_new/screens/splash/splash.screen.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/projects.action.dart';
import 'package:company_id_new/store/actions/users.action.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

void main() => runApp(MyApp(store: store));

class MyApp extends StatefulWidget {
  const MyApp({required this.store});
  final Store<AppState> store;
  @override
  _MyAppState createState() => _MyAppState();
}

GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && store.state.user?.id != null) {
      if (store.state.user?.position == Positions.Owner) {
        store.dispatch(GetRequestsPending());
      }
      store.dispatch(GetProjectsPending());
      store.dispatch(GetLogsPending('${store.state.currentDate.currentMohth}'));
      store.dispatch(
          GetLogByDatePending('${store.state.currentDate.focusedDay}'));
      store.dispatch(GetUsersPending(true));
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
    ]);
    return StoreProvider<AppState>(
      store: widget.store,
      child: Notifier(
          child: LoaderWrapper(
              child: MaterialApp(
                  builder: BotToastInit(),
                  navigatorObservers: <NavigatorObserver>[
                    BotToastNavigatorObserver()
                  ],
                  theme: ThemeData(
                    appBarTheme: const AppBarTheme(
                        elevation: 0,
                        centerTitle: true,
                        backgroundColor: AppColors.main,
                        titleTextStyle:
                            TextStyle(fontSize: 20, color: AppColors.main2),
                        actionsIconTheme:
                            IconThemeData(color: AppColors.main2)),
                    dialogTheme: const DialogTheme(
                      backgroundColor: AppColors.bg,
                      titleTextStyle: TextStyle(color: Colors.red),
                    ),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                            backgroundColor: AppColors.main),
                    unselectedWidgetColor: Colors.white,
                    primaryColor: AppColors.main,
                    textTheme: const TextTheme(
                        bodyText1: TextStyle(color: Colors.white),
                        bodyText2: TextStyle(color: Colors.white)),
                    canvasColor: AppColors.bg,
                    fontFamily: 'Helvetica',
                  ),
                  navigatorKey: mainNavigatorKey,
                  debugShowCheckedModeBanner: false,
                  home: SplashScreen()))),
    );
  }
}
