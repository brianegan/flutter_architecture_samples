// GENERATED CODE - DO NOT MODIFY BY HAND

part of actions;

// **************************************************************************
// BuiltReduxGenerator
// **************************************************************************

// ignore_for_file: avoid_classes_with_only_static_members
// ignore_for_file: annotate_overrides
// ignore_for_file: overridden_fields
// ignore_for_file: type_annotate_public_apis

class _$AppActions extends AppActions {
  factory _$AppActions() => new _$AppActions._();
  _$AppActions._() : super._();

  final addTodoAction = new ActionDispatcher<Todo>('AppActions-addTodoAction');
  final clearCompletedAction =
      new ActionDispatcher<Null>('AppActions-clearCompletedAction');
  final deleteTodoAction =
      new ActionDispatcher<String>('AppActions-deleteTodoAction');
  final fetchTodosAction =
      new ActionDispatcher<Null>('AppActions-fetchTodosAction');
  final toggleAllAction =
      new ActionDispatcher<Null>('AppActions-toggleAllAction');
  final loadTodosSuccess =
      new ActionDispatcher<List<Todo>>('AppActions-loadTodosSuccess');
  final loadTodosFailure =
      new ActionDispatcher<Object>('AppActions-loadTodosFailure');
  final updateFilterAction =
      new ActionDispatcher<VisibilityFilter>('AppActions-updateFilterAction');
  final updateTabAction =
      new ActionDispatcher<AppTab>('AppActions-updateTabAction');
  final updateTodoAction = new ActionDispatcher<UpdateTodoActionPayload>(
      'AppActions-updateTodoAction');

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
  static final addTodoAction = new ActionName<Todo>('AppActions-addTodoAction');
  static final clearCompletedAction =
      new ActionName<Null>('AppActions-clearCompletedAction');
  static final deleteTodoAction =
      new ActionName<String>('AppActions-deleteTodoAction');
  static final fetchTodosAction =
      new ActionName<Null>('AppActions-fetchTodosAction');
  static final toggleAllAction =
      new ActionName<Null>('AppActions-toggleAllAction');
  static final loadTodosSuccess =
      new ActionName<List<Todo>>('AppActions-loadTodosSuccess');
  static final loadTodosFailure =
      new ActionName<Object>('AppActions-loadTodosFailure');
  static final updateFilterAction =
      new ActionName<VisibilityFilter>('AppActions-updateFilterAction');
  static final updateTabAction =
      new ActionName<AppTab>('AppActions-updateTabAction');
  static final updateTodoAction =
      new ActionName<UpdateTodoActionPayload>('AppActions-updateTodoAction');
}

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UpdateTodoActionPayload> _$updateTodoActionPayloadSerializer =
    new _$UpdateTodoActionPayloadSerializer();

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
  Iterable<Object> serialize(
      Serializers serializers, UpdateTodoActionPayload object,
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
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new UpdateTodoActionPayloadBuilder();

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
          [void Function(UpdateTodoActionPayloadBuilder) updates]) =>
      (new UpdateTodoActionPayloadBuilder()..update(updates)).build();

  _$UpdateTodoActionPayload._({this.id, this.updatedTodo}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('UpdateTodoActionPayload', 'id');
    }
    if (updatedTodo == null) {
      throw new BuiltValueNullFieldError(
          'UpdateTodoActionPayload', 'updatedTodo');
    }
  }

  @override
  UpdateTodoActionPayload rebuild(
          void Function(UpdateTodoActionPayloadBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UpdateTodoActionPayloadBuilder toBuilder() =>
      new UpdateTodoActionPayloadBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UpdateTodoActionPayload &&
        id == other.id &&
        updatedTodo == other.updatedTodo;
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
  TodoBuilder get updatedTodo => _$this._updatedTodo ??= new TodoBuilder();
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
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UpdateTodoActionPayload;
  }

  @override
  void update(void Function(UpdateTodoActionPayloadBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UpdateTodoActionPayload build() {
    _$UpdateTodoActionPayload _$result;
    try {
      _$result = _$v ??
          new _$UpdateTodoActionPayload._(
              id: id, updatedTodo: updatedTodo.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'updatedTodo';
        updatedTodo.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UpdateTodoActionPayload', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
