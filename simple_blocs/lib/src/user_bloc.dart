// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:todos_repository_core/todos_repository_core.dart';

class UserBloc {
  final UserRepository _repository;

  // Outputs
  Stream<UserEntity> login() =>
      _repository.login().asStream().asBroadcastStream();

  UserBloc(UserRepository repository) : this._repository = repository;
}
