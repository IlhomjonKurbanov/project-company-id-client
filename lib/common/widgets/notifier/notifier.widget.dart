import 'package:bot_toast/bot_toast.dart';
import 'package:company_id_new/common/helpers/app-colors.dart';
import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class _ViewModel {
  _ViewModel({required this.markAsHandled, this.notify});
  final Function markAsHandled;
  final NotifyModel? notify;
}

class Notifier extends StatelessWidget {
  const Notifier({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, _ViewModel>(
      converter: (Store<AppState> store) => _ViewModel(
          notify: store.state.notify,
          markAsHandled: () => store.dispatch(NotifyHandled())),
      builder: (BuildContext context, _ViewModel state) => child,
      onWillChange: (_ViewModel? state, _ViewModel a) {
        if (a.notify != null) {
          a.markAsHandled();
          BotToast.showCustomNotification(
              toastBuilder: (_) => Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _getColor(a.notify!.type)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Container(
                        padding: const EdgeInsets.fromLTRB(18, 18, 13, 18),
                        child: _getIcon(a.notify!.type)),
                    Text(a.notify!.notificationMessage),
                    GestureDetector(
                        onTap: () {
                          BotToast.cleanAll();
                        },
                        child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0),
                            child: Icon(Icons.close,
                                size: 20, color: Colors.white)))
                  ])),
              align: const Alignment(-0.97, -0.8),
              duration: const Duration(seconds: 3));
        }
      },
      distinct: true);

  Icon _getIcon(NotificationType type) {
    switch (type) {
      case NotificationType.Error:
        return const Icon(Icons.warning, color: Colors.white, size: 24);
      case NotificationType.Success:
        return const Icon(Icons.check, color: Colors.white, size: 24);
      case NotificationType.Warning:
        return const Icon(Icons.warning, color: Colors.white, size: 24);
      default:
        return const Icon(Icons.warning, color: Colors.white, size: 24);
    }
  }

  Color _getColor(NotificationType type) {
    switch (type) {
      case NotificationType.Error:
        return AppColors.darkRed;
      case NotificationType.Success:
        return AppColors.green;
      case NotificationType.Warning:
        return AppColors.yellow;
      default:
        return AppColors.yellow;
    }
  }
}
