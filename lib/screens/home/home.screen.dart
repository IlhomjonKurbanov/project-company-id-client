import 'dart:io';
import 'package:company_id_new/common/helpers/app-constants.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/widgets/app-appbar/app-appbar.widget.dart';
import 'package:company_id_new/common/widgets/confirm-dialog/confirm-dialog.widget.dart';
import 'package:company_id_new/screens/projects/projects.screen.dart';
import 'package:company_id_new/screens/rules/rules.screen.dart';
import 'package:company_id_new/screens/statistics/statisctis.screen.dart';
import 'package:company_id_new/screens/users/users.screen.dart';
import 'package:company_id_new/store/actions/logs.action.dart';
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/ui.action.dart';
import 'package:company_id_new/store/models/user.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({this.user});
  UserModel? user;
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _hasAccessToStatistics = false;

  final List<Widget> _children = <Widget>[
    StatisticsScreen(),
    UsersScreen(),
    ProjectsScreen(),
    RulesScreen()
  ];

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
            user: store.state.user,
          ),
      onInit: (Store<AppState> store) {
        _hasAccessToStatistics = store.state.user!.position == Positions.Owner;
        if (_hasAccessToStatistics) {
          store.dispatch(GetRequestsPending());
        }
      },
      builder: (BuildContext context, _ViewModel state) => WillPopScope(
          onWillPop: () async {
            if (navigatorKey.currentState!.canPop()) {
              store.dispatch(const PopAction());
            } else {
              final bool? isConfirm = await showDialog<bool>(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) => const ConfirmDialogWidget(
                      title: 'Exit',
                      text: 'Are you sure to exit from application?'));
              if (isConfirm != null && isConfirm) {
                exit(0);
              }
            }
            return false;
          },
          child: Scaffold(
              appBar: AppBarWidget(),
              body: Navigator(
                  key: navigatorKey,
                  onGenerateRoute: (RouteSettings route) =>
                      MaterialPageRoute<dynamic>(
                          settings: route,
                          builder: (BuildContext context) =>
                              _children[_currentIndex])),
              bottomNavigationBar: _bottomNavigation())));

  Widget _bottomNavigation() => BottomNavigationBar(
      unselectedItemColor: Colors.white,
      onTap: (int index) => _onTabTapped(index),
      currentIndex: _currentIndex,
      items: _userBottomNav());

  List<BottomNavigationBarItem> _userBottomNav() => <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: const Icon(Icons.access_alarms),
            label: _hasAccessToStatistics
                ? AppConstants.Statistics
                : AppConstants.Timelog),
        const BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            label: AppConstants.Employees),
        const BottomNavigationBarItem(
            icon: Icon(Icons.desktop_mac), label: AppConstants.Projects),
        const BottomNavigationBarItem(
            icon: Icon(Icons.info_outline), label: AppConstants.Rules)
      ];

  String _getTitleAppBar(int index) {
    switch (index) {
      case 0:
        return _hasAccessToStatistics
            ? AppConstants.Statistics
            : AppConstants.Timelog;
      case 1:
        return AppConstants.Employees;
      case 2:
        return AppConstants.Projects;
      case 3:
        return AppConstants.Rules;
      default:
        return '';
    }
  }

  void _onTabTapped(int index) {
    navigatorKey.currentState!
        .popUntil((Route<dynamic> route) => route.isFirst);
    store.dispatch(SetClearTitle(_getTitleAppBar(index)));
    setState(() {
      _currentIndex = index;
    });
  }
}
