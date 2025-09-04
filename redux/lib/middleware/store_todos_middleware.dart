import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

List<Middleware<AppState>> createStoreTodosMiddleware(
  TodosRepository repository,
) {
  final saveTodos = _createSaveTodos(repository);
  final loadTodos = _createLoadTodos(repository);

  return [
    TypedMiddleware<AppState, LoadTodosAction>(loadTodos).call,
    TypedMiddleware<AppState, AddTodoAction>(saveTodos).call,
    TypedMiddleware<AppState, ClearCompletedAction>(saveTodos).call,
    TypedMiddleware<AppState, ToggleAllAction>(saveTodos).call,
    TypedMiddleware<AppState, UpdateTodoAction>(saveTodos).call,
    TypedMiddleware<AppState, TodosLoadedAction>(saveTodos).call,
    TypedMiddleware<AppState, DeleteTodoAction>(saveTodos).call,
  ];
}

Middleware<AppState> _createSaveTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    repository.saveTodos(
      todosSelector(store.state).map((todo) => todo.toEntity()).toList(),
    );
  };
}

Middleware<AppState> _createLoadTodos(TodosRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository
        .loadTodos()
        .then((todos) {
          store.dispatch(
            TodosLoadedAction(todos.map(Todo.fromEntity).toList()),
          );
        })
        .catchError((_) {
          store.dispatch(TodosNotLoadedAction());
        });

    next(action);
  };
}
