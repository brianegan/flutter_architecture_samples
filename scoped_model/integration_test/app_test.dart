import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:scoped_model_sample/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      return ScopedModelApp(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'scoped_model_test_${DateTime.now().toIso8601String()}',
            await SharedPreferences.getInstance(),
          ),
        ),
      );
    },
  );
}
