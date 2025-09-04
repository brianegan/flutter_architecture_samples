import 'dart:async';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:test/test.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

import 'user_interactor_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>()])
void main() {
  group('UserInteractor', () {
    test('should convert repo entities into Todos', () async {
      final repository = MockUserRepository();
      final interactor = UserInteractor(repository);

      when(repository.login()).thenAnswer(
        (_) => Future.value(
          UserEntity(displayName: 'Frida', id: '', photoUrl: ''),
        ),
      );

      expect(await interactor.login(), User(displayName: 'Frida'));
    });
  });
}
