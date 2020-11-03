import 'package:binder/binder.dart';
import 'package:binder_sample/logics/todos.dart';
import 'package:binder_sample/models.dart';

final activeFilterRef = StateRef(VisibilityFilter.all);
final homeScreenLogicRef = LogicRef((scope) => HomeScreenLogic(scope));

class HomeScreenLogic with Logic {
  const HomeScreenLogic(this.scope);

  @override
  final Scope scope;

  TodosLogic get _todosLogic => use(todosLogicRef);

  VisibilityFilter get filter => read(activeFilterRef);
  set filter(VisibilityFilter value) => write(activeFilterRef, value);

  Future<void> clearCompleted() {
    final futures = <Future<void>>[];
    read(todosRef).where((todo) => todo.complete).forEach((todo) {
      futures.add(_todosLogic.delete(todo));
    });
    return Future.wait(futures);
  }

  Future<void> toggleAll() {
    final futures = <Future<void>>[];
    final todos = read(todosRef);
    final allComplete = todos.every((todo) => todo.complete);
    todos.map((todo) => todo.copyWith(complete: !allComplete)).forEach((todo) {
      futures.add(_todosLogic.edit(todo));
    });
    return Future.wait(futures);
  }
}
