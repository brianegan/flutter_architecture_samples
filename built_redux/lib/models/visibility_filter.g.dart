// GENERATED CODE - DO NOT MODIFY BY HAND

part of visibility_filter;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

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

Serializer<VisibilityFilter> _$visibilityFilterSerializer =
    new _$VisibilityFilterSerializer();

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

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
