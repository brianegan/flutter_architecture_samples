// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:redux_sample/models/models.dart';

typedef TodoAdder(Todo todo);

typedef TodoRemover(String id);

typedef TodoUpdater(String id, Todo todo);
