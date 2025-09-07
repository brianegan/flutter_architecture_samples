import 'package:inherited_widget_sample/app.dart';
import 'package:inherited_widget_sample/state_container.dart';
import 'package:integration_tests/integration_tests.dart' as integration_tests;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todos_repository_local_storage/todos_repository_local_storage.dart';

void main() {
  integration_tests.run(
    appBuilder: () async {
      return StateContainer(
        repository: LocalStorageRepository(
          localStorage: KeyValueStorage(
            'inherited_widget_todos_test_${DateTime.now().toIso8601String()}',
            await SharedPreferences.getInstance(),
          ),
        ),
        child: const InheritedWidgetApp(),
      );
    },
  );
}
