// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:wire_flutter_todo/const/TodoDataParams.dart';
import 'package:wire_flutter_todo/const/TodoViewSignal.dart';
import 'package:wire_flutter_todo/const/TodoApplicationState.dart';
import 'package:wire_flutter_todo/data/dto/CreateDTO.dart';
import 'package:wire_flutter_todo/data/vo/TodoVO.dart';
import 'package:wire_flutter_todo/screens/detail_screen.dart';
import 'package:wire_flutter_todo/widgets/list/todo_item_widget.dart';
import 'package:wire/wire.dart';
import 'package:wire_flutter/wire_flutter.dart';

import '../../const/TodoDataParams.dart';

class TodoList extends StatelessWidget {

  TodoList() : super(key: ArchSampleKeys.todoList);

  @override
  Widget build(BuildContext context) {
    return WireDataBuilder<TodoApplicationState>(
      param: TodoDataParams.STATE,
      builder: (context, state) => Container(
        child: state == TodoApplicationState.LOADING
            ? Center(
                child: CircularProgressIndicator(
                key: ArchSampleKeys.todosLoading,
              ))
            : WireDataBuilder<List<String>>(
                param: TodoDataParams.LIST,
                builder: (context, list) => ListView.builder(
                  key: ArchSampleKeys.todoList,
                  itemCount: list.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todoId = list[index];
                    return Dismissible(
                      key: ArchSampleKeys.todoItem(todoId),
                      onDismissed: (direction) {
                        _removeTodo(context, todoId);
                      },
                      child: TodoItem(
                        id: todoId,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return DetailScreen(
                                  id: todoId,
                                  onDelete: () => {
                                    _removeTodo(context, todoId)
                                  },
                                );
                              },
                            ),
                          );
                        },
                        onToggle: (value) =>
                          Wire.send(TodoViewSignal.TOGGLE, todoId),
                      ),
                    );
                  },
                ),
            ),
      ),
    );
  }

  void _removeTodo(BuildContext context, String todoId) {
    var todoWireData = Wire.data(todoId);
    TodoVO todoVO = todoWireData.value;
    Wire.send(TodoViewSignal.DELETE, todoId);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: ArchSampleKeys.snackbar,
        duration: Duration(seconds: 2),
        content: Text(
          ArchSampleLocalizations.of(context).todoDeleted(todoVO.text),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        action: SnackBarAction(
          label: ArchSampleLocalizations.of(context).undo,
          onPressed: () => Wire.send(TodoViewSignal.INPUT, CreateDTO(todoVO.text, todoVO.note, todoVO.completed))
        ),
      ),
    );
  }
}
