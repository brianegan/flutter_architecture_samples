// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'todo_list_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TodoList implements DiagnosticableTreeMixin {

 List<Todo> get todos; VisibilityFilter get filter; bool get loading;
/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoListCopyWith<TodoList> get copyWith => _$TodoListCopyWithImpl<TodoList>(this as TodoList, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TodoList'))
    ..add(DiagnosticsProperty('todos', todos))..add(DiagnosticsProperty('filter', filter))..add(DiagnosticsProperty('loading', loading));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoList&&const DeepCollectionEquality().equals(other.todos, todos)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(todos),filter,loading);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TodoList(todos: $todos, filter: $filter, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $TodoListCopyWith<$Res>  {
  factory $TodoListCopyWith(TodoList value, $Res Function(TodoList) _then) = _$TodoListCopyWithImpl;
@useResult
$Res call({
 List<Todo> todos, VisibilityFilter filter, bool loading
});




}
/// @nodoc
class _$TodoListCopyWithImpl<$Res>
    implements $TodoListCopyWith<$Res> {
  _$TodoListCopyWithImpl(this._self, this._then);

  final TodoList _self;
  final $Res Function(TodoList) _then;

/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todos = null,Object? filter = null,Object? loading = null,}) {
  return _then(_self.copyWith(
todos: null == todos ? _self.todos : todos // ignore: cast_nullable_to_non_nullable
as List<Todo>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as VisibilityFilter,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TodoList].
extension TodoListPatterns on TodoList {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( TodoListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case TodoListState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( TodoListState value)  $default,){
final _that = this;
switch (_that) {
case TodoListState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( TodoListState value)?  $default,){
final _that = this;
switch (_that) {
case TodoListState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Todo> todos,  VisibilityFilter filter,  bool loading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case TodoListState() when $default != null:
return $default(_that.todos,_that.filter,_that.loading);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Todo> todos,  VisibilityFilter filter,  bool loading)  $default,) {final _that = this;
switch (_that) {
case TodoListState():
return $default(_that.todos,_that.filter,_that.loading);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Todo> todos,  VisibilityFilter filter,  bool loading)?  $default,) {final _that = this;
switch (_that) {
case TodoListState() when $default != null:
return $default(_that.todos,_that.filter,_that.loading);case _:
  return null;

}
}

}

/// @nodoc


class TodoListState with DiagnosticableTreeMixin implements TodoList {
   TodoListState(final  List<Todo> todos, {required this.filter, required this.loading}): _todos = todos;
  

 final  List<Todo> _todos;
@override List<Todo> get todos {
  if (_todos is EqualUnmodifiableListView) return _todos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_todos);
}

@override final  VisibilityFilter filter;
@override final  bool loading;

/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TodoListStateCopyWith<TodoListState> get copyWith => _$TodoListStateCopyWithImpl<TodoListState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'TodoList'))
    ..add(DiagnosticsProperty('todos', todos))..add(DiagnosticsProperty('filter', filter))..add(DiagnosticsProperty('loading', loading));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TodoListState&&const DeepCollectionEquality().equals(other._todos, _todos)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.loading, loading) || other.loading == loading));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_todos),filter,loading);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'TodoList(todos: $todos, filter: $filter, loading: $loading)';
}


}

/// @nodoc
abstract mixin class $TodoListStateCopyWith<$Res> implements $TodoListCopyWith<$Res> {
  factory $TodoListStateCopyWith(TodoListState value, $Res Function(TodoListState) _then) = _$TodoListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Todo> todos, VisibilityFilter filter, bool loading
});




}
/// @nodoc
class _$TodoListStateCopyWithImpl<$Res>
    implements $TodoListStateCopyWith<$Res> {
  _$TodoListStateCopyWithImpl(this._self, this._then);

  final TodoListState _self;
  final $Res Function(TodoListState) _then;

/// Create a copy of TodoList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todos = null,Object? filter = null,Object? loading = null,}) {
  return _then(TodoListState(
null == todos ? _self._todos : todos // ignore: cast_nullable_to_non_nullable
as List<Todo>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as VisibilityFilter,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
