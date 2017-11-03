import 'package:built_collection/built_collection.dart';
import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';
import 'package:built_redux_sample/selectors/selectors.dart';

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

addTodo(AppState state, Action<Todo> action, AppStateBuilder builder) =>
    builder.todos = state.todos.toBuilder()..add(action.payload);

clearCompleted(AppState state, Action<Null> action, AppStateBuilder builder) =>
    builder.todos = state.todos.toBuilder()..where((todo) => !todo.complete);

deleteTodo(AppState state, Action<String> action, AppStateBuilder builder) =>
    builder.todos = state.todos.toBuilder()
      ..where((todo) => todo.id != action.payload);

toggleAll(AppState state, Action<Null> action, AppStateBuilder builder) {
  final allComplete = allCompleteSelector(todosSelector(state));

  return builder.todos = state.todos.toBuilder()
    ..map((todo) => (todo.toBuilder()..complete = !allComplete).build());
}

updateFilter(
  AppState state,
  Action<VisibilityFilter> action,
  AppStateBuilder builder,
) =>
    builder.activeFilter = action.payload;

updateTab(AppState state, Action<AppTab> action, AppStateBuilder builder) =>
    builder.activeTab = action.payload;

todosLoaded(
    AppState state, Action<List<Todo>> action, AppStateBuilder builder) {
  builder
    ..isLoading = false
    ..todos = new ListBuilder<Todo>(action.payload);
}

todosLoadFailed(
    AppState state, Action<Object> action, AppStateBuilder builder) {
  builder
    ..isLoading = false
    ..todos = new ListBuilder<Todo>([]);
}

updateTodo(
  AppState state,
  Action<UpdateTodoActionPayload> action,
  AppStateBuilder builder,
) =>
    builder.todos = state.todos.toBuilder()
      ..map((todo) =>
          todo.id == action.payload.id ? action.payload.updatedTodo : todo);
