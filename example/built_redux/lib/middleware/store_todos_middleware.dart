import 'package:built_redux/built_redux.dart';
import 'package:built_redux_sample/data/todos_repository.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_redux_sample/actions/actions.dart';

Middleware<AppState, AppStateBuilder, AppActions> createStoreTodosMiddleware([
  TodosRepository service = const TodosRepository(),
]) {
  return (new MiddlewareBuilder<AppState, AppStateBuilder, AppActions>()
        ..add(AppActionsNames.fetchTodosAction, createFetchTodos(service))
        ..add(AppActionsNames.addTodoAction, createSaveTodos<Todo>(service))
        ..add(AppActionsNames.clearCompletedAction,
            createSaveTodos<Null>(service))
        ..add(
            AppActionsNames.deleteTodoAction, createSaveTodos<String>(service))
        ..add(AppActionsNames.toggleAllAction, createSaveTodos<Null>(service))
        ..add(AppActionsNames.updateTodoAction,
            createSaveTodos<UpdateTodoActionPayload>(service)))
      .build();
}

MiddlewareHandler<AppState, AppStateBuilder, AppActions, Null> createFetchTodos(
    TodosRepository service) {
  return (MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
      ActionHandler next, Action<Null> action) {
    if (api.state.isLoading) {
      service
          .loadTodos()
          .then(api.actions.loadTodosSuccess)
          .catchError(api.actions.loadTodosFailure);
    }

    next(action);
  };
}

MiddlewareHandler<AppState, AppStateBuilder, AppActions, T> createSaveTodos<T>(
    TodosRepository service) {
  return (MiddlewareApi<AppState, AppStateBuilder, AppActions> api,
      ActionHandler next, Action<T> action) {
    next(action);

    service.saveTodos(api.state.todos.toList());
  };
}
