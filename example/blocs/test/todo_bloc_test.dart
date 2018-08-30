import 'dart:async';

import 'package:blocs/blocs.dart';
import 'package:blocs/src/models/models.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('TodoBloc', () {
    test('should get the todo from the interactor', () {
      final interactor = MockTodosInteractor();
      final bloc = TodoBloc(interactor);
      final todo = Todo('Hallo');

      when(interactor.todo('2')).thenAnswer((_) => Stream.fromIterable([todo]));

      expect(bloc.todo('2'), emits(todo));
    });

    test('should send deletions to the repo', () async {
      final interactor = MockTodosInteractor();

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([[]]));
      when(interactor.deleteTodo('1')).thenAnswer((_) => Future.value());

      final bloc = TodoBloc(interactor);
      bloc.deleteTodo.add('1');

      verify(interactor.deleteTodo('1'));
    });

    test('should send updates to the repo', () async {
      final interactor = MockTodosInteractor();
      final update = Todo('Waaaat');

      when(interactor.todos).thenAnswer((_) => Stream.empty());
      when(interactor.updateTodo(update)).thenAnswer((_) => Future.value());

      final bloc = TodoBloc(interactor);
      bloc.updateTodo.add(update);

      verify(interactor.updateTodo(update));
    });
  });
}
