import 'package:redux/redux.dart';
import 'package:redux_sample/actions/actions.dart';
import 'package:redux_sample/data/todos_service.dart';
import 'package:redux_sample/models/models.dart';
import 'package:redux_sample/selectors/selectors.dart';
import 'package:redux_sample/utils.dart';

List<Middleware<AppState>> createStoreTodosMiddleware([
  TodosService service = const TodosService(),
]) {
  final saveTodos = _createSaveTodos(service);
  final loadTodos = _createLoadTodos(service);

  return combineTypedMiddleware([
    new MiddlewareBinder<AppState, LoadTodosAction>(loadTodos),
    new MiddlewareBinder<AppState, AddTodoAction>(saveTodos),
    new MiddlewareBinder<AppState, ClearCompletedAction>(saveTodos),
    new MiddlewareBinder<AppState, ToggleAllAction>(saveTodos),
    new MiddlewareBinder<AppState, UpdateTodoAction>(saveTodos),
    new MiddlewareBinder<AppState, TodosLoadedAction>(saveTodos),
  ]);
}

Middleware<AppState> _createSaveTodos(TodosService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    service.saveTodos(todosSelector(store.state));
  };
}

Middleware<AppState> _createLoadTodos(TodosService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service
        .loadTodos()
        .then((todos) => store.dispatch(new TodosLoadedAction(todos)))
        .catchError((_) => store.dispatch(new TodosNotLoadedAction()));

    next(action);
  };
}
