import 'package:built_value/built_value.dart';

import 'package:mvu/todos/types.dart';
import 'package:mvu/stats/types.dart';
import 'package:todos_repository_core/todos_repository_core.dart';

part 'types.g.dart';

enum AppTab { todos, stats }
enum VisibilityFilter { all, active, completed }

abstract class HomeMessage {}

class TabChangedMessage implements HomeMessage {
  final AppTab value;
  TabChangedMessage(this.value);
}

class CreateNewTodo implements HomeMessage {}

class OnNewTodoCreated implements HomeMessage {
  final TodoEntity entity;
  OnNewTodoCreated(this.entity);
}

class TodosMsg implements HomeMessage {
  final TodosMessage message;
  TodosMsg(this.message);
}

class StatsMsg implements HomeMessage {
  final StatsMessage message;
  StatsMsg(this.message);
}

abstract class HomeModel implements Built<HomeModel, HomeModelBuilder> {
  BodyModel get body;

  HomeModel._();
  factory HomeModel([void Function(HomeModelBuilder b) updates]) = _$HomeModel;
}

abstract class BodyModel<TModel> {
  AppTab get tag;
  TModel get model;
}

class TodosBody implements BodyModel<TodosModel> {
  final TodosModel _model;

  TodosBody(this._model);

  @override
  AppTab get tag => AppTab.todos;

  @override
  TodosModel get model => _model;
}

class StatsBody implements BodyModel<StatsModel> {
  final StatsModel _model;

  StatsBody(this._model);

  @override
  AppTab get tag => AppTab.stats;

  @override
  StatsModel get model => _model;
}
