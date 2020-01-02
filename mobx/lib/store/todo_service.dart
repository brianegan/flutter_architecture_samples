import 'package:mobx_sample/store/todo.dart';

class TodoService {
  Future<List<Todo>> load() async {
    await Future.delayed(Duration(milliseconds: 1000));

    return [
      Todo(title: 'Do this first'),
      Todo(title: 'Then do this'),
      Todo(title: 'And then this one too'),
    ];
  }
}
