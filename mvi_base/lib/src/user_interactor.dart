// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:mvi_base/src/models/user.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class UserInteractor {
  final UserRepository _repository;

  UserInteractor(UserRepository repository) : _repository = repository;

  Future<User> login() async => User((await _repository.login()).displayName);
}
