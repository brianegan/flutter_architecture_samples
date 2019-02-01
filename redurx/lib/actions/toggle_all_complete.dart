import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/models/app_state.dart';
import 'package:redurx_sample/models/todo.dart';

class ToggleAllComplete implements Action<AppState> {
  @override
  AppState reduce(AppState state) {
    final todos = state.todos.rebuild((b) => b..map(_complete));
    return state.rebuild((b) => b..todos = todos.toBuilder());
  }

  Todo _complete(Todo todo) => todo.rebuild((b) => b..complete = true);
}
