// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_repository/reactive_todos_repository.dart';
import 'package:firebase_flutter_repository/user_repository.dart';
import 'package:mvi_base/mvi_base.dart';
import 'package:mvi_flutter_sample/run_mvi_app.dart';

void main() {
  runMviApp(
    todosRepository: TodosInteractor(
      FirestoreReactiveTodosRepository(Firestore.instance),
    ),
    userInteractor: UserInteractor(
      FirebaseUserRepository(FirebaseAuth.instance),
    ),
  );
}
