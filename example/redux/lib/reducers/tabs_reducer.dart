import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/utils.dart';

final tabsReducer = combineTypedReducers<AppTab>([
  new ReducerBinder<AppTab, UpdateTabAction>(_activeTabReducer),
]);

AppTab _activeTabReducer(AppTab activeTab, UpdateTabAction action) {
  return action.newTab;
}