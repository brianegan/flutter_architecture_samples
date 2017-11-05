import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';

final loadingReducer = combineTypedReducers<bool>([
  new ReducerBinding<bool, TodosLoadedAction>(_setLoaded),
  new ReducerBinding<bool, TodosNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}
