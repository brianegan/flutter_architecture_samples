// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_repository/todos_repository.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth auth;

  const FirebaseUserRepository(this.auth);

  @override
  Future<UserEntity> login() async {
    final firebaseUser = await auth.signInAnonymously();

    return UserEntity(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoUrl,
    );
  }
}
