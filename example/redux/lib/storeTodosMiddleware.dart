import 'package:redux/redux.dart';
import 'package:redux_sample/data/todos_service.dart';
import 'package:redux_sample/models.dart';


Middleware<AppState> createStoreTodosMiddleware(TodosService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    next(action);

    service.saveTodos(store.state.todos);
  };
}

