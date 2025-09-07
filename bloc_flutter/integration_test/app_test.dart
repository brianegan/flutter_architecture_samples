import 'package:bloc_flutter_sample/anonymous_user_repository.dart';
import 'package:bloc_flutter_sample/app.dart';
import 'package:blocs/blocs.dart';
import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      return BlocApp(
        todosInteractor: TodosInteractor(
          ReactiveLocalStorageRepository(
            repository: LocalStorageRepository(
              localStorage: KeyValueStorage(
                'simple_bloc_test_${DateTime.now().toIso8601String()}',
                await SharedPreferences.getInstance(),
              ),
            ),
          ),
        ),
        userRepository: AnonymousUserRepository(),
      );
    },
  );
}
