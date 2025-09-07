import 'package:todos_repository_core/todos_repository_core.dart';

class AnonymousUserRepository implements UserRepository {
  @override
  Future<UserEntity> login() {
    return Future.value(
      UserEntity(id: 'anonymous', displayName: '', photoUrl: ''),
    );
  }
}
