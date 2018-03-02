// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library app_tab;

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'app_tab.g.dart';

class AppTab extends EnumClass {
  static Serializer<AppTab> get serializer => _$appTabSerializer;

  static const AppTab todos = _$todos;
  static const AppTab stats = _$stats;

  const AppTab._(String name) : super(name);

  static BuiltSet<AppTab> get values => _$appTabValues;

  static AppTab valueOf(String name) => _$appTabValueOf(name);

  static AppTab fromIndex(int index) {
    switch (index) {
      case 1:
        return AppTab.stats;
      default:
        return AppTab.todos;
    }
  }

  static int toIndex(AppTab tab) {
    switch (tab) {
      case AppTab.stats:
        return 1;
      default:
        return 0;
    }
  }
}
