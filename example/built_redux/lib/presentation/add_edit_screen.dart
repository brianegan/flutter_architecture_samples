// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved. 
// Use of this source code is governed by the MIT license that can be found 
// in the LICENSE file.

import 'package:built_redux_sample/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

typedef OnSaveCallback = Function(String task, String note);

class AddEditScreen extends StatelessWidget {
  static final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  static final GlobalKey<FormFieldState<String>> _taskKey =
      new GlobalKey<FormFieldState<String>>();
  static final GlobalKey<FormFieldState<String>> _noteKey =
      new GlobalKey<FormFieldState<String>>();

  final bool isEditing;
  final Function(String task, String note) onSave;
  final Todo todo;

  AddEditScreen(
      {Key key, @required this.onSave, @required this.isEditing, this.todo})
      : super(key: key ?? ArchSampleKeys.addTodoScreen);

  @override
  Widget build(BuildContext context) {
    final localizations = ArchSampleLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          isEditing ? localizations.editTodo : localizations.addTodo,
        ),
      ),
      body: new Padding(
        padding: new EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            children: [
              new TextFormField(
                initialValue: isEditing ? todo.task : '',
                key: _taskKey,
                autofocus: !isEditing,
                style: textTheme.headline,
                decoration: new InputDecoration(
                  hintText: localizations.newTodoHint,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyTodoError
                      : null;
                },
              ),
              new TextFormField(
                initialValue: isEditing ? todo.note : '',
                key: _noteKey,
                maxLines: 10,
                style: textTheme.subhead,
                decoration: new InputDecoration(
                  hintText: localizations.notesHint,
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: isEditing ? localizations.saveChanges : localizations.addTodo,
        child: new Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            onSave(
              _taskKey.currentState.value,
              _noteKey.currentState.value,
            );

            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
