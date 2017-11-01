import 'package:redux_sample/actions.dart';
import 'package:redux_sample/models.dart';
import 'package:redux_future/redux_future.dart';

// We create the State reducer by combining many smaller reducers into one!
AppState stateReducer(AppState state, action) {
  return new AppState(
    isLoading: loadingReducer(state.isLoading, action),
    todos: todosReducer(state.todos, state.allComplete, action),
    activeFilter: activeFilterReducer(state.activeFilter, action),
    activeTab: activeTabReducer(state.activeTab, action),
  );
}

List<Todo> todosReducer(List<Todo> todos, bool allComplete, action) {
  if (action is AddTodoAction) {
    return new List.from(todos)..add(action.todo);
  }

  if (action is DeleteTodoAction) {
    return todos.where((todo) => todo.id != action.id).toList();
  }

  if (action is UpdateTodoAction) {
    return todos
        .map((todo) => todo.id == action.id ? action.updatedTodo : todo)
        .toList();
  }

  if (action is ClearCompletedAction) {
    return todos.where((todo) => !todo.complete).toList();
  }

  if (action is ToggleAllAction) {
    return todos.map((todo) => todo.copyWith(complete: !allComplete)).toList();
  }

  if (action is FutureFulfilledAction<List<Todo>>) {
    return action.result;
  }

  if (action is FutureRejectedAction) {
    return [];
  }

  return todos;
}

VisibilityFilter activeFilterReducer(VisibilityFilter activeFilter, action) {
  if (action is UpdateFilterAction) {
    return action.newFilter;
  }

  return activeFilter;
}

AppTab activeTabReducer(AppTab activeTab, action) {
  if (action is UpdateTabAction) {
    return action.newTab;
  }

  return activeTab;
}

bool loadingReducer(bool isLoading, action) {
  if (action is FutureFulfilledAction<List<Todo>>) {
    return false;
  }

  if (action is FutureRejectedAction) {
    return false;
  }

  return isLoading;
}
