library app_state;

import 'package:built_collection/built_collection.dart';
import 'package:built_redux_sample/models/app_tab.dart';
import 'package:built_redux_sample/models/todo.dart';
import 'package:built_redux_sample/models/visibility_filter.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_state.g.dart';

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
}