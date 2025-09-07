import 'dart:async';

import 'package:todos_repository_core/todos_repository_core.dart';

class UserBloc {
  final UserRepository _repository;

  // Outputs
  Stream<UserEntity> login() =>
      _repository.login().asStream().asBroadcastStream();

  UserBloc(UserRepository repository) : _repository = repository;
}
