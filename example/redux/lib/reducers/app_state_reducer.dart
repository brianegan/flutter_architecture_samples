import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/reducers/loading_reducer.dart';
import 'package:redux_sample/reducers/todos_reducer.dart';
import 'package:redux_sample/reducers/visibility_reducer.dart';
import 'package:redux_sample/reducers/tabs_reducer.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState appReducer(AppState state, action) {
  return new AppState(
    isLoading: loadingReducer(state.isLoading, action),
    todos: todosReducer(state.todos, action),
    activeFilter: visibilityReducer(state.activeFilter, action),
    activeTab: tabsReducer(state.activeTab, action),
  );
}