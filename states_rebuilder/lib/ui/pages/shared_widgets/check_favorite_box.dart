import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../domain/entities/todo.dart';
import '../../../service/todos_service.dart';
import '../../exceptions/error_handler.dart';

class CheckFavoriteBox extends StatelessWidget {
  //accept the todo ReactiveModel from the TodoList or DetailedScreen widgets
  const CheckFavoriteBox({
    Key key,
    @required this.todoRM,
  }) : _key = key;
  final Key _key;
  final ReactiveModel<Todo> todoRM;
  Todo get todo => todoRM.value;
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      key: _key,
      value: todo.complete,
      onChanged: (value) {
        //hold the old todo
        final oldTodo = todo;
        final newTodo = todo.copyWith(
          complete: value,
        );
        //set todo to th new todo and notify observer (the todo tile)
        todoRM.value = newTodo;

        //Here we get the global ReactiveModel and from it we create a new Local ReactiveModel.
        //The created ReactiveModel is based of the future of updateTodo method.
        RM
            .get<TodosService>()
            .future(
              (t) => t.updateTodo(newTodo),
            )
            .onError(
          (error) {
            //on Error set the todo value to the old value
            todoRM.value = oldTodo;
            //show SnackBar to display the error message
            ErrorHandler.showErrorSnackBar(context, error);
          },
        );
      },
    );
  }
}
