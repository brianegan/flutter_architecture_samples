import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';

final visibilityReducer = combineTypedReducers<VisibilityFilter>([
  new ReducerBinding<VisibilityFilter, UpdateFilterAction>(
      _activeFilterReducer),
]);

VisibilityFilter _activeFilterReducer(
    VisibilityFilter activeFilter, UpdateFilterAction action) {
  return action.newFilter;
}
