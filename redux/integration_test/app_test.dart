import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:redux/redux.dart';
import 'package:redux_sample/app.dart';
import 'package:redux_sample/middleware/store_todos_middleware.dart';
import 'package:redux_sample/models/app_state.dart';
import 'package:redux_sample/reducers/app_state_reducer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      return ReduxApp(
        store: Store<AppState>(
          appReducer,
          initialState: AppState.loading(),
          middleware: createStoreTodosMiddleware(
            LocalStorageRepository(
              localStorage: KeyValueStorage(
                'redux_test_${DateTime.now().toIso8601String()}',
                await SharedPreferences.getInstance(),
              ),
            ),
          ),
        ),
      );
    },
  );
}
