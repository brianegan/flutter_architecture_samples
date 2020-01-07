import 'app_state_test.dart' as app_state;
import 'file_storage_test.dart' as file_storage;
import 'middleware_test.dart' as middleware;
import 'reducer_test.dart' as reducer;
import 'todos_repository_test.dart' as todos_repository;

void main() {
  app_state.main();
  file_storage.main();
  middleware.main();
  reducer.main();
  todos_repository.main();
}
