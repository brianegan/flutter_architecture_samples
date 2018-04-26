// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:test/test.dart';

class MockTodosInteractor extends Mock implements TodosInteractor {}

void main() {
  group('MviStats', () {
    test('should stream the number of active and completed todos', () {
      final interactor = MockTodosInteractor();
      final todos = [
        Todo('Hi', complete: true),
        Todo('There', complete: true),
        Todo('Friend'),
      ];

      when(interactor.todos).thenAnswer((_) => Stream.fromIterable([todos]));

      final presenter = StatsPresenter(interactor);

      expect(
        presenter,
        emitsThrough(StatsModel(1, 2)),
      );
    });
  });
}
