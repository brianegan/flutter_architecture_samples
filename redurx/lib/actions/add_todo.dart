import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/todo.dart';

class AddTodo implements Action<AppState> {
  final Todo todo;

  AddTodo(this.todo);

  @override
  AppState reduce(AppState state) {
    final todos = state.todos.rebuild((b) => b..add(todo));
    return state.rebuild((b) => b..todos = todos.toBuilder());
  }
}
