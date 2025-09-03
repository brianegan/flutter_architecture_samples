import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:signals_sample/todo.dart';
import 'package:signals_sample/todo_list_controller.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'todo_list_controller_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TodosRepository>()])
void main() {
  group('$TodoListController', () {
    test('should compute the number of completed todos', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(repository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', true),
        ],
      );
      await controller.init();

      expect(controller.numCompleted.value, 1);
    });

    test('should calculate the number of active todos', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(repository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', true),
        ],
      );
      await controller.init();

      expect(controller.hasActiveTodos.value, isTrue);
      expect(controller.numActive.value, 2);
    });

    test('should return all todos if the VisibilityFilter is all', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(
        filter: VisibilityFilter.all,
        repository: repository,
      );

      when(repository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', true),
        ],
      );

      await controller.init();

      expect(controller.visibleTodos.value, [
        Todo('a', id: '1'),
        Todo('b', id: '2'),
        Todo('c', id: '3', complete: true),
      ]);
    });

    test(
      'should return active todos if the VisibilityFilter is active',
      () async {
        final repository = MockTodosRepository();
        final controller = TodoListController(
          filter: VisibilityFilter.active,
          repository: repository,
        );

        when(repository.loadTodos()).thenAnswer(
          (_) async => [
            TodoEntity('a', '1', '', false),
            TodoEntity('b', '2', '', false),
            TodoEntity('c', '3', '', true),
          ],
        );
        await controller.init();

        expect(controller.visibleTodos.value, [
          Todo('a', id: '1'),
          Todo('b', id: '2'),
        ]);
      },
    );

    test(
      'should return completed todos if the VisibilityFilter is completed',
      () async {
        final repository = MockTodosRepository();
        final controller = TodoListController(
          filter: VisibilityFilter.completed,
          repository: repository,
        );

        when(repository.loadTodos()).thenAnswer(
          (_) async => [
            TodoEntity('a', '1', '', false),
            TodoEntity('b', '2', '', false),
            TodoEntity('c', '3', '', true),
          ],
        );
        await controller.init();

        expect(controller.visibleTodos.value, [
          Todo('c', id: '3', complete: true),
        ]);
      },
    );

    test('should clear the completed todos', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(repository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', true),
        ],
      );

      await controller.init();
      controller.clearCompleted();

      expect(controller.todos.value, [Todo('a', id: '1'), Todo('b', id: '2')]);
      verify(
        repository.saveTodos([
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
        ]),
      );
    });

    test('toggle all as complete or incomplete', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(repository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', true),
        ],
      );

      await controller.init();

      // Toggle all complete
      controller.toggleAll();
      expect(controller.todos.every((t) => t.complete.value), isTrue);
      verify(
        repository.saveTodos([
          TodoEntity('a', '1', '', true),
          TodoEntity('b', '2', '', true),
          TodoEntity('c', '3', '', true),
        ]),
      );

      // Toggle all incomplete
      controller.toggleAll();
      expect(controller.todos.every((t) => !t.complete.value), isTrue);
      verify(
        repository.saveTodos([
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', false),
        ]),
      );
    });

    test('should add a todo', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(
        repository.loadTodos(),
      ).thenAnswer((_) async => [TodoEntity('a', '1', '', false)]);

      await controller.init();
      controller.todos.add(Todo('b', id: '2'));

      expect(controller.todos, [Todo('a', id: '1'), Todo('b', id: '2')]);
      verify(
        repository.saveTodos([
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
        ]),
      );
    });

    test('should remove a todo', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(
        repository.loadTodos(),
      ).thenAnswer((_) async => [TodoEntity('a', '1', '', false)]);

      await controller.init();

      controller.todos.remove(Todo('a', id: '1'));

      expect(controller.todos.value, <Todo>[]);
      verify(repository.saveTodos([]));
    });

    test('should update a todo', () async {
      final repository = MockTodosRepository();
      final controller = TodoListController(repository: repository);

      when(repository.loadTodos()).thenAnswer(
        (_) async => [
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', false),
          TodoEntity('c', '3', '', true),
        ],
      );
      await controller.init();

      controller.todos[1].complete.value = true;

      expect(controller.todos.value, [
        Todo('a', id: '1'),
        Todo('b', id: '2', complete: true),
        Todo('c', id: '3', complete: true),
      ]);
      verify(
        repository.saveTodos([
          TodoEntity('a', '1', '', false),
          TodoEntity('b', '2', '', true),
          TodoEntity('c', '3', '', true),
        ]),
      );
    });
  });
}
