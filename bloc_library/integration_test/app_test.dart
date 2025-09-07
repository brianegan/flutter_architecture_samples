import 'package:bloc_library/app.dart';
import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      return TodosApp(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'bloc_library_test_${DateTime.now().toIso8601String()}',
            await SharedPreferences.getInstance(),
          ),
        ),
      );
    },
  );
}
