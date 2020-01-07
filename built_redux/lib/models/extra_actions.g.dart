// GENERATED CODE - DO NOT MODIFY BY HAND

part of extra_actions;

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

const ExtraAction _$toggleAllComplete = ExtraAction._('toggleAllComplete');
const ExtraAction _$clearCompleted = ExtraAction._('clearCompleted');

ExtraAction _$extraActionValueOf(String name) {
  switch (name) {
    case 'toggleAllComplete':
      return _$toggleAllComplete;
    case 'clearCompleted':
      return _$clearCompleted;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<ExtraAction> _$extraActionValues =
    BuiltSet<ExtraAction>(const <ExtraAction>[
  _$toggleAllComplete,
  _$clearCompleted,
]);

Serializer<ExtraAction> _$extraActionSerializer = _$ExtraActionSerializer();

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
