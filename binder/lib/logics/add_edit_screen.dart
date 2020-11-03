import 'package:binder/binder.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';

final addEditScreenLogicRef = LogicRef((scope) => AddEditScreenLogic(scope));

final taskRef = StateRef('');
final noteRef = StateRef('');

final taskIsValidRef = Computed((watch) => watch(taskRef).trim().isNotEmpty);
final canBeSubmittedRef = Computed((watch) => watch(taskIsValidRef));

class AddEditScreenLogic with Logic {
  const AddEditScreenLogic(this.scope);

  @override
  final Scope scope;

  TodosLogic get _todosLogic => use(todosLogicRef);

  String get task => read(taskRef);
  set task(String value) => write(taskRef, value);

  String get note => read(noteRef);
  set note(String value) => write(noteRef, value);

  Future<void> put(Todo todo) {
    if (todo != null) {
      return _todosLogic.edit(todo.copyWith(task: task, note: note));
    } else {
      return _todosLogic.add(Todo(task, note: note));
    }
  }
}
