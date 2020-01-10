// Provides a Mock repository that can be used for testing in place of the real
// thing.
import 'package:change_notifier_provider_sample/models.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;
  int saveCount = 0;

  MockRepository([List<Todo> todos = const []])
      : entities = todos.map((it) => it.toEntity()).toList();

  @override
  Future<List<TodoEntity>> loadTodos() async => entities;

  @override
  Future saveTodos(List<TodoEntity> todos) async {
    saveCount++;
    entities = todos;
  }
}
