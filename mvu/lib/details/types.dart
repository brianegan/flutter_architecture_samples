import 'package:built_value/built_value.dart';

import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:mvu/common/todo_model.dart';

part 'types.g.dart';

abstract class DetailsModel
    implements Built<DetailsModel, DetailsModelBuilder> {
  TodoModel get todo;

  DetailsModel._();
  factory DetailsModel([void Function(DetailsModelBuilder b) updates]) =
      _$DetailsModel;
}

abstract class DetailsMessage {}

class Remove implements DetailsMessage {}

class ToggleCompleted implements DetailsMessage {}

class Edit implements DetailsMessage {}

class OnTodoChanged implements DetailsMessage {
  final TodoEntity entity;
  OnTodoChanged(this.entity);
}

class OnTodoRemoved implements DetailsMessage {
  final TodoEntity entity;
  OnTodoRemoved(this.entity);
}
