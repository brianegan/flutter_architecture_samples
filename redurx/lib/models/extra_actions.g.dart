// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra_actions.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line
// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_annotating_with_dynamic
// ignore_for_file: avoid_catches_without_on_clauses
// ignore_for_file: avoid_returning_this
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: omit_local_variable_types
// ignore_for_file: prefer_expression_function_bodies
// ignore_for_file: sort_constructors_first
// ignore_for_file: unnecessary_const
// ignore_for_file: unnecessary_new
// ignore_for_file: test_types_in_equals

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
