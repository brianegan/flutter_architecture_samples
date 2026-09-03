import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';
import 'package:view_model/view_model.dart';
import 'package:view_model_sample/app.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      ViewModel.reset();
      ViewModel.initialize();
      return ViewModelApp(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'view_model_test_${DateTime.now().toIso8601String()}',
            await SharedPreferences.getInstance(),
          ),
        ),
      );
    },
  );
}
