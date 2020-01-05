import 'dart:convert';

import 'package:mobx_sample/models/todo.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

// Converts Todos to TodoEntities and vice-versa for interop with the
// TodoRepository (data layer). Implements the standard `Codec` interface from
// dart:convert.
class TodoCodec extends Codec<Todo, TodoEntity> {
  const TodoCodec();

  @override
  Converter<TodoEntity, Todo> get decoder => const _TodoDecoder();

  @override
  Converter<Todo, TodoEntity> get encoder => const _TodoEncoder();
}

class _TodoEncoder extends Converter<Todo, TodoEntity> {
  const _TodoEncoder();

  @override
  TodoEntity convert(Todo todo) {
    return TodoEntity(
      todo.task,
      todo.id,
      todo.note,
      todo.complete,
    );
  }
}

class _TodoDecoder extends Converter<TodoEntity, Todo> {
  const _TodoDecoder();

  @override
  Todo convert(TodoEntity entity) {
    return Todo(
      task: entity.task,
      complete: entity.complete ?? false,
      note: entity.note,
      id: entity.id,
    );
  }
}
