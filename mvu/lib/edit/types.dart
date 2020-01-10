import 'package:built_value/built_value.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:todos_repository_core/todos_repository_core.dart';

part 'types.g.dart';

abstract class EditTodoModel
    implements Built<EditTodoModel, EditTodoModelBuilder> {
  widgets.TextEditingController get task;

  widgets.TextEditingController get note;

  String get id;

  EditTodoModel._();

  factory EditTodoModel([void Function(EditTodoModelBuilder b) update]) =
      _$EditTodoModel;
}

abstract class EditTodoMessage {}

class Save implements EditTodoMessage {}

class OnSaved implements EditTodoMessage {
  final TodoEntity todo;

  OnSaved(this.todo);
}
