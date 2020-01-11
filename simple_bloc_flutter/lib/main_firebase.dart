// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_repository/reactive_todos_repository.dart';
import 'package:firebase_flutter_repository/user_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_bloc_flutter_sample/app.dart';
import 'package:simple_blocs/simple_blocs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(SimpleBlocApp(
    todosInteractor: TodosInteractor(
      FirestoreReactiveTodosRepository(Firestore.instance),
    ),
    userRepository: FirebaseUserRepository(FirebaseAuth.instance),
  ));
}
