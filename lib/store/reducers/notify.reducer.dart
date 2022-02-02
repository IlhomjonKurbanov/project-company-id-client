// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';

final Reducer<NotifyModel?> notifyReducers = combineReducers<
    NotifyModel?>(<NotifyModel? Function(NotifyModel?, dynamic)>[
  TypedReducer<NotifyModel?, Notify>(_notify),
  TypedReducer<NotifyModel?, NotifyHandled>(_notified),
]);

NotifyModel? _notify(NotifyModel? notify, Notify action) => action.notify;

NotifyModel? _notified(NotifyModel? notify, NotifyHandled action) => null;
