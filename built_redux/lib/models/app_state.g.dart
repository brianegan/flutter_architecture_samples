// GENERATED CODE - DO NOT MODIFY BY HAND

part of app_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AppState> _$appStateSerializer = new _$AppStateSerializer();

class _$AppStateSerializer implements StructuredSerializer<AppState> {
  @override
  final Iterable<Type> types = const [AppState, _$AppState];
  @override
  final String wireName = 'AppState';

  @override
  Iterable<Object> serialize(Serializers serializers, AppState object,
      {FullType specifiedType = FullType.unspecified}) {
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
  AppState deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
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
              as BuiltList<dynamic>);
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

class _$AppState extends AppState {
  @override
  final bool isLoading;
  @override
  final BuiltList<Todo> todos;
  @override
  final AppTab activeTab;
  @override
  final VisibilityFilter activeFilter;
  int __numCompletedSelector;
  int __numActiveSelector;
  bool __allCompleteSelector;
  List<Todo> __filteredTodosSelector;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._({this.isLoading, this.todos, this.activeTab, this.activeFilter})
      : super._() {
    if (isLoading == null) {
      throw new BuiltValueNullFieldError('AppState', 'isLoading');
    }
    if (todos == null) {
      throw new BuiltValueNullFieldError('AppState', 'todos');
    }
    if (activeTab == null) {
      throw new BuiltValueNullFieldError('AppState', 'activeTab');
    }
    if (activeFilter == null) {
      throw new BuiltValueNullFieldError('AppState', 'activeFilter');
    }
  }

  @override
  int get numCompletedSelector =>
      __numCompletedSelector ??= super.numCompletedSelector;

  @override
  int get numActiveSelector => __numActiveSelector ??= super.numActiveSelector;

  @override
  bool get allCompleteSelector =>
      __allCompleteSelector ??= super.allCompleteSelector;

  @override
  List<Todo> get filteredTodosSelector =>
      __filteredTodosSelector ??= super.filteredTodosSelector;

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        isLoading == other.isLoading &&
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
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              isLoading: isLoading,
              todos: todos.build(),
              activeTab: activeTab,
              activeFilter: activeFilter);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'todos';
        todos.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
