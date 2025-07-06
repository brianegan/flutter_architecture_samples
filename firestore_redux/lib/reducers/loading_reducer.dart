import 'package:fire_redux_sample/actions/actions.dart';
import 'package:redux/redux.dart';

final loadingReducer = combineReducers<bool>([
  TypedReducer<bool, LoadTodosAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}
