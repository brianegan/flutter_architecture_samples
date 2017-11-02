import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/data/todos_service.dart';
import 'package:built_redux_sample/data_model/models.dart';
import 'package:built_redux_sample/redux/actions.dart';

Middleware<AppState, AppStateBuilder, AppActions> createStoreTodosMiddleware(
        TodosService service) =>
    (new MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
          ..add(AppActionsNames.fetchTodosAction, createFetchTodos(service))
          ..add(AppActionsNames.addTodoAction, createSaveTodos<Todo>(service))
          ..add(AppActionsNames.clearCompletedAction,
              createSaveTodos<Null>(service))
          ..add(AppActionsNames.deleteTodoAction,
              createSaveTodos<String>(service))
          ..add(AppActionsNames.toggleAllAction, createSaveTodos<Null>(service))
          ..add(AppActionsNames.updateTodoAction,
              createSaveTodos<UpdateTodoActionPayload>(service)))
        .build();

MiddlewareHandler<AppState, AppStateBuilder, AppActions, Null> createFetchTodos(
    TodosService service) {
  return (MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
      ActionHandler next, Action<Null> action) {
    service
        .loadTodos()
        .then(api.actions.loadTodosSuccess)
        .catchError(api.actions.loadTodosFailure);

    next(action);
  };
}

MiddlewareHandler<AppState, AppStateBuilder, AppActions, T> createSaveTodos<T>(
    TodosService service) {
  return (MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
      ActionHandler next, Action<T> action) {
    next(action);

    service.saveTodos(api.state.todos.toList());
  };
}
