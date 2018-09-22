import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/actions/add_todo.dart';
import 'package:redurx_sample/actions/clear_completed.dart';
import 'package:redurx_sample/actions/delete_todo.dart';
import 'package:redurx_sample/actions/fetch_todos.dart';
import 'package:redurx_sample/actions/toggle_all_complete.dart';
import 'package:redurx_sample/actions/update_todo.dart';
import 'package:redurx_sample/data/todos_repository.dart';
import 'package:redurx_sample/models/app_state.dart';

class TodosMiddleware extends Middleware<AppState> {
  final TodosRepository _todosRepository;

  TodosMiddleware(this._todosRepository);

  @override
  AppState beforeAction(ActionType action, AppState state) {
    if (action is FetchTodos) {
      action.todosRepository = _todosRepository;
    }

    return state;
  }

  @override
  AppState afterAction(ActionType action, AppState state) {
    if (action is AddTodo) {
      _todosRepository.saveTodos(state.todos.toList());
    }

    if (action is ClearCompleted) {
      _todosRepository.saveTodos(state.todos.toList());
    }

    if (action is DeleteTodo) {
      _todosRepository.saveTodos(state.todos.toList());
    }

    if (action is ToggleAllComplete) {
      _todosRepository.saveTodos(state.todos.toList());
    }

    if (action is UpdateTodo) {
      _todosRepository.saveTodos(state.todos.toList());
    }

    return state;
  }
}
