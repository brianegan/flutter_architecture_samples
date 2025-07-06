import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseAuth auth;

  const FirebaseUserRepository(this.auth);

  @override
  Future<UserEntity> login() async {
    final firebaseUser = await auth.signInAnonymously();

    return UserEntity(
      id: firebaseUser.user.uid,
      displayName: firebaseUser.user.displayName,
      photoUrl: firebaseUser.user.photoUrl,
    );
  }
}
