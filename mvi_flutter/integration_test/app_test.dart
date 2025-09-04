import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/anonymous_user_repository.dart';
import 'package:mvi_flutter_sample/mvi_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      return MviApp(
        todoListInteractor: TodoListInteractor(
          ReactiveLocalStorageRepository(
            repository: LocalStorageRepository(
              localStorage: KeyValueStorage(
                'mvi_flutter_test_${DateTime.now().toIso8601String()}',
                await SharedPreferences.getInstance(),
              ),
            ),
          ),
        ),
        userInteractor: UserInteractor(AnonymousUserRepository()),
      );
    },
  );
}
