import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import '../../../domain/entities/todo.dart';
import '../../../service/todos_service.dart';

import '../../exceptions/error_handler.dart';

class CheckFavoriteBox extends StatelessWidget {
  const CheckFavoriteBox({
    Key key,
    @required this.todo,
  }) : _key = key;
  final Key _key;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return StateBuilder<bool>(
      observe: () => RM.create(todo.complete),
      builder: (context, completeRM) {
        return Checkbox(
          key: _key,
          value: completeRM.value,
          onChanged: (value) {
            completeRM.value = value;
            RM
                .getFuture<TodosService, void>(
                  (t) => t.updateTodo(
                    todo.copyWith(complete: value),
                  ),
                )
                .subscription
                .onError(
              (error) {
                completeRM.value = !value;
                ErrorHandler.showErrorSnackBar(context, error);
              },
            );
          },
        );
      },
    );
  }
}
