// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:vanilla/models.dart';

typedef TodoAdder(Todo todo);

typedef TodoRemover(Todo todo);

typedef TodoUpdater(
  Todo todo, {
  bool complete,
  String id,
  String note,
  String task,
});
