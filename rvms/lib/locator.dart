import 'package:get_it/get_it.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_.dart';
import 'package:rvms_model_sample/display_todos/_manager/todo_manager_implementation.dart';
import 'package:rvms_model_sample/display_todos/_services/repository_service_.dart';
import 'package:rvms_model_sample/display_todos/_services/repository_service_impl.dart';

final locator = GetIt.instance;

void initLocator() {
  locator
      .registerSingleton<RepositoryService>(RepositoryServiceImplementation());
  locator.registerSingletonAsync<TodoManager>(() async {
    final manager = TodoManagerImplementation();
    await manager.loadTodos();
    return manager;
  });
}
