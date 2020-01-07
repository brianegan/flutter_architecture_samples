// GENERATED CODE - DO NOT MODIFY BY HAND

part of actions;

// **************************************************************************
// Generator: BuiltReduxGenerator
// **************************************************************************

class _$AppActions extends AppActions {
  factory _$AppActions() => _$AppActions._();
  _$AppActions._() : super._();

  final ActionDispatcher<Todo> addTodoAction =
      ActionDispatcher<Todo>('AppActions-addTodoAction');
  final ActionDispatcher<Null> clearCompletedAction =
      ActionDispatcher<Null>('AppActions-clearCompletedAction');
  final ActionDispatcher<String> deleteTodoAction =
      ActionDispatcher<String>('AppActions-deleteTodoAction');
  final ActionDispatcher<Null> fetchTodosAction =
      ActionDispatcher<Null>('AppActions-fetchTodosAction');
  final ActionDispatcher<Null> toggleAllAction =
      ActionDispatcher<Null>('AppActions-toggleAllAction');
  final ActionDispatcher<List<Todo>> loadTodosSuccess =
      ActionDispatcher<List<Todo>>('AppActions-loadTodosSuccess');
  final ActionDispatcher<Object> loadTodosFailure =
      ActionDispatcher<Object>('AppActions-loadTodosFailure');
  final ActionDispatcher<VisibilityFilter> updateFilterAction =
      ActionDispatcher<VisibilityFilter>('AppActions-updateFilterAction');
  final ActionDispatcher<AppTab> updateTabAction =
      ActionDispatcher<AppTab>('AppActions-updateTabAction');
  final ActionDispatcher<UpdateTodoActionPayload> updateTodoAction =
      ActionDispatcher<UpdateTodoActionPayload>('AppActions-updateTodoAction');

  @override
  void setDispatcher(Dispatcher dispatcher) {
    addTodoAction.setDispatcher(dispatcher);
    clearCompletedAction.setDispatcher(dispatcher);
    deleteTodoAction.setDispatcher(dispatcher);
    fetchTodosAction.setDispatcher(dispatcher);
    toggleAllAction.setDispatcher(dispatcher);
    loadTodosSuccess.setDispatcher(dispatcher);
    loadTodosFailure.setDispatcher(dispatcher);
    updateFilterAction.setDispatcher(dispatcher);
    updateTabAction.setDispatcher(dispatcher);
    updateTodoAction.setDispatcher(dispatcher);
  }
}

class AppActionsNames {
  static final ActionName<Todo> addTodoAction =
      ActionName<Todo>('AppActions-addTodoAction');
  static final ActionName<Null> clearCompletedAction =
      ActionName<Null>('AppActions-clearCompletedAction');
  static final ActionName<String> deleteTodoAction =
      ActionName<String>('AppActions-deleteTodoAction');
  static final ActionName<Null> fetchTodosAction =
      ActionName<Null>('AppActions-fetchTodosAction');
  static final ActionName<Null> toggleAllAction =
      ActionName<Null>('AppActions-toggleAllAction');
  static final ActionName<List<Todo>> loadTodosSuccess =
      ActionName<List<Todo>>('AppActions-loadTodosSuccess');
  static final ActionName<Object> loadTodosFailure =
      ActionName<Object>('AppActions-loadTodosFailure');
  static final ActionName<VisibilityFilter> updateFilterAction =
      ActionName<VisibilityFilter>('AppActions-updateFilterAction');
  static final ActionName<AppTab> updateTabAction =
      ActionName<AppTab>('AppActions-updateTabAction');
  static final ActionName<UpdateTodoActionPayload> updateTodoAction =
      ActionName<UpdateTodoActionPayload>('AppActions-updateTodoAction');
}

// **************************************************************************
// Generator: BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_returning_this
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first

Serializer<UpdateTodoActionPayload> _$updateTodoActionPayloadSerializer =
    _$UpdateTodoActionPayloadSerializer();

class _$UpdateTodoActionPayloadSerializer
    implements StructuredSerializer<UpdateTodoActionPayload> {
  @override
  final Iterable<Type> types = const [
    UpdateTodoActionPayload,
    _$UpdateTodoActionPayload
  ];
  @override
  final String wireName = 'UpdateTodoActionPayload';

  @override
  Iterable serialize(Serializers serializers, UpdateTodoActionPayload object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'updatedTodo',
      serializers.serialize(object.updatedTodo,
          specifiedType: const FullType(Todo)),
    ];

    return result;
  }

  @override
  UpdateTodoActionPayload deserialize(
      Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = UpdateTodoActionPayloadBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updatedTodo':
          result.updatedTodo.replace(serializers.deserialize(value,
              specifiedType: const FullType(Todo)) as Todo);
          break;
      }
    }

    return result.build();
  }
}

class _$UpdateTodoActionPayload extends UpdateTodoActionPayload {
  @override
  final String id;
  @override
  final Todo updatedTodo;

  factory _$UpdateTodoActionPayload(
          [void Function(UpdateTodoActionPayloadBuilder b) updates]) =>
      (UpdateTodoActionPayloadBuilder()..update(updates)).build();

  _$UpdateTodoActionPayload._({this.id, this.updatedTodo}) : super._() {
    if (id == null) {
      throw BuiltValueNullFieldError('UpdateTodoActionPayload', 'id');
    }
    if (updatedTodo == null) {
      throw BuiltValueNullFieldError('UpdateTodoActionPayload', 'updatedTodo');
    }
  }

  @override
  UpdateTodoActionPayload rebuild(
          void Function(UpdateTodoActionPayloadBuilder b) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateTodoActionPayloadBuilder toBuilder() =>
      UpdateTodoActionPayloadBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! UpdateTodoActionPayload) return false;
    return id == other.id && updatedTodo == other.updatedTodo;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, id.hashCode), updatedTodo.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UpdateTodoActionPayload')
          ..add('id', id)
          ..add('updatedTodo', updatedTodo))
        .toString();
  }
}

class UpdateTodoActionPayloadBuilder
    implements
        Builder<UpdateTodoActionPayload, UpdateTodoActionPayloadBuilder> {
  _$UpdateTodoActionPayload _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  TodoBuilder _updatedTodo;
  TodoBuilder get updatedTodo => _$this._updatedTodo ??= TodoBuilder();
  set updatedTodo(TodoBuilder updatedTodo) => _$this._updatedTodo = updatedTodo;

  UpdateTodoActionPayloadBuilder();

  UpdateTodoActionPayloadBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _updatedTodo = _$v.updatedTodo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UpdateTodoActionPayload other) {
    if (other == null) throw ArgumentError.notNull('other');
    _$v = other as _$UpdateTodoActionPayload;
  }

  @override
  void update(void Function(UpdateTodoActionPayloadBuilder b) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UpdateTodoActionPayload build() {
    _$UpdateTodoActionPayload _$result;
    try {
      _$result = _$v ??
          _$UpdateTodoActionPayload._(id: id, updatedTodo: updatedTodo.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'updatedTodo';
        updatedTodo.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            'UpdateTodoActionPayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}
