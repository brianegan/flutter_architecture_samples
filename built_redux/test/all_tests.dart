import 'app_state_test.dart' as appState;
import 'file_storage_test.dart' as fileStorage;
import 'middleware_test.dart' as middleware;
import 'reducer_test.dart' as reducer;
import 'todos_repository_test.dart' as todosRepository;

main() {
  appState.main();
  fileStorage.main();
  middleware.main();
  reducer.main();
  todosRepository.main();
}
