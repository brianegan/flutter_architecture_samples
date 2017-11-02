// GENERATED CODE - DO NOT MODIFY BY HAND

part of models;

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

const AppTab _$todos = const AppTab._('todos');
const AppTab _$stats = const AppTab._('stats');

AppTab _$appTabValueOf(String name) {
  switch (name) {
    case 'todos':
      return _$todos;
    case 'stats':
      return _$stats;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<AppTab> _$appTabValues = new BuiltSet<AppTab>(const <AppTab>[
  _$todos,
  _$stats,
]);

const ExtraAction _$toggleAllComplete =
    const ExtraAction._('toggleAllComplete');
const ExtraAction _$clearCompleted = const ExtraAction._('clearCompleted');

ExtraAction _$extraActionValueOf(String name) {
  switch (name) {
    case 'toggleAllComplete':
      return _$toggleAllComplete;
    case 'clearCompleted':
      return _$clearCompleted;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<ExtraAction> _$extraActionValues =
    new BuiltSet<ExtraAction>(const <ExtraAction>[
  _$toggleAllComplete,
  _$clearCompleted,
]);

const VisibilityFilter _$all = const VisibilityFilter._('all');
const VisibilityFilter _$active = const VisibilityFilter._('active');
const VisibilityFilter _$completed = const VisibilityFilter._('completed');

VisibilityFilter _$visibilityFilterValueOf(String name) {
  switch (name) {
    case 'all':
      return _$all;
    case 'active':
      return _$active;
    case 'completed':
      return _$completed;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<VisibilityFilter> _$visibilityFilterValues =
    new BuiltSet<VisibilityFilter>(const <VisibilityFilter>[
  _$all,
  _$active,
  _$completed,
]);

Serializer<AppTab> _$appTabSerializer = new _$AppTabSerializer();
Serializer<ExtraAction> _$extraActionSerializer = new _$ExtraActionSerializer();
Serializer<VisibilityFilter> _$visibilityFilterSerializer =
    new _$VisibilityFilterSerializer();
Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();
Serializer<Todo> _$todoSerializer = new _$TodoSerializer();

class _$AppTabSerializer implements PrimitiveSerializer<AppTab> {
  @override
  final Iterable<Type> types = const <Type>[AppTab];
  @override
  final String wireName = 'AppTab';

  @override
  Object serialize(Serializers serializers, AppTab object,
          {FullType specifiedType: FullType.unspecified}) =>
      object.name;

  @override
  AppTab deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType: FullType.unspecified}) =>
      AppTab.valueOf(serialized as String);
}

class _$ExtraActionSerializer implements PrimitiveSerializer<ExtraAction> {
  @override
  final Iterable<Type> types = const <Type>[ExtraAction];
  @override
  final String wireName = 'ExtraAction';

  @override
  Object serialize(Serializers serializers, ExtraAction object,
          {FullType specifiedType: FullType.unspecified}) =>
      object.name;

  @override
  ExtraAction deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType: FullType.unspecified}) =>
      ExtraAction.valueOf(serialized as String);
}

class _$VisibilityFilterSerializer
    implements PrimitiveSerializer<VisibilityFilter> {
  @override
  final Iterable<Type> types = const <Type>[VisibilityFilter];
  @override
  final String wireName = 'VisibilityFilter';

  @override
  Object serialize(Serializers serializers, VisibilityFilter object,
          {FullType specifiedType: FullType.unspecified}) =>
      object.name;

  @override
  VisibilityFilter deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType: FullType.unspecified}) =>
      VisibilityFilter.valueOf(serialized as String);
}

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable serialize(Serializers serializers, AppState object,
      {FullType specifiedType: FullType.unspecified}) {
    final result = <Object>[
      'isLoading',
      serializers.serialize(object.isLoading,
          specifiedType: const FullType(bool)),
      'todos',
      serializers.serialize(object.todos,
          specifiedType:
              const FullType(BuiltList, const [const FullType(Todo)])),
      'activeTab',
      serializers.serialize(object.activeTab,
          specifiedType: const FullType(AppTab)),
      'activeFilter',
      serializers.serialize(object.activeFilter,
          specifiedType: const FullType(VisibilityFilter)),
    ];

    return result;
  }

  @override
  AppState deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
    final result = new AppStateBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'isLoading':
          result.isLoading = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'todos':
          result.todos.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(Todo)]))
              as BuiltList<Todo>);
          break;
        case 'activeTab':
          result.activeTab = serializers.deserialize(value,
              specifiedType: const FullType(AppTab)) as AppTab;
          break;
        case 'activeFilter':
          result.activeFilter = serializers.deserialize(value,
                  specifiedType: const FullType(VisibilityFilter))
              as VisibilityFilter;
          break;
      }
    }

    return result.build();
  }
}

