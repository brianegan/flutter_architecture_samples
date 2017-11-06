import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:todos_repository/todos_repository.dart';
import 'package:path_provider/path_provider.dart';

List<Middleware<AppState>> createStoreTodosMiddleware([
  TodosRepository repository = const TodosRepository(
    fileStorage: const FileStorage(
      'redux_sample',
      getApplicationDocumentsDirectory,
    ),
  ),
]) {
  final saveTodos = _createSaveTodos(repository);
  final loadTodos = _createLoadTodos(repository);

  return combineTypedMiddleware([
    new MiddlewareBinding<AppState, LoadTodosAction>(loadTodos),
    new MiddlewareBinding<AppState, AddTodoAction>(saveTodos),
    new MiddlewareBinding<AppState, ClearCompletedAction>(saveTodos),
    new MiddlewareBinding<AppState, ToggleAllAction>(saveTodos),
    new MiddlewareBinding<AppState, UpdateTodoAction>(saveTodos),
    new MiddlewareBinding<AppState, TodosLoadedAction>(saveTodos),
    new MiddlewareBinding<AppState, DeleteTodoAction>(saveTodos),
  ]);
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
    repository.loadTodos().then(
      (todos) {
        store.dispatch(
          new TodosLoadedAction(
            todos.map(Todo.fromEntity).toList(),
          ),
        );
      },
    ).catchError((_) => store.dispatch(new TodosNotLoadedAction()));

    next(action);
  };
}
