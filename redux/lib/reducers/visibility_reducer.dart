import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';

final visibilityReducer = combineReducers<VisibilityFilter>([
  TypedReducer<VisibilityFilter, UpdateFilterAction>(_activeFilterReducer).call,
]);

VisibilityFilter _activeFilterReducer(
  VisibilityFilter activeFilter,
  UpdateFilterAction action,
) => action.newFilter;
