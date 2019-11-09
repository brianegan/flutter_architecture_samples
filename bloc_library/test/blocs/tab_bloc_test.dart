// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/tab/tab.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('TabBloc', () {
    blocTest<TabBloc, TabEvent, AppTab>(
      'should update the AppTab',
      build: () => TabBloc(),
      act: (TabBloc bloc) async => bloc.add(UpdateTab(AppTab.stats)),
      expect: <AppTab>[
        AppTab.todos,
        AppTab.stats,
      ],
    );
  });
}
