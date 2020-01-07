// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/src/widgets/framework.dart';

typedef ViewModelBuilder<ViewModel> = Widget Function(
    BuildContext context, ViewModel vm);
