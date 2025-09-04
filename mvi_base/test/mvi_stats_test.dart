import 'dart:async';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:test/test.dart';

import 'mvi_stats_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TodoListInteractor>()])
void main() {
  group('MviStats', () {
    test('should stream the number of active and completed todos', () {
      final interactor = MockTodoListInteractor();
      final todos = [
        Todo('Hi', complete: true),
        Todo('There', complete: true),
        Todo('Friend'),
      ];

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));

      final presenter = StatsPresenter(interactor);

      expect(
        presenter,
        emitsThrough(StatsModelLoaded(numActive: 1, numComplete: 2)),
      );
    });
  });
}
