// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

abstract class _$TodoList {
  List<Todo> get todos;
  VisibilityFilter get filter;
  bool get loading;

  TodoList copyWith({List<Todo> todos, VisibilityFilter filter, bool loading});
}

class _$TodoListState with DiagnosticableTreeMixin implements TodoListState {
  const _$TodoListState(this.todos,
      {@required this.filter, @required this.loading});

  @override
  final List<Todo> todos;
  @override
  final VisibilityFilter filter;
  @override
  final bool loading;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return 'TodoList(todos: $todos, filter: $filter, loading: $loading)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TodoList'))
      ..add(DiagnosticsProperty('todos', todos))
      ..add(DiagnosticsProperty('filter', filter))
      ..add(DiagnosticsProperty('loading', loading));
  }

  @override
  bool operator ==(dynamic other) {
    return other is TodoListState &&
        (identical(other.todos, todos) || other.todos == todos) &&
        (identical(other.filter, filter) || other.filter == filter) &&
        (identical(other.loading, loading) || other.loading == loading);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      todos.hashCode ^
      filter.hashCode ^
      loading.hashCode;

  @override
  _$TodoListState copyWith({
    Object todos = immutable,
    Object filter = immutable,
    Object loading = immutable,
  }) {
    return _$TodoListState(
      todos == immutable ? this.todos : todos as List<Todo>,
      filter: filter == immutable ? this.filter : filter as VisibilityFilter,
      loading: loading == immutable ? this.loading : loading as bool,
    );
  }
}

abstract class TodoListState implements TodoList {
  const factory TodoListState(List<Todo> todos,
      {@required VisibilityFilter filter,
      @required bool loading}) = _$TodoListState;

  @override
  List<Todo> get todos;
  @override
  VisibilityFilter get filter;
  @override
  bool get loading;

  @override
  TodoListState copyWith(
      {List<Todo> todos, VisibilityFilter filter, bool loading});
}
