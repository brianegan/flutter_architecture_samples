import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';

final tabsReducer = combineTypedReducers<AppTab>([
  new ReducerBinding<AppTab, UpdateTabAction>(_activeTabReducer),
]);

AppTab _activeTabReducer(AppTab activeTab, UpdateTabAction action) {
  return action.newTab;
}
