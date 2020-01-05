// Provides a Mock repository that can be used for testing in place of the real
// thing.
import 'package:todos_repository_core/todos_repository_core.dart';

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;
  int saveCount = 0;

  MockRepository([this.entities = const <TodoEntity>[]]);

  @override
  Future<List<TodoEntity>> loadTodos() async => entities;

  @override
  Future<void> saveTodos(List<TodoEntity> update) async {
    saveCount++;
    entities = update;
  }
}
