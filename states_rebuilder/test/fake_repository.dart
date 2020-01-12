import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/interfaces/i_todo_repository.dart';

class FakeRepository implements ITodosRepository {
  @override
  Future<List<Todo>> loadTodos() {
    return Future.value(
      [
        Todo(
          'task1',
          id: '1',
          note: 'note1',
          complete: true,
        ),
        Todo(
          'task2',
          id: '2',
          note: 'note2',
          complete: false,
        ),
      ],
    );
  }

  bool isSaved = false;
  @override
  Future saveTodos(List<Todo> todos) {
    isSaved = true;
    return Future.value(true);
  }
}
