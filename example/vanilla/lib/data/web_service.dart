import 'dart:async';
import 'package:vanilla/models.dart';

/// A class that is meant to represent a Web Service you would call to fetch
/// and persist Todos to and from the cloud.
///
/// Since we're trying to keep this example simple, it is a Mock implementation.
class WebService {
  WebService();

  /// Mock that "fetches" some Todos from a "web service" after a short delay
  Future<List<Todo>> fetchTodos() async {
    return new Future.delayed(
        new Duration(milliseconds: 1200),
        () => [
              new Todo('Hey', note: 'Ho, let\'s go!'),
              new Todo('Wonderwall', complete: true),
              new Todo('Everything', note: 'in its right place'),
              new Todo('Cheeseburger in Paradise'),
              new Todo('If you like', note: 'Pina Coladas', complete: true),
            ]);
  }

  /// Mock that returns true or false for success or failure. In this case,
  /// it will "Always Succeed"
  Future<bool> postTodos(List<Todo> todos) async {
    return new Future.value(true);
  }
}
