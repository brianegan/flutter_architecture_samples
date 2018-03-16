// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';
import 'package:vanilla/models.dart';
import 'package:vanilla/widgets/typedefs.dart';

class AddEditScreen extends StatelessWidget {
  static final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> taskKey =
      new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> noteKey =
      new GlobalKey<FormFieldState<String>>();

  final Todo todo;
  final TodoAdder addTodo;
  final TodoUpdater updateTodo;

  AddEditScreen({
    Key key,
    @required this.addTodo,
    @required this.updateTodo,
    this.todo,
  })
      : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(isEditing
            ? ArchSampleLocalizations.of(context).editTodo
            : ArchSampleLocalizations.of(context).addTodo),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return new Future(() => true);
          },
          child: new ListView(
            children: [
              new TextFormField(
                initialValue: todo != null ? todo.task : '',
                key: taskKey,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration: new InputDecoration(
                    hintText: ArchSampleLocalizations.of(context).newTodoHint),
                validator: (val) => val.trim().isEmpty
                    ? ArchSampleLocalizations.of(context).emptyTodoError
                    : null,
              ),
              new TextFormField(
                initialValue: todo != null ? todo.note : '',
                key: noteKey,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: new InputDecoration(
                  hintText: ArchSampleLocalizations.of(context).notesHint,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          tooltip: isEditing
              ? ArchSampleLocalizations.of(context).saveChanges
              : ArchSampleLocalizations.of(context).addTodo,
          child: new Icon(isEditing ? Icons.check : Icons.add),
          onPressed: () {
            final form = formKey.currentState;
            if (form.validate()) {
              final task = taskKey.currentState.value;
              final note = noteKey.currentState.value;

              if (isEditing) {
                updateTodo(todo, task: task, note: note);
              } else {
                addTodo(new Todo(
                  task,
                  note: note,
                ));
              }

              Navigator.pop(context);
            }
          }),
    );
  }

  bool get isEditing => todo != null;
}
