// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserInteractor', () {
    test('should convert repo entities into Todos', () async {
      final repository = MockUserRepository();
      final interactor = UserInteractor(repository);

      when(repository.login())
          .thenAnswer((_) => Future.value(UserEntity(displayName: 'Frida')));

      expect(await interactor.login(), User('Frida'));
    });
  });
}
