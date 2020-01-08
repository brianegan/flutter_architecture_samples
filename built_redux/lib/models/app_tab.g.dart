// GENERATED CODE - DO NOT MODIFY BY HAND

part of app_tab;

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

const AppTab _$todos = AppTab._('todos');
const AppTab _$stats = AppTab._('stats');

AppTab _$appTabValueOf(String name) {
  switch (name) {
    case 'todos':
      return _$todos;
    case 'stats':
      return _$stats;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AppTab> _$appTabValues = BuiltSet<AppTab>(const <AppTab>[
  _$todos,
  _$stats,
]);

Serializer<AppTab> _$appTabSerializer = _$AppTabSerializer();

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
