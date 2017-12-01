import 'package:scoped_model_sample/models.dart';

typedef TodoAdder(TodoModel todo);

typedef TodoRemover(TodoModel todo);

typedef TodoUpdater(
  TodoModel todo, {
  bool complete,
  String id,
  String note,
  String task,
});
