// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';

typedef TodoAdder = void Function(Todo todo);

typedef TodoRemover = void Function(String id);

typedef TodoUpdater = void Function(String id, Todo todo);
