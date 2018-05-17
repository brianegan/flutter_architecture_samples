# firebase_rtdb_flutter_repository

A reactive version of the todos repository and user repository backed by Firebase Realtime Database
and FirebaseAuth for Flutter.

## Defines how to log in

This library provides a concrete implementation of the `UserRepository` class. It uses the `firebase_auth` package and anonymous login as the mechanism and returns a `UserEntity`.

## Defines how to interact with Todos

This library provides a concrete implementation of the `ReactiveTodosRepository`. 

To listen for real-time changes, it streams `TodoEntity` objects stored in the `todos` collection on
 Firebase Realtime Database. To create, update, and delete todos, it pushes changes to the `todos`
 collection or individual documents.
 
### Works with `firestore_redux` project

in `main.dart` replace 
```dart
    FirestoreReactiveTodosRepository(Firestore.instance)
```
with 
```dart
    FirebaseReactiveTodosRepository(FirebaseDatabase.instance)
```
In `pubspec.yaml` replace
```yaml  
    firebase_flutter_repository:
      path: ../firebase_flutter_repository
```
with
```yaml
    firebase_flutter_repository:
      path: ../firebase_rtdb_flutter_repository
```

Then update packages from commandline with
```
flutter packages get
```
or the equivalent with your IDE.
