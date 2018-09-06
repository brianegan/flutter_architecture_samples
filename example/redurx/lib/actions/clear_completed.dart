import 'package:flutter_redurx/flutter_redurx.dart';
import 'package:redurx_sample/models/app_state.dart';

class ClearCompleted implements Action<AppState> {
  @override
  AppState reduce(AppState state) {
    final todos = state.todos.rebuild((b) => b.where((todo) => !todo.complete));
    return state.rebuild((b) => b..todos = todos.toBuilder());
  }
}
