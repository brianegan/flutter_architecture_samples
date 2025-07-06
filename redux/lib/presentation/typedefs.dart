import 'package:redux_sample/models/models.dart';

typedef TodoAdder = void Function(Todo todo);

typedef TodoRemover = void Function(String id);

typedef TodoUpdater = void Function(String id, Todo todo);
