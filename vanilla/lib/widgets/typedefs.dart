// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:vanilla/models.dart';

typedef TodoAdder = void Function(Todo todo);

typedef TodoRemover = void Function(Todo todo);

typedef TodoUpdater = void Function(
  Todo todo, {
  bool complete,
  String id,
  String note,
  String task,
});
