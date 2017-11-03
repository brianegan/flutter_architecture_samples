import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/utils.dart';


final visibilityReducer = combineTypedReducers<VisibilityFilter>([
  new ReducerBinder<VisibilityFilter, UpdateFilterAction>(_activeFilterReducer),
]);


VisibilityFilter _activeFilterReducer(
    VisibilityFilter activeFilter, UpdateFilterAction action) {
  return action.newFilter;
}
