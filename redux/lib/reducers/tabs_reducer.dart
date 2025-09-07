import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';

final tabsReducer = combineReducers<AppTab>([
  TypedReducer<AppTab, UpdateTabAction>(_activeTabReducer).call,
]);

AppTab _activeTabReducer(AppTab activeTab, UpdateTabAction action) =>
    action.newTab;
