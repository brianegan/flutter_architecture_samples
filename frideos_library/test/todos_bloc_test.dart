import 'dart:async';

import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'package:frideos_library/models/models.dart';
import 'package:frideos_library/blocs/todos_bloc.dart';

import 'package:frideos/frideos.dart';

class MockRepository extends TodosRepository {
  List<TodoEntity> entities;

  MockRepository(List<Todo> todos)
      : entities = todos.map((it) => it.toEntity()).toList();

  @override
  Future<List<TodoEntity>> loadTodos() {
    return Future.value(entities);
  }

  @override
  Future saveTodos(List<TodoEntity> todos) {
    return Future.sync(() => entities = todos);
  }
}

void main() {
  group('TodosBloc', () {
    test('Add a new todo', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      final todoToAdd = Todo('d');

      todosBloc.addTodo(todoToAdd);

      expect(todosBloc.todosItems.value.contains(todoToAdd), true);
      expect(todosBloc.todosItems.length, 4);
    });

    test('Delete a todo', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      final todoToDelete =
          todosBloc.todosItems.value.firstWhere((todo) => todo.task == 'b');

      todosBloc.deleteTodo(todoToDelete);

      expect(todosBloc.todosItems.value.contains(todoToDelete), false);
      expect(todosBloc.todosItems.length, 2);
    });

    test('Update a todo', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      // Todo to update
      todosBloc.currentTodo.value = todosBloc.todosItems.value[1];

      // Updated todo
      final todoUpdated = Todo('d');

      todosBloc.updateTodo(todoUpdated);
      expect(todosBloc.todosItems.value[1], todoUpdated);
      expect(todosBloc.todosItems.value.contains(todoUpdated), true);
      expect(todosBloc.currentTodo.value, todoUpdated);
      expect(todosBloc.todosItems.length, 3);
    });

    test('Testing addEdit method', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      // Todo adding
      todosBloc.addEdit(false, 'd', 'note');

      expect(todosBloc.todosItems.value.firstWhere((todo) => todo.task == 'd'),
          isNotNull);
      expect(todosBloc.todosItems.length, 4);

      // Todo editing
      todosBloc.currentTodo.value =
          todosBloc.todosItems.value.firstWhere((todo) => todo.task == 'd');
      todosBloc.addEdit(true, 'e', 'note');

      expect(todosBloc.todosItems.value.firstWhere((todo) => todo.task == 'e'),
          isNotNull);
      expect(todosBloc.todosItems.length, 4);
    });

    test('Change todo complete status', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      // Todo to update
      final todoToUpdate =
          todosBloc.todosItems.value.firstWhere((todo) => todo.task == 'c');

      // Changing complete status
      todosBloc.onCheckboxChanged(todoToUpdate);

      expect(todosBloc.todosItems.value.contains(todoToUpdate), false);
      expect(
          todosBloc.todosItems.value
              .contains(todoToUpdate.copyWith(complete: false)),
          true);
      expect(todosBloc.todosItems.length, 3);
    });

    test('should check if there are completed todos', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      expect(todosBloc.todosItems.value.any((it) => it.complete), true);
    });

    test('should calculate the number of active todos', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      expect(
          todosBloc.todosItems.value
              .where((it) => !it.complete)
              .toList()
              .length,
          2);
    });

    test('should calculate the number of completed todos', () async {
      final todosBloc = TodosBloc(
          repository: MockRepository([
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ]));

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      expect(
          todosBloc.todosItems.value.where((it) => it.complete).toList().length,
          1);
    });

    test('should return all todos if the VisibilityFilter is all', () async {
      final todos = [
        Todo('a'),
        Todo('b'),
        Todo('c', complete: true),
      ];
      final todosBloc = TodosBloc(
        repository: MockRepository(todos),
      );

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      todosBloc.activeFilter.value = VisibilityFilter.all;

      expect(todosBloc.visibleTodos.outStream, emits(todos));
    });

    test('should return active todos if the VisibilityFilter is active',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final todosBloc = TodosBloc(
        repository: MockRepository(todos),
      );

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      todosBloc.activeFilter.value = VisibilityFilter.active;

      expect(
          todosBloc.visibleTodos.outStream,
          emitsThrough([
            todo1,
            todo2,
          ]));
    });

    test('should return completed todos if the VisibilityFilter is completed',
        () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final todosBloc = TodosBloc(
        repository: MockRepository(todos),
      );

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      todosBloc.activeFilter.value = VisibilityFilter.completed;

      expect(todosBloc.visibleTodos.outStream, emitsThrough([todo3]));
    });

    test('should clear the completed todos', () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final todosBloc = TodosBloc(
        repository: MockRepository(todos),
      );

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      todosBloc.clearCompleted();

      expect(todosBloc.todosItems.value, [
        todo1,
        todo2,
      ]);
    });

    test('toggle all as complete or incomplete', () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');
      final todo3 = Todo('c', complete: true);
      final todos = [
        todo1,
        todo2,
        todo3,
      ];
      final todosBloc = TodosBloc(
        repository: MockRepository(todos),
      );

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      // Toggle all complete
      todosBloc.toggleAll();
      expect(todosBloc.todosItems.value.every((t) => t.complete), isTrue);

      // Toggle all incomplete
      todosBloc.toggleAll();
      expect(todosBloc.todosItems.value.every((t) => !t.complete), isTrue);
    });

    test('testing extraAction method', () async {
      final todo1 = Todo('a');
      final todo2 = Todo('b');

      final todos = [
        todo1,
        todo2,
      ];
      final todosBloc = TodosBloc(
        repository: MockRepository(todos),
      );

      final streamedList = StreamedList<Todo>();
      todosBloc.todosSender.setReceiver(streamedList);

      await todosBloc.loadTodos();

      todosBloc.extraAction(ExtraAction.toggleAllComplete);
      expect(todosBloc.todosItems.value.every((t) => t.complete), isTrue);

      todosBloc.extraAction(ExtraAction.clearCompleted);
      expect(todosBloc.todosItems.length, 0);
    });
  });
}
