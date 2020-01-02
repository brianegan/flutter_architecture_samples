// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/widgets/loading_indicator.dart';

void main() {
  group('LoadingIndicator', () {
    testWidgets('should render correctly', (WidgetTester tester) async {
      final loadingIndicatorKey = Key('loading_indicator_key');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoadingIndicator(key: loadingIndicatorKey),
          ),
        ),
      );
      expect(find.byKey(loadingIndicatorKey), findsOneWidget);
    });
  });
}
