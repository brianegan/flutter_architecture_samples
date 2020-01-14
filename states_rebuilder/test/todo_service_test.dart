import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/common/enums.dart';
import 'package:states_rebuilder_sample/service/interfaces/i_todo_repository.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';

import 'fake_repository.dart';

//TodoService class is a pure dart class, you can test it just as you test a plain dart class.
void main() {
  group(
    'TodosService',
    () {
      ITodosRepository todosRepository;
      TodosService todoService;
      setUp(
        () {
          todosRepository = FakeRepository();
          todoService = TodosService(todosRepository);
        },
      );

      test(
        'should load todos works',
        () async {
          expect(todoService.todos.isEmpty, isTrue);
          await todoService.loadTodos();
          expect(todoService.todos.length, equals(2));
        },
      );

      test(
        'should filler todos works',
        () async {
          await todoService.loadTodos();
          //all todos
          expect(todoService.todos.length, equals(2));
          //active todos
          todoService.activeFilter = VisibilityFilter.active;
          expect(todoService.todos.length, equals(1));
          //completed todos
          todoService.activeFilter = VisibilityFilter.completed;
          expect(todoService.todos.length, equals(1));
        },
      );

      test(
        'should add todo works',
        () async {
          await todoService.loadTodos();
          expect(todoService.todos.length, equals(2));
          final todoToAdd = Todo('addTask');
          await todoService.addTodo(todoToAdd);
          expect(todoService.todos.length, equals(3));
          expect(await (todosRepository as FakeRepository).isSaved, isTrue);
        },
      );

      test(
        'should update todo works',
        () async {
          await todoService.loadTodos();
          final beforeUpdate =
              todoService.todos.firstWhere((todo) => todo.id == '1');
          expect(beforeUpdate.task, equals('task1'));
          await todoService.updateTodo(Todo('updateTodo', id: '1'));
          expect(await (todosRepository as FakeRepository).isSaved, isTrue);
          final afterUpdate =
              todoService.todos.firstWhere((todo) => todo.id == '1');
          expect(afterUpdate.task, equals('updateTodo'));
        },
      );

      test(
        'should delete todo works',
        () async {
          await todoService.loadTodos();
          expect(todoService.todos.length, equals(2));
          await todoService.deleteTodo(Todo('updateTodo', id: '1'));
          expect(await (todosRepository as FakeRepository).isSaved, isTrue);
          expect(todoService.todos.length, equals(1));
        },
      );

      test(
        'should toggleAll todos works',
        () async {
          await todoService.loadTodos();
          expect(todoService.numActive, equals(1));
          expect(todoService.numCompleted, equals(1));

          await todoService.toggleAll();
          expect(await (todosRepository as FakeRepository).isSaved, isTrue);
          expect(todoService.numActive, equals(0));
          expect(todoService.numCompleted, equals(2));

          await todoService.toggleAll();
          expect(todoService.numActive, equals(2));
          expect(todoService.numCompleted, equals(0));
        },
      );

      test(
        'should clearCompleted todos works',
        () async {
          await todoService.loadTodos();
          expect(todoService.numActive, equals(1));
          expect(todoService.numCompleted, equals(1));

          await todoService.clearCompleted();
          expect(await (todosRepository as FakeRepository).isSaved, isTrue);
          expect(todoService.todos.length, equals(1));
          expect(todoService.numActive, equals(1));
          expect(todoService.numCompleted, equals(0));
        },
      );
    },
  );
}
