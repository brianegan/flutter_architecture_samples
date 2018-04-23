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
      final interactor = new MockTodosInteractor();
      final todos = [
        new Todo('Hi', complete: true),
        new Todo('There', complete: true),
        new Todo('Friend'),
      ];

      when(interactor.todos)
          .thenAnswer((_) => new Stream.fromIterable([todos]));

      final presenter = new StatsPresenter(interactor);

      expect(
        presenter,
        emitsThrough(new StatsModel(1, 2)),
      );
    });
  });
}
