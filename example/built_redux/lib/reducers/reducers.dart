import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';

var reducerBuilder = new ReducerBuilder<AppState, AppStateBuilder>()
  ..add(AppActionsNames.addTodoAction, addTodo)
  ..add(AppActionsNames.clearCompletedAction, clearCompleted)
  ..add(AppActionsNames.deleteTodoAction, deleteTodo)
  ..add(AppActionsNames.toggleAllAction, toggleAll)
  ..add(AppActionsNames.updateFilterAction, updateFilter)
  ..add(AppActionsNames.updateTabAction, updateTab)
  ..add(AppActionsNames.updateTodoAction, updateTodo)
  ..add(AppActionsNames.loadTodosSuccess, todosLoaded)
  ..add(AppActionsNames.loadTodosFailure, todosLoadFailed);

void addTodo(AppState state, Action<Todo> action, AppStateBuilder builder) {
  builder.todos.add(action.payload);
}

void clearCompleted(
    AppState state, Action<Null> action, AppStateBuilder builder) {
  builder.todos.where((todo) => !todo.complete);
}

void deleteTodo(
    AppState state, Action<String> action, AppStateBuilder builder) {
  builder.todos.where((todo) => todo.id != action.payload);
}

void toggleAll(AppState state, Action<Null> action, AppStateBuilder builder) {
  final allComplete = state.allCompleteSelector;

  builder.todos = state.todos.toBuilder()
    ..map((todo) => (todo.toBuilder()..complete = !allComplete).build());
}

void updateFilter(
    AppState state, Action<VisibilityFilter> action, AppStateBuilder builder) {
  builder.activeFilter = action.payload;
}

void updateTab(AppState state, Action<AppTab> action, AppStateBuilder builder) {
  builder.activeTab = action.payload;
}

void todosLoaded(
    AppState state, Action<List<Todo>> action, AppStateBuilder builder) {
  builder
    ..isLoading = false
    ..todos.addAll(action.payload);
}

void todosLoadFailed(
    AppState state, Action<Object> action, AppStateBuilder builder) {
  builder
    ..isLoading = false
    ..todos.clear();
}

void updateTodo(AppState state, Action<UpdateTodoActionPayload> action,
    AppStateBuilder builder) {
  builder.todos.map((todo) =>
      todo.id == action.payload.id ? action.payload.updatedTodo : todo);
}
