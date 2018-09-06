import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/actions/fetch_todos.dart';
import 'package:redurx_sample/data/todos_repository.dart';
import 'package:redurx_sample/models/app_state.dart';

class TodosMiddleware extends Middleware<AppState> {
  final TodosRepository todosRepository;

  TodosMiddleware(this.todosRepository);

  @override
  AppState beforeAction(ActionType action, AppState state) {
    if (action is FetchTodos) {
      action.todosRepository = todosRepository;
    }

    return state;
  }
}
