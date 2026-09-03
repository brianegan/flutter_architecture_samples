import 'package:flutter_test/flutter_test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:view_model/view_model.dart';
import 'package:view_model_sample/todo.dart';
import 'package:view_model_sample/todo_list_state.dart';
import 'package:view_model_sample/todo_list_view_model.dart';

import 'support/fake_todos_repository.dart';

class _ViewModelOwner with ViewModelBinding {
  _ViewModelOwner(this.repository);

  final FakeTodosRepository repository;

  TodoListViewModel get viewModel =>
      viewModelBinding.read(todoListViewModelSpec(repository));
}

void main() {
  late FakeTodosRepository repository;
  late _ViewModelOwner owner;

  setUp(() {
    ViewModel.reset();
    repository = FakeTodosRepository(
      todos: [
        TodoEntity('Active', '1', 'first', false),
        TodoEntity('Done', '2', 'second', true),
      ],
    );
    owner = _ViewModelOwner(repository);
  });

  tearDown(() {
    owner.dispose();
    ViewModel.reset();
  });

  test('initialize loads repository state once', () async {
    expect(owner.viewModel.state.isLoading, isFalse);

    await owner.viewModel.initialize();
    await owner.viewModel.initialize();

    expect(repository.loadCount, 1);
    expect(owner.viewModel.state.isLoading, isFalse);
    expect(owner.viewModel.state.todos, hasLength(2));
    expect(owner.viewModel.state.todos.first.task, 'Active');
  });

  test('add, edit, complete, and remove persist each change', () async {
    await owner.viewModel.initialize();

    final added = Todo('New', id: '3', note: 'note');
    await owner.viewModel.addTodo(added);
    await owner.viewModel.updateTodo(added.copyWith(task: 'Edited'));
    await owner.viewModel.setTodoComplete('3', true);
    await owner.viewModel.removeTodo('1');

    expect(owner.viewModel.todoById('1'), isNull);
    expect(owner.viewModel.todoById('3')?.task, 'Edited');
    expect(owner.viewModel.todoById('3')?.complete, isTrue);
    expect(repository.savedTodos, hasLength(4));
    expect(repository.savedTodos.last.map((todo) => todo.id), ['2', '3']);
  });

  test(
    'filters, statistics, toggle all, and clear completed stay coherent',
    () async {
      await owner.viewModel.initialize();

      expect(owner.viewModel.state.numActive, 1);
      expect(owner.viewModel.state.numCompleted, 1);

      owner.viewModel.setFilter(VisibilityFilter.active);
      expect(owner.viewModel.state.visibleTodos.map((todo) => todo.id), ['1']);

      owner.viewModel.setFilter(VisibilityFilter.completed);
      expect(owner.viewModel.state.visibleTodos.map((todo) => todo.id), ['2']);

      await owner.viewModel.toggleAll();
      expect(owner.viewModel.state.numActive, 0);
      expect(owner.viewModel.state.numCompleted, 2);

      await owner.viewModel.clearCompleted();
      expect(owner.viewModel.state.todos, isEmpty);
      expect(repository.savedTodos, hasLength(2));
    },
  );

  test('same repository key shares one managed instance across bindings', () {
    final otherOwner = _ViewModelOwner(repository);
    addTearDown(otherOwner.dispose);

    expect(identical(owner.viewModel, otherOwner.viewModel), isTrue);
  });
}
