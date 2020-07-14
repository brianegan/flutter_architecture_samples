// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:wire_flutter/wire_flutter.dart';
import 'package:wire_flutter_todo/data/vo/TodoVO.dart';
import 'package:wire_flutter_todo/data/dto/EditDTO.dart';
import 'package:wire_flutter_todo/const/TodoViewSignal.dart';
import 'package:wire_flutter_todo/data/dto/CreateDTO.dart';
import 'package:wire/wire.dart';

class AddEditScreen extends StatefulWidget {
  final String id;

  AddEditScreen({
    this.id,
  }) : super(key: ArchSampleKeys.addTodoScreen);

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _text;
  String _note;

  @override
  Widget build(BuildContext context) {
    print('isEditing ${isEditing}');
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing
            ? ArchSampleLocalizations.of(context).editTodo
            : ArchSampleLocalizations.of(context).addTodo),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: !isEditing ? ListViewWidget(context, null) :
          WireDataBuilder<TodoVO>( param: widget.id,
            builder: (ctx, todoVO) => ListViewWidget(ctx, todoVO),
          ),
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
          onPressed: () {
            final form = formKey.currentState;
            if (form.validate()) {
              form.save();

              if (isEditing) {
                Wire.send(TodoViewSignal.EDIT, EditDTO(widget.id, _text, _note));
              } else {
                Wire.send(TodoViewSignal.INPUT, CreateDTO(_text, _note));
              }

              Navigator.pop(context);
            }
          }),
    );
  }
  
  Widget ListViewWidget(context, todoVO) => ListView(
    children: [
      TextFormField(
        initialValue: todoVO?.text ?? '',
        key: ArchSampleKeys.taskField,
        autofocus: isEditing ? false : true,
        style: Theme.of(context).textTheme.headline6,
        decoration: InputDecoration(hintText: ArchSampleLocalizations.of(context).newTodoHint),
        validator: (val) => val.trim().isEmpty
          ? ArchSampleLocalizations.of(context).emptyTodoError
          : null,
        onSaved: (value) => _text = value,
      ),
      TextFormField(
        initialValue: todoVO?.note ?? '',
        key: ArchSampleKeys.noteField,
        maxLines: 10,
        style: Theme.of(context).textTheme.subtitle1,
        decoration: InputDecoration(hintText: ArchSampleLocalizations.of(context).notesHint,),
        onSaved: (value) => _note = value,
      )
    ],
  );

  bool get isEditing => widget.id != null;
}
