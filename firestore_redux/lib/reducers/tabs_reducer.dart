import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:redux/redux.dart';

final tabsReducer = combineReducers<AppTab>([
  TypedReducer<AppTab, UpdateTabAction>(_activeTabReducer),
]);

AppTab _activeTabReducer(AppTab activeTab, UpdateTabAction action) {
  return action.newTab;
}
