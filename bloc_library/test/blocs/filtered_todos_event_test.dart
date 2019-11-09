// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('FilteredTodosEvent', () {
    group('UpdateFilter', () {
      test('toString returns correct value', () {
        expect(
          UpdateFilter(VisibilityFilter.active).toString(),
          'UpdateFilter { filter: VisibilityFilter.active }',
        );
      });
    });

    group('UpdateTodos', () {
      test('toString returns correct value', () {
        expect(
          UpdateTodos([Todo('take out trash', id: '0')]).toString(),
          'UpdateTodos { todos: [${Todo("take out trash", id: "0")}] }',
        );
      });
    });
  });
}
