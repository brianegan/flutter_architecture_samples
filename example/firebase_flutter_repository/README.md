# firebase_flutter_repository

A reactive version of the todos repository and user repository backed by Firestore and FirebaseAuth for Flutter. 

## Defines how to log in

This library provides a concrete implementation of the `UserRepository` class. It uses the `firebase_auth` package and anonymous login as the mechanism and returns a `UserEntity`.

## Defines how to interact with Todos

This library provides a concrete implementation of the `ReactiveTodosRepository`. 

To listen for real-time changes, it streams `TodoEntity` objects stored in the `todos` collection on Firestore. To create, update, and delete todos, it pushes changes to the `todos` collection or individual documents.
