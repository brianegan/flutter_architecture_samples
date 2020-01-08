import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

import 'package:mvu/home/types.dart';
import 'package:mvu/common/todo_model.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'types.g.dart';

abstract class TodosModel implements Built<TodosModel, TodosModelBuilder> {
  bool get isLoading;
  BuiltList<TodoModel> get items;
  VisibilityFilter get filter;
  @nullable
  String get loadingError;

  TodosModel._();
  factory TodosModel([void Function(TodosModelBuilder b) updates]) =
      _$TodosModel;
}

abstract class TodosMessage {}

class LoadTodos implements TodosMessage {}

class OnTodosLoaded implements TodosMessage {
  final List<TodoEntity> items;
  OnTodosLoaded(this.items);
}

class OnTodosLoadError implements TodosMessage {
  final Exception cause;
  OnTodosLoadError(this.cause);
}

class UpdateTodo implements TodosMessage {
  final bool value;
  final TodoModel todo;
  UpdateTodo(this.value, this.todo);
}

class RemoveTodo implements TodosMessage {
  final TodoModel todo;
  RemoveTodo(this.todo);
}

class UndoRemoveItem implements TodosMessage {
  final TodoModel item;
  UndoRemoveItem(this.item);
}

class FilterChanged implements TodosMessage {
  final VisibilityFilter value;
  FilterChanged(this.value);
}

class ToggleAllMessage implements TodosMessage {}

class CleareCompletedMessage implements TodosMessage {}

class ShowDetailsMessage implements TodosMessage {
  final TodoModel todo;
  ShowDetailsMessage(this.todo);
}

class OnTodoItemChanged implements TodosMessage {
  final TodoEntity updated;
  final TodoEntity removed;
  final TodoEntity created;
  OnTodoItemChanged({this.updated, this.removed, this.created});
}
