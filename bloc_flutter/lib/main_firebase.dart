import 'package:bloc_flutter_sample/app.dart';
import 'package:blocs/blocs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_repository/reactive_todos_repository.dart';
import 'package:firebase_flutter_repository/user_repository.dart';
import 'package:flutter/widgets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocApp(
      todosInteractor: TodosInteractor(
        FirestoreReactiveTodosRepository(Firestore.instance),
      ),
      userRepository: FirebaseUserRepository(FirebaseAuth.instance),
    ),
  );
}
