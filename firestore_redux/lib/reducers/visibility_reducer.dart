import 'package:fire_redux_sample/actions/actions.dart';
import 'package:fire_redux_sample/models/models.dart';
import 'package:redux/redux.dart';

final visibilityReducer = combineReducers<VisibilityFilter>([
  TypedReducer<VisibilityFilter, UpdateFilterAction>(_activeFilterReducer),
]);

VisibilityFilter _activeFilterReducer(
  VisibilityFilter activeFilter,
  UpdateFilterAction action,
) {
  return action.newFilter;
}
