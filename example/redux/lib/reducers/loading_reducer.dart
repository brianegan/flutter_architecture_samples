import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/utils.dart';

final loadingReducer = combineTypedReducers<bool>([
  new ReducerBinder<bool, TodosLoadedAction>(_setLoaded),
  new ReducerBinder<bool, TodosNotLoadedAction>(_setLoaded),
]);

bool _setLoaded(bool state, action) {
  return false;
}
