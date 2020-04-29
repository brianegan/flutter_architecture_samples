import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/common/enums.dart';
import 'package:states_rebuilder_sample/service/exceptions/persistance_exception.dart';
import 'package:states_rebuilder_sample/service/interfaces/i_todo_repository.dart';
import 'package:states_rebuilder_sample/service/todos_state.dart';

import 'fake_repository.dart';

//TodoService class is a pure dart class, you can test it just as you test a plain dart class.
void main() {
  group(
    'TodosState',
    () {
      ITodosRepository todosRepository;
      TodosState todosState;
      setUp(
        () {
          todosRepository = FakeRepository();
          todosState = TodosState(
            todos: [],
            activeFilter: VisibilityFilter.all,
            todoRepository: todosRepository,
          );
        },
      );

      test(
        'should load todos works',
        () async {
          final todosNewState = await todosState.loadTodos();
          expect(todosNewState.todos.length, equals(3));
        },
      );

      test(
        'should filler todos works',
        () async {
          var todosNewState = await todosState.loadTodos();
          //all todos
          expect(todosNewState.todos.length, equals(3));
          //active todos
          todosNewState =
              todosNewState.copyWith(activeFilter: VisibilityFilter.active);
          expect(todosNewState.todos.length, equals(2));
          //completed todos
          todosNewState =
              todosNewState.copyWith(activeFilter: VisibilityFilter.completed);
          expect(todosNewState.todos.length, equals(1));
        },
      );

      test(
        'should add todo works',
        () async {
          var startingTodosState = await todosState.loadTodos();

          final todoToAdd = Todo('addTask');
          final expectedTodosState = startingTodosState.copyWith(
            todos: List<Todo>.from(startingTodosState.todos)..add(todoToAdd),
          );

          expect(
            startingTodosState.addTodo(todoToAdd),
            emitsInOrder([expectedTodosState, emitsDone]),
          );
        },
      );

      test(
        'should add todo and remove it on error',
        () async {
          var startingTodosState = await todosState.loadTodos();

          final todoToAdd = Todo('addTask');

          (todosRepository as FakeRepository).throwError = true;
          final expectedTodosState = startingTodosState.copyWith(
            todos: List<Todo>.from(startingTodosState.todos)..add(todoToAdd),
          );

          expect(
            startingTodosState.addTodo(todoToAdd),
            emitsInOrder([
              expectedTodosState,
              startingTodosState,
              emitsError(isA<PersistanceException>()),
              emitsDone,
            ]),
          );
        },
      );

      test(
        'should update todo works',
        () async {
          var startingTodosState = await todosState.loadTodos();

          final updatedTodo =
              startingTodosState.todos.first.copyWith(task: 'updated task');

          final expectedTodos = List<Todo>.from(startingTodosState.todos);
          expectedTodos[0] = updatedTodo;
          final expectedTodosState = startingTodosState.copyWith(
            todos: expectedTodos,
          );

          expect(
            startingTodosState.updateTodo(updatedTodo),
            emitsInOrder([expectedTodosState, emitsDone]),
          );
        },
      );

      test(
        'should delete todo works',
        () async {
          var startingTodosState = await todosState.loadTodos();

          final expectedTodosState = startingTodosState.copyWith(
            todos: List<Todo>.from(startingTodosState.todos)..removeLast(),
          );

          expect(
            startingTodosState.deleteTodo(startingTodosState.todos.last),
            emitsInOrder([expectedTodosState, emitsDone]),
          );
        },
      );

      test(
        'should toggleAll todos works',
        () async {
          var startingTodosState = await todosState.loadTodos();

          expect(startingTodosState.numActive, equals(2));
          expect(startingTodosState.numCompleted, equals(1));

          var expectedTodosState = startingTodosState.copyWith(
              todos: startingTodosState.todos
                  .map(
                    (t) =>
                        t.copyWith(complete: !startingTodosState.allComplete),
                  )
                  .toList());

          expect(
            startingTodosState.toggleAll(),
            emitsInOrder([expectedTodosState, emitsDone]),
          );
          expect(expectedTodosState.numActive, equals(0));
          expect(expectedTodosState.numCompleted, equals(3));
        },
      );

      test(
        'should clearCompleted todos works',
        () async {
          var startingTodosState = await todosState.loadTodos();

          expect(startingTodosState.numActive, equals(2));
          expect(startingTodosState.numCompleted, equals(1));

          var expectedTodosState = startingTodosState.copyWith(
              todos: startingTodosState.todos
                  .where(
                    (t) => !t.complete,
                  )
                  .toList());

          expect(
            startingTodosState.clearCompleted(),
            emitsInOrder([expectedTodosState, emitsDone]),
          );
        },
      );
    },
  );
}
