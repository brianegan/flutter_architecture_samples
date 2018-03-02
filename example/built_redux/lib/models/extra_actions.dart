// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library extra_actions;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'extra_actions.g.dart';

class ExtraAction extends EnumClass {
  static Serializer<ExtraAction> get serializer => _$extraActionSerializer;

  static const ExtraAction toggleAllComplete = _$toggleAllComplete;
  static const ExtraAction clearCompleted = _$clearCompleted;

  const ExtraAction._(String name) : super(name);

  static BuiltSet<ExtraAction> get values => _$extraActionValues;

  static ExtraAction valueOf(String name) => _$extraActionValueOf(name);
}
