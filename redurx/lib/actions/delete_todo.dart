import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/models/app_state.dart';

class DeleteTodo implements Action<AppState> {
  final String id;

  DeleteTodo(this.id);

  @override
  AppState reduce(AppState state) {
    final todos = state.todos.rebuild((b) => b..where((todo) => todo.id != id));
    return state.rebuild((b) => b..todos = todos.toBuilder());
  }
}
