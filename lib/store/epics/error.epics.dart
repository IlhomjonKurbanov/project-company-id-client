import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/notifier.action.dart';
import 'package:company_id_new/store/models/notify.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> errorEpic(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) =>
    actions.whereType<SetError>().switchMap((SetError action) =>
        Stream<dynamic>.value(action.error).map<dynamic>((dynamic error) {
          print(error);
          String? errorText =
              error is DioError && error.response?.data is Map<String, dynamic>
                  ? error.response?.data['message'] as String
                  : null;
          if (error is String) {
            errorText = error;
          }
          if (error is PlatformException) {
            errorText = error.message;
          }
          print(errorText);
          return Notify(NotifyModel(NotificationType.Error,
              errorText ?? 'Something went wrong. Try again'));
        }));
