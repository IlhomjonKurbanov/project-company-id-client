import 'package:company_id_new/common/helpers/app-enums.dart';
import 'package:company_id_new/common/services/stack.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/filter.action.dart';
import 'package:company_id_new/store/actions/stack.action.dart';
import 'package:company_id_new/store/models/stack.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> getStackEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetStackPending>().switchMap((GetStackPending action) =>
        Stream<List<StackModel>>.fromFuture(StackService.getStack())
            .map<dynamic>((List<StackModel> stack) {
          switch (action.stackTypes) {
            case StackTypes.Default:
              return GetStackSuccess(stack);
            case StackTypes.ProjectFilter:
              return GetProjectsFilterStackSuccess(stack);
            default:
              return null;
          }
        }).handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(GetStackError());
        }));
