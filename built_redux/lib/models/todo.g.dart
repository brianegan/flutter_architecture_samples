// GENERATED CODE - DO NOT MODIFY BY HAND

part of todo;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Todo> _$todoSerializer = new _$TodoSerializer();

class _$TodoSerializer implements StructuredSerializer<Todo> {
  @override
  final Iterable<Type> types = const [Todo, _$Todo];
  @override
  final String wireName = 'Todo';

  @override
  Iterable<Object> serialize(Serializers serializers, Todo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'complete',
      serializers.serialize(object.complete,
          specifiedType: const FullType(bool)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'note',
      serializers.serialize(object.note, specifiedType: const FullType(String)),
      'task',
      serializers.serialize(object.task, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Todo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TodoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'complete':
          result.complete = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'note':
          result.note = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'task':
          result.task = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Todo extends Todo {
  @override
  final bool complete;
  @override
  final String id;
  @override
  final String note;
  @override
  final String task;

  factory _$Todo([void Function(TodoBuilder) updates]) =>
      (new TodoBuilder()..update(updates)).build();

  _$Todo._({this.complete, this.id, this.note, this.task}) : super._() {
    if (complete == null) {
      throw new BuiltValueNullFieldError('Todo', 'complete');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('Todo', 'id');
    }
    if (note == null) {
      throw new BuiltValueNullFieldError('Todo', 'note');
    }
    if (task == null) {
      throw new BuiltValueNullFieldError('Todo', 'task');
    }
  }

  @override
  Todo rebuild(void Function(TodoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoBuilder toBuilder() => new TodoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Todo &&
        complete == other.complete &&
        id == other.id &&
        note == other.note &&
        task == other.task;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, complete.hashCode), id.hashCode), note.hashCode),
        task.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Todo')
          ..add('complete', complete)
          ..add('id', id)
          ..add('note', note)
          ..add('task', task))
        .toString();
  }
}

class TodoBuilder implements Builder<Todo, TodoBuilder> {
  _$Todo _$v;

  bool _complete;
  bool get complete => _$this._complete;
  set complete(bool complete) => _$this._complete = complete;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  String _task;
  String get task => _$this._task;
  set task(String task) => _$this._task = task;

  TodoBuilder();

  TodoBuilder get _$this {
    if (_$v != null) {
      _complete = _$v.complete;
      _id = _$v.id;
      _note = _$v.note;
      _task = _$v.task;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Todo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Todo;
  }

  @override
  void update(void Function(TodoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Todo build() {
    final _$result =
        _$v ?? new _$Todo._(complete: complete, id: id, note: note, task: task);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
