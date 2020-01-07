// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library serializers;

import 'package:built_collection/built_collection.dart';
import 'package:built_redux_sample/models/models.dart';
import 'package:built_value/serializer.dart';

part 'serializers.g.dart';

@SerializersFor([
  AppTab,
  ExtraAction,
  VisibilityFilter,
  AppState,
  Todo,
])
final Serializers serializers = _$serializers;
