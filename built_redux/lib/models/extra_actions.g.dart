// GENERATED CODE - DO NOT MODIFY BY HAND

part of extra_actions;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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

Serializer<ExtraAction> _$extraActionSerializer = new _$ExtraActionSerializer();

class _$ExtraActionSerializer implements PrimitiveSerializer<ExtraAction> {
  @override
  final Iterable<Type> types = const <Type>[ExtraAction];
  @override
  final String wireName = 'ExtraAction';

  @override
  Object serialize(Serializers serializers, ExtraAction object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  ExtraAction deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      ExtraAction.valueOf(serialized as String);
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
