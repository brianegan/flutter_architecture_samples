import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../domain/entities/todo.dart';
import '../../../service/todos_service.dart';
import '../../exceptions/error_handler.dart';

class CheckFavoriteBox extends StatelessWidget {
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
        final oldTodo = todo;
        final newTodo = todo.copyWith(
          complete: value,
        );
        todoRM.value = newTodo;
        RM
            .getFuture<TodosService, void>(
              (t) => t.updateTodo(newTodo),
            )
            .subscription
            .onError(
          (error) {
            todoRM.value = oldTodo;
            ErrorHandler.showErrorSnackBar(context, error);
          },
        );
      },
    );
  }
}
