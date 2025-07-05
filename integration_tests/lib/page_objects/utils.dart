// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';

Future<bool> widgetExists(
  WidgetTester tester,
  Finder finder, {
  Duration? timeout,
}) async {
  try {
    expect(finder, findsOneWidget);
    return true;
  } catch (_) {
    return false;
  }
}

Future<bool> widgetAbsent(
  WidgetTester tester,
  Finder finder, {
  Duration? timeout,
}) async {
  try {
    expect(finder, findsNothing);
    return true;
  } catch (_) {
    return false;
  }
}
