import 'package:mobx/mobx.dart';

part 'todo_stores.g.dart';

class Todo = _Todo with _$Todo;

int _idCounter = 0;
_nextId() => _idCounter++;

abstract class _Todo implements Store {
  final String id = 't-${_nextId()}';
  _Todo({this.title = '', this.notes});

  @observable
  String title;

  @observable
  String notes;

  @observable
  bool done = false;

  @action
  void markDone(bool flag) {
    done = flag;
  }

  @action
  setTitle(String value) => title = value;

  @action
  setNotes(String value) => notes = value;
}

class TodoList = _TodoList with _$TodoList;

abstract class _TodoList implements Store {
  _TodoList() {
    _setup();
  }

  @observable
  ObservableFuture<void> loader;

  Function _undoOperation;

  final ObservableList<Todo> todos = ObservableList();

  @action
  void addTodo(Todo todo) {
    todos.add(todo);
  }

  @action
  void removeTodo(Todo todo) {
    todos.remove(todo);

    _undoOperation = () {
      addTodo(todo);
    };
  }

  applyUndo() {
    if (_undoOperation == null) return;

    _undoOperation();
  }

  @action
  Future<void> _loadTodos() async {
    await Future.delayed(Duration(seconds: 2));

    todos.addAll([
      Todo(title: 'Do this first'),
      Todo(title: 'Then do this'),
      Todo(title: 'And then this one too'),
    ]);
  }

  void _setup() {
    loader = ObservableFuture(_loadTodos());
  }
}
