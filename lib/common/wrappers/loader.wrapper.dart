// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/store/reducers/reducer.dart';

class _ViewModel {
  _ViewModel({required this.isLoading});
  final bool isLoading;
}

class LoaderWrapper extends StatelessWidget {
  const LoaderWrapper({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (Store<AppState> store) => _ViewModel(
            isLoading: store.state.isLoading,
          ),
      builder: (BuildContext context, _ViewModel state) => child,
      onWillChange: (_ViewModel? prev, _ViewModel? curr) {
        if (prev?.isLoading != curr?.isLoading) {
          if (curr!.isLoading) {
            BotToast.showCustomLoading(
                toastBuilder: (_) =>
                    const SpinKitFadingFour(color: AppColors.main));
          } else {
            BotToast.closeAllLoading();
          }
        }
      });
}
