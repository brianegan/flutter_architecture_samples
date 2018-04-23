// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:test/test.dart';
import 'package:todos_repository/todos_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserInteractor', () {
    test('should convert repo entities into Todos', () async {
      final repository = new MockUserRepository();
      final interactor = new UserInteractor(repository);

      when(repository.login()).thenAnswer(
          (_) => new Future.value(new UserEntity(displayName: 'Frida')));

      expect(await interactor.login(), new User('Frida'));
    });
  });
}
