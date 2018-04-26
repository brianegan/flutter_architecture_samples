// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of serializers;

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

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AppState.serializer)
      ..add(AppTab.serializer)
      ..add(ExtraAction.serializer)
      ..add(Todo.serializer)
      ..add(VisibilityFilter.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(Todo)]),
          () => ListBuilder<Todo>()))
    .build();
