import 'package:get_it/get_it.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_implementation.dart';

void initLocator() {
  GetIt.I.registerSingletonAsync<TodoManager>(() async {
    final manager = TodoManagerImplementation();
    await manager.loadTodos();
    return manager;
  });
}
