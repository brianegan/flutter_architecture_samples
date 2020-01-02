// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/blocs.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('TodosState', () {
    group('TodosLoading', () {
      test('toString returns correct value', () {
        expect(
          TodosLoading().toString(),
          'TodosLoading',
        );
      });
    });

    group('TodosLoaded', () {
      test('toString returns correct value', () {
        expect(
          TodosLoaded([Todo('wash car', id: '0')]).toString(),
          'TodosLoaded { todos: [${Todo("wash car", id: "0")}] }',
        );
      });
    });

    group('TodosNotLoaded', () {
      test('toString returns correct value', () {
        expect(
          TodosNotLoaded().toString(),
          'TodosNotLoaded',
        );
      });
    });
  });
}
