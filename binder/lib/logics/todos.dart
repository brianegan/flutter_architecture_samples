import 'package:binder/binder.dart';
import 'package:binder_sample/models.dart';
import 'package:binder_sample/refs.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

final todosLogicRef = LogicRef((scope) => TodosLogic(scope));
final todosRef = StateRef(const <Todo>[]);
final isLoadedRef = StateRef(false);

class TodosLogic with Logic {
  const TodosLogic(this.scope);

  @override
  final Scope scope;

  TodosRepository get _todosRepository => use(todosRepositoryRef);

  List<Todo> get todos => read(todosRef);
  set todos(List<Todo> value) => write(todosRef, value);

  Future<void> init() async {
    final entities = await _todosRepository.loadTodos();
    todos = entities.map((entity) => Todo.fromEntity(entity)).toList();
    write(isLoadedRef, true);
  }

  Future<void> add(Todo todo) {
    todos = [...todos, todo];
    return _save();
  }

  Future<void> delete(Todo todo) {
    todos = todos.where((t) => t.id != todo.id).toList();
    return _save();
  }

  Future<void> edit(Todo todo) {
    todos = todos.map((t) => t.id == todo.id ? todo : t).toList();
    return _save();
  }

  Future<void> _save() {
    final entities = todos.map((todo) => todo.toEntity()).toList();
    return _todosRepository.saveTodos(entities);
  }
}
