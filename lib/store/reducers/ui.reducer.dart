// Package imports:
import 'package:redux/redux.dart';

// Project imports:
import 'package:company_id_new/store/actions/route.action.dart';
import 'package:company_id_new/store/actions/ui.action.dart';

final Reducer<List<String>> titleReducer = combineReducers<
    List<String>>(<List<String> Function(List<String>, dynamic)>[
  TypedReducer<List<String>, SetTitle>(_addTitle),
  TypedReducer<List<String>, SetClearTitle>(_setClearTitle),
  TypedReducer<List<String>, PopAction>(_removeLast),
  TypedReducer<List<String>, PushAction>(_addTitle),
]);

List<String> _addTitle(List<String> titles, dynamic action) {
  if (action is PushAction && action.isExternal) {
    return titles;
  }
  final List<String> newTitles = <String>[...titles, action.title as String];
  return newTitles;
}

List<String> _setClearTitle(List<String> titles, dynamic action) =>
    <String>[action.title as String];

List<String> _removeLast(List<String> titles, PopAction action) {
  if (!action.changeTitle || action.isExternal) {
    return titles;
  }
  final List<String> newTitles = <String>[...titles];
  newTitles.removeLast();
  return newTitles;
}
