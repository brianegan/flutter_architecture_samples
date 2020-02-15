// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package

part of 'todo_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

mixin _$TodoList {
  List<Todo> get todos;
  VisibilityFilter get filter;
  bool get loading;

  TodoList copyWith({List<Todo> todos, VisibilityFilter filter, bool loading});
}

class _$TodoListState with DiagnosticableTreeMixin implements TodoListState {
  _$TodoListState(this.todos, {@required this.filter, @required this.loading})
      : assert(todos != null),
        assert(filter != null),
        assert(loading != null);

  @override
  final List<Todo> todos;
  @override
  final VisibilityFilter filter;
  @override
  final bool loading;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
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
    return identical(this, other) ||
        (other is TodoListState &&
            (identical(other.todos, todos) ||
                const DeepCollectionEquality().equals(other.todos, todos)) &&
            (identical(other.filter, filter) ||
                const DeepCollectionEquality().equals(other.filter, filter)) &&
            (identical(other.loading, loading) ||
                const DeepCollectionEquality().equals(other.loading, loading)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      todos.hashCode ^
      filter.hashCode ^
      loading.hashCode;

  @override
  _$TodoListState copyWith({
    Object todos = freezed,
    Object filter = freezed,
    Object loading = freezed,
  }) {
    assert(todos != null);
    assert(filter != null);
    assert(loading != null);
    return _$TodoListState(
      todos == freezed ? this.todos : todos as List<Todo>,
      filter: filter == freezed ? this.filter : filter as VisibilityFilter,
      loading: loading == freezed ? this.loading : loading as bool,
    );
  }
}

abstract class TodoListState implements TodoList {
  factory TodoListState(List<Todo> todos,
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
