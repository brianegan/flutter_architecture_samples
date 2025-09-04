import 'dart:async';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:test/test.dart';

import 'mvi_todo_test.mocks.dart';

class MockDetailView extends Mock with DetailView {}

@GenerateNiceMocks([MockSpec<TodoListInteractor>()])
void main() {
  group('MviTodo', () {
    group('Presenter', () {
      test('should load a todo', () {
        final interactor = MockTodoListInteractor();
        final todo = Todo('Hallo');

        when(
          interactor.todo(todo.id),
        ).thenAnswer((_) => Stream.fromIterable([todo]));

        final presenter = DetailPresenter(
          id: todo.id,
          view: MockDetailView(),
          interactor: interactor,
        );

        expect(presenter, emits(todo));
      });

      test('should send deletions to the interactor', () async {
        final interactor = MockTodoListInteractor();
        final todo = Todo('Hallo');
        final view = MockDetailView();

        when(
          interactor.todo(todo.id),
        ).thenAnswer((_) => Stream.fromIterable([todo]));

        when(interactor.deleteTodo(todo.id)).thenAnswer((_) => Future.value());

        final presenter = DetailPresenter(
          id: todo.id,
          view: view,
          interactor: interactor,
        );
        presenter.setUp();
        view.deleteTodo.add(todo.id);

        verify(interactor.deleteTodo(todo.id));
      });

      test('should send updates to the interactor', () async {
        final interactor = MockTodoListInteractor();
        final todo = Todo('Hallo');
        final view = MockDetailView();

        when(
          interactor.todo(todo.id),
        ).thenAnswer((_) => Stream.fromIterable([todo]));

        final presenter = DetailPresenter(
          id: todo.id,
          view: view,
          interactor: interactor,
        );
        presenter.setUp();
        view.updateTodo.add(todo);

        verify(interactor.updateTodo(todo));
      });
    });

    group('View', () {
      test('should clean up after itself', () async {
        final view = MockDetailView();

        view.tearDown();

        expect(view.deleteTodo.isClosed, isTrue);
        expect(view.updateTodo.isClosed, isTrue);
      });
    });
  });
}
