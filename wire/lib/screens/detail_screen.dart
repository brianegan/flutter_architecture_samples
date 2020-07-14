// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:wire_flutter_todo/const/TodoViewSignal.dart';
import 'package:wire_flutter_todo/data/vo/TodoVO.dart';
import 'package:wire_flutter_todo/screens/add_edit_screen.dart';
import 'package:wire/wire.dart';
import 'package:wire_flutter/wire_flutter.dart';

class DetailScreen extends StatelessWidget {
  final String id;
  final Function onDelete;

  DetailScreen({
    @required this.id,
    @required this.onDelete,
  }) : super(key: ArchSampleKeys.todoDetailsScreen);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: WireDataBuilder<TodoVO>(
          param: id,
          builder: (context, todoVO) => ListView(
            children: [ Row( crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Checkbox( value: todoVO.completed,
                    key: ArchSampleKeys.detailsTodoItemCheckbox,
                    onChanged: (value) => Wire.send(TodoViewSignal.TOGGLE, id),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, bottom: 16.0,),
                        child: Text(todoVO.text,
                          key: ArchSampleKeys.detailsTodoItemTask,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      Text(todoVO.note,
                        key: ArchSampleKeys.detailsTodoItemNote,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: ArchSampleLocalizations.of(context).editTodo,
        child: Icon(Icons.edit),
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddEditScreen(id: id)),
          );
        },
      ),
    );
  }
}
