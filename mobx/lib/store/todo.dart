import 'package:mobx/mobx.dart';

part 'todo.g.dart';

class Todo = _Todo with _$Todo;

int _idCounter = 0;

_nextId() => _idCounter++;

abstract class _Todo with Store {
  final String id = 't-${_nextId()}';

  _Todo({this.title = '', this.notes = null});

  @observable
  String title;

  @observable
  String notes;

  @observable
  bool done = false;

  @computed
  bool get hasTitle => title != null && title.trim().isNotEmpty;

  @computed
  bool get hasNotes => notes != null && notes.trim().isNotEmpty;

  Todo clone() {
    final Todo todo = Todo(title: title, notes: notes);
    todo.done = done;

    return todo;
  }

  @action
  copyFrom(Todo todo) {
    title = todo.title;
    notes = todo.notes;
    done = todo.done;
  }
}
