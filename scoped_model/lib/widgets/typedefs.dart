import 'package:scoped_model_sample/models.dart';

typedef TodoAdder = void Function(Todo todo);

typedef TodoRemover = void Function(Todo todo);

typedef TodoUpdater =
    void Function(
      Todo todo, {
      bool complete,
      String id,
      String note,
      String task,
    });
