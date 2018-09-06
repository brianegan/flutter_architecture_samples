import 'package:redurx_sample/models/todo.dart';

typedef TodoAdder(Todo todo);

typedef TodoRemover(Todo todo);

typedef TodoUpdater(
  Todo todo, {
  bool complete,
  String id,
  String note,
  String task,
});
