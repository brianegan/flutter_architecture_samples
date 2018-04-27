import 'package:built_value/built_value.dart';
import 'package:flutter/widgets.dart' as widgets;

import 'package:todos_repository/todos_repository.dart';

part 'types.g.dart';

abstract class EditTodoModel implements Built<EditTodoModel, EditTodoModelBuilder> {
  widgets.TextEditingController get task;
  widgets.TextEditingController get note;
  String get id;

  EditTodoModel._();
  factory EditTodoModel([update(EditTodoModelBuilder b)]) = _$EditTodoModel;
}

abstract class EditTodoMessage {}
class Save implements EditTodoMessage {}
class OnSaved implements EditTodoMessage {
  final TodoEntity todo;
  OnSaved(this.todo);
}