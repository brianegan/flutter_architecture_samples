import 'package:states_rebuilder_sample/domain/entities/todo.dart';

class Stats {
  final List<Todo> _todos;

  Stats(this._todos);

  int get numActive => _todos.where((todo) => !todo.complete).toList().length;
  int get numCompleted => _todos.where((todo) => todo.complete).toList().length;
}
