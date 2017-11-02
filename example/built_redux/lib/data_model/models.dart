library models;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:flutter_architecture_samples/uuid.dart';

part 'models.g.dart';

class AppTab extends EnumClass {
  static Serializer<AppTab> get serializer => _$appTabSerializer;

  static const AppTab todos = _$todos;
  static const AppTab stats = _$stats;

  const AppTab._(String name) : super(name);

  static BuiltSet<AppTab> get values => _$appTabValues;

  static AppTab valueOf(String name) => _$appTabValueOf(name);

  static AppTab fromIndex(int index) {
    switch (index) {
      case 1:
        return AppTab.stats;
      default:
        return AppTab.todos;
    }
  }

  static int toIndex(AppTab tab) {
    switch (tab) {
      case AppTab.stats:
        return 1;
      default:
        return 0;
    }
  }
}

class ExtraAction extends EnumClass {
  static Serializer<ExtraAction> get serializer => _$extraActionSerializer;

  static const ExtraAction toggleAllComplete = _$toggleAllComplete;
  static const ExtraAction clearCompleted = _$clearCompleted;

  const ExtraAction._(String name) : super(name);

  static BuiltSet<ExtraAction> get values => _$extraActionValues;

  static ExtraAction valueOf(String name) => _$extraActionValueOf(name);
}

class VisibilityFilter extends EnumClass {
  static Serializer<VisibilityFilter> get serializer =>
      _$visibilityFilterSerializer;

  static const VisibilityFilter all = _$all;
  static const VisibilityFilter active = _$active;
  static const VisibilityFilter completed = _$completed;

  const VisibilityFilter._(String name) : super(name);

  static BuiltSet<VisibilityFilter> get values => _$visibilityFilterValues;

  static VisibilityFilter valueOf(String name) =>
      _$visibilityFilterValueOf(name);
}

abstract class AppState implements Built<AppState, AppStateBuilder> {
  static Serializer<AppState> get serializer => _$appStateSerializer;

  bool get isLoading;

  BuiltList<Todo> get todos;

  AppTab get activeTab;

  VisibilityFilter get activeFilter;

  AppState._();

  factory AppState([updates(AppStateBuilder b)]) => new _$AppState((b) => b
    ..isLoading = false
    ..todos = new ListBuilder<Todo>([])
    ..activeTab = AppTab.todos
    ..activeFilter = VisibilityFilter.all
    ..update(updates));

  factory AppState.loading() => new AppState((b) => b..isLoading = true);

  factory AppState.fromTodos(List<Todo> todos) =>
      new AppState((b) => b..todos = new ListBuilder<Todo>(todos));

  bool get allComplete => todos.every((todo) => todo.complete);

  List<Todo> filteredTodos(VisibilityFilter activeFilter) =>
      todos.where((todo) {
        if (activeFilter == VisibilityFilter.all) {
          return true;
        } else if (activeFilter == VisibilityFilter.active) {
          return !todo.complete;
        } else if (activeFilter == VisibilityFilter.completed) {
          return todo.complete;
        }
      }).toList();

  bool get hasCompletedTodos => todos.any((todo) => todo.complete);

  int get numActive =>
      todos.fold(0, (sum, todo) => !todo.complete ? ++sum : sum);

  int get numCompleted =>
      todos.fold(0, (sum, todo) => todo.complete ? ++sum : sum);
}

abstract class Todo implements Built<Todo, TodoBuilder> {
  static Serializer<Todo> get serializer => _$todoSerializer;

  bool get complete;

  String get id;

  String get note;

  String get task;

  Todo._();

  factory Todo(String task) {
    return new _$Todo._(
      task: task,
      complete: false,
      note: '',
      id: new Uuid().generateV4(),
    );
  }

  factory Todo.builder([updates(TodoBuilder b)]) {
    final builder = new TodoBuilder()
      ..id = new Uuid().generateV4()
      ..complete = false
      ..note = ''
      ..update(updates);

    return builder.build();
  }
}
