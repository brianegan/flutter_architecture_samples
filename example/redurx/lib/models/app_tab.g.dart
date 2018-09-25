// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_tab.dart';

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

Serializer<AppTab> _$appTabSerializer = new _$AppTabSerializer();

class _$AppTabSerializer implements PrimitiveSerializer<AppTab> {
  @override
  final Iterable<Type> types = const <Type>[AppTab];
  @override
  final String wireName = 'AppTab';

  @override
  Object serialize(Serializers serializers, AppTab object,
          {FullType specifiedType = FullType.unspecified}) =>
      object.name;

  @override
  AppTab deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      AppTab.valueOf(serialized as String);
}
