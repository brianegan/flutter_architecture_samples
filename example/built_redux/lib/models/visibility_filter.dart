// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library visibility_filter;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'visibility_filter.g.dart';

class VisibilityFilter extends EnumClass {
  static Serializer<VisibilityFilter> get serializer =>
      _$visibilityFilterSerializer;

  static const VisibilityFilter all = _$all;
  static const VisibilityFilter active = _$active;
  static const VisibilityFilter completed = _$completed;

  const VisibilityFilter._(String name) : super(name);

  static BuiltSet<VisibilityFilter> get values => _$visibilityFilterValues;

  static VisibilityFilter valueOf(String name) =>
      _$visibilityFilterValueOf(name);
}
