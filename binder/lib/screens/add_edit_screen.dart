// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:binder/binder.dart';
import 'package:binder_sample/logics/add_edit_screen.dart';
import 'package:binder_sample/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';

class AddEditScreen extends StatelessWidget {
  const AddEditScreen({Key key, this.todo})
      : super(key: key ?? ArchSampleKeys.addTodoScreen);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return BinderScope(
      overrides: [
        taskRef.overrideWith(todo?.task ?? ''),
        noteRef.overrideWith(todo?.note ?? ''),
        addEditScreenLogicRef.overrideWithSelf(),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(isEditing
                  ? ArchSampleLocalizations.of(context).editTodo
                  : ArchSampleLocalizations.of(context).addTodo),
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: todo != null ? todo.task : '',
                    key: ArchSampleKeys.taskField,
                    autofocus: isEditing ? false : true,
                    style: Theme.of(context).textTheme.headline5,
                    decoration: InputDecoration(
                      hintText: ArchSampleLocalizations.of(context).newTodoHint,
                      errorText: context.watch(taskIsValidRef)
                          ? null
                          : ArchSampleLocalizations.of(context).emptyTodoError,
                    ),
                    onChanged: (value) =>
                        context.use(addEditScreenLogicRef).task = value,
                  ),
                  TextFormField(
                    initialValue: todo != null ? todo.note : '',
                    key: ArchSampleKeys.noteField,
                    maxLines: 10,
                    style: Theme.of(context).textTheme.subtitle1,
                    decoration: InputDecoration(
                      hintText: ArchSampleLocalizations.of(context).notesHint,
                    ),
                    onChanged: (value) =>
                        context.use(addEditScreenLogicRef).note = value,
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              key: isEditing
                  ? ArchSampleKeys.saveTodoFab
                  : ArchSampleKeys.saveNewTodo,
              tooltip: isEditing
                  ? ArchSampleLocalizations.of(context).saveChanges
                  : ArchSampleLocalizations.of(context).addTodo,
              child: Icon(isEditing ? Icons.check : Icons.add),
              onPressed: context.watch(canBeSubmittedRef)
                  ? () {
                      context.use(addEditScreenLogicRef).put(todo);
                      Navigator.pop(context);
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }

  bool get isEditing => todo != null;
}
