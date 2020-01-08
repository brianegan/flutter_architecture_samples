// GENERATED CODE - DO NOT MODIFY BY HAND

part of visibility_filter;

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

const VisibilityFilter _$all = VisibilityFilter._('all');
const VisibilityFilter _$active = VisibilityFilter._('active');
const VisibilityFilter _$completed = VisibilityFilter._('completed');

VisibilityFilter _$visibilityFilterValueOf(String name) {
  switch (name) {
    case 'all':
      return _$all;
    case 'active':
      return _$active;
    case 'completed':
      return _$completed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<VisibilityFilter> _$visibilityFilterValues =
    BuiltSet<VisibilityFilter>(const <VisibilityFilter>[
  _$all,
  _$active,
  _$completed,
]);

Serializer<VisibilityFilter> _$visibilityFilterSerializer =
    _$VisibilityFilterSerializer();

class _$VisibilityFilterSerializer
    implements PrimitiveSerializer<VisibilityFilter> {
  @override
  final Iterable<Type> types = const <Type>[VisibilityFilter];
  @override
  final String wireName = 'VisibilityFilter';

  @override
  Object serialize(Serializers serializers, VisibilityFilter object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  VisibilityFilter deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      VisibilityFilter.valueOf(serialized as String);
}
