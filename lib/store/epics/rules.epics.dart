import 'package:company_id_new/common/services/rules.service.dart';
import 'package:company_id_new/store/actions/error.actions.dart';
import 'package:company_id_new/store/actions/rules.action.dart';
import 'package:company_id_new/store/models/rules.model.dart';
import 'package:company_id_new/store/reducers/reducer.dart';
import 'package:company_id_new/store/store.dart' as s;
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Stream<void> getRulesEpic(Stream<dynamic> actions, EpicStore<AppState> store) =>
    actions.whereType<GetRulesPending>().switchMap((GetRulesPending action) =>
        Stream<List<RulesModel>>.fromFuture(RulesService.getRules())
            .map((List<RulesModel> rules) => GetRulesSuccess(rules))
            .handleError((dynamic e) {
          s.store.dispatch(SetError(e));
          s.store.dispatch(GetRulesError());
        }));
