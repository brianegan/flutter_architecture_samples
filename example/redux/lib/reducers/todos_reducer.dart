import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';

final todosReducer = combineTypedReducers<List<Todo>>([
  new ReducerBinding<List<Todo>, AddTodoAction>(_addTodo),
  new ReducerBinding<List<Todo>, DeleteTodoAction>(_deleteTodo),
  new ReducerBinding<List<Todo>, UpdateTodoAction>(_updateTodo),
  new ReducerBinding<List<Todo>, ClearCompletedAction>(_clearCompleted),
  new ReducerBinding<List<Todo>, ToggleAllAction>(_toggleAll),
  new ReducerBinding<List<Todo>, TodosLoadedAction>(_setLoadedTodos),
  new ReducerBinding<List<Todo>, TodosNotLoadedAction>(_setNoTodos),
]);

List<Todo> _addTodo(List<Todo> todos, AddTodoAction action) {
  return new List.from(todos)..add(action.todo);
}

List<Todo> _deleteTodo(List<Todo> todos, DeleteTodoAction action) {
  return todos.where((todo) => todo.id != action.id).toList();
}

List<Todo> _updateTodo(List<Todo> todos, UpdateTodoAction action) {
  return todos
      .map((todo) => todo.id == action.id ? action.updatedTodo : todo)
      .toList();
}

List<Todo> _clearCompleted(List<Todo> todos, ClearCompletedAction action) {
  return todos.where((todo) => !todo.complete).toList();
}

List<Todo> _toggleAll(List<Todo> todos, ToggleAllAction action) {
  final allComplete = allCompleteSelector(todos);

  return todos.map((todo) => todo.copyWith(complete: !allComplete)).toList();
}

List<Todo> _setLoadedTodos(List<Todo> todos, TodosLoadedAction action) {
  return action.todos;
}

List<Todo> _setNoTodos(List<Todo> todos, TodosNotLoadedAction action) {
  return [];
}
