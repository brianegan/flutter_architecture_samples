import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';

import 'package:todos_repository_core/todos_repository_core.dart';
import 'package:mvu/common/todo_model.dart';

part 'types.g.dart';

abstract class StatsMessage {}

class LoadStats implements StatsMessage {}

class OnStatsLoaded implements StatsMessage {
  final List<TodoEntity> todos;
  OnStatsLoaded(this.todos);
}

class ToggleAllMessage implements StatsMessage {}

class CleareCompletedMessage implements StatsMessage {}

class OnNewTaskCreated implements StatsMessage {
  final TodoEntity entity;
  OnNewTaskCreated(this.entity);
}

abstract class StatsModel implements Built<StatsModel, StatsModelBuilder> {
  BuiltList<TodoModel> get items;
  bool get loading;
  int get activeCount;
  int get completedCount;

  StatsModel._();
  factory StatsModel([void Function(StatsModelBuilder b) updates]) =
      _$StatsModel;
}
