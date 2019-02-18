// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/blocs/tab/tab.dart';
import 'package:bloc_library/models/models.dart';

main() {
  group('TabBloc', () {
    test('should update the AppTab', () {
      final TabBloc tabBloc = TabBloc();

      expect(tabBloc.initialState, AppTab.todos);
      expectLater(
        tabBloc.state,
        emitsInOrder([
          AppTab.todos,
          AppTab.stats,
        ]),
      );

      tabBloc.dispatch(UpdateTab(AppTab.stats));
    });
  });
}