class _$TodoSerializer implements StructuredSerializer<Todo> {
  @override
  final Iterable<Type> types = const [Todo, _$Todo];
  @override
  final String wireName = 'Todo';

  @override
  Iterable serialize(Serializers serializers, Todo object,
      {FullType specifiedType: FullType.unspecified}) {
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
  Todo deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType: FullType.unspecified}) {
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

class _$AppState extends AppState {
  @override
  final bool isLoading;
  @override
  final BuiltList<Todo> todos;
  @override
  final AppTab activeTab;
  @override
  final VisibilityFilter activeFilter;

  factory _$AppState([void updates(AppStateBuilder b)]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._({this.isLoading, this.todos, this.activeTab, this.activeFilter})
      : super._() {
    if (isLoading == null) throw new ArgumentError.notNull('isLoading');
    if (todos == null) throw new ArgumentError.notNull('todos');
    if (activeTab == null) throw new ArgumentError.notNull('activeTab');
    if (activeFilter == null) throw new ArgumentError.notNull('activeFilter');
  }

  @override
  AppState rebuild(void updates(AppStateBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! AppState) return false;
    return isLoading == other.isLoading &&
        todos == other.todos &&
        activeTab == other.activeTab &&
        activeFilter == other.activeFilter;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, isLoading.hashCode), todos.hashCode),
            activeTab.hashCode),
        activeFilter.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('isLoading', isLoading)
          ..add('todos', todos)
          ..add('activeTab', activeTab)
          ..add('activeFilter', activeFilter))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  bool _isLoading;
  bool get isLoading => _$this._isLoading;
  set isLoading(bool isLoading) => _$this._isLoading = isLoading;

  ListBuilder<Todo> _todos;
  ListBuilder<Todo> get todos => _$this._todos ??= new ListBuilder<Todo>();
  set todos(ListBuilder<Todo> todos) => _$this._todos = todos;

  AppTab _activeTab;
  AppTab get activeTab => _$this._activeTab;
  set activeTab(AppTab activeTab) => _$this._activeTab = activeTab;

  VisibilityFilter _activeFilter;
  VisibilityFilter get activeFilter => _$this._activeFilter;
  set activeFilter(VisibilityFilter activeFilter) =>
      _$this._activeFilter = activeFilter;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _isLoading = _$v.isLoading;
      _todos = _$v.todos?.toBuilder();
      _activeTab = _$v.activeTab;
      _activeFilter = _$v.activeFilter;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$AppState;
  }

  @override
  void update(void updates(AppStateBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    final _$result = _$v ??
        new _$AppState._(
            isLoading: isLoading,
            todos: todos?.build(),
            activeTab: activeTab,
            activeFilter: activeFilter);
    replace(_$result);
    return _$result;
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

  factory _$Todo([void updates(TodoBuilder b)]) =>
      (new TodoBuilder()..update(updates)).build();

  _$Todo._({this.complete, this.id, this.note, this.task}) : super._() {
    if (complete == null) throw new ArgumentError.notNull('complete');
    if (id == null) throw new ArgumentError.notNull('id');
    if (note == null) throw new ArgumentError.notNull('note');
    if (task == null) throw new ArgumentError.notNull('task');
  }

  @override
  Todo rebuild(void updates(TodoBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoBuilder toBuilder() => new TodoBuilder()..replace(this);

  @override
  bool operator ==(dynamic other) {
    if (identical(other, this)) return true;
    if (other is! Todo) return false;
    return complete == other.complete &&
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
    if (other == null) throw new ArgumentError.notNull('other');
    _$v = other as _$Todo;
  }

  @override
  void update(void updates(TodoBuilder b)) {
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
