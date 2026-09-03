import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';

import 'todo.dart';
import 'todo_codec.dart';
import 'todo_list_state.dart';

final todoListViewModelSpec =
    ViewModelSpec.arg<TodoListViewModel, TodosRepository>(
      builder: TodoListViewModel.new,
      key: (repository) => repository,
    );

class TodoListViewModel extends StateViewModel<TodoListState> {
  TodoListViewModel(this._repository, {TodoCodec codec = const TodoCodec()})
    : _codec = codec,
      super(state: const TodoListState());

  final TodoCodec _codec;
  final TodosRepository _repository;
  Future<void>? _initializingFuture;

  Future<void> initialize() {
    return _initializingFuture ??= _loadTodos();
  }

  Todo? todoById(String id) => state.todoById(id);

  Future<void> _loadTodos() async {
    setState(state.copyWith(isLoading: true));
    final entities = await _repository.loadTodos();
    setState(
      state.copyWith(
        isLoading: false,
        todos: entities.map(_codec.decode).toList(growable: false),
      ),
    );
  }

  void setFilter(VisibilityFilter filter) {
    setState(state.copyWith(filter: filter));
  }

  Future<void> addTodo(Todo todo) {
    return _replaceTodos([...state.todos, todo]);
  }

  Future<void> removeTodo(String id) {
    return _replaceTodos(
      state.todos.where((todo) => todo.id != id).toList(growable: false),
    );
  }

  Future<void> updateTodo(Todo updatedTodo) {
    return _replaceTodos([
      for (final todo in state.todos)
        if (todo.id == updatedTodo.id) updatedTodo else todo,
    ]);
  }

  Future<void> setTodoComplete(String id, bool complete) {
    final todo = todoById(id);
    if (todo == null) return Future<void>.value();
    return updateTodo(todo.copyWith(complete: complete));
  }

  Future<void> toggleAll() {
    final allComplete = state.todos.every((todo) => todo.complete);
    return _replaceTodos([
      for (final todo in state.todos) todo.copyWith(complete: !allComplete),
    ]);
  }

  Future<void> clearCompleted() {
    return _replaceTodos(
      state.todos.where((todo) => !todo.complete).toList(growable: false),
    );
  }

  Future<void> _replaceTodos(List<Todo> todos) async {
    setState(state.copyWith(todos: todos));
    await _repository.saveTodos(
      state.todos.map(_codec.encode).toList(growable: false),
    );
  }
}
