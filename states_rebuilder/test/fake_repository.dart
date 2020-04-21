import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/exceptions/persistance_exception.dart';
import 'package:states_rebuilder_sample/service/interfaces/i_todo_repository.dart';

class FakeRepository implements ITodosRepository {
  @override
  Future<List<Todo>> loadTodos() async {
    await Future.delayed(Duration(milliseconds: 20));
    return [
      Todo(
        'Task1',
        id: '1',
        note: 'Note1',
      ),
      Todo(
        'Task2',
        id: '2',
        note: 'Note2',
        complete: false,
      ),
      Todo(
        'Task3',
        id: '3',
        note: 'Note3',
        complete: true,
      ),
    ];
  }

  bool throwError = false;
  bool isSaved = false;
  @override
  Future saveTodos(List<Todo> todos) async {
    await Future.delayed(Duration(milliseconds: 50));
    if (throwError) {
      throw PersistanceException('There is a problem in saving todos');
    }
    isSaved = true;
    return true;
  }
}
