import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, TodosLoadedAction>(_setLoaded).call,
  TypedReducer<bool, TodosNotLoadedAction>(_setLoaded).call,
]);

bool _setLoaded(bool state, dynamic action) {
  return false;
}
