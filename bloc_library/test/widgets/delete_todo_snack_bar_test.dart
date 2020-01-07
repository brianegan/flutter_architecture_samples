// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:bloc_library/widgets/delete_todo_snack_bar.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('DeleteTodoSnackBar', () {
    testWidgets('should render properly', (WidgetTester tester) async {
      var snackBarKey = Key('snack_bar_key');
      var tapTarget = Key('tap_target_key');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
                  key: snackBarKey,
                  onUndo: () {},
                  localizations: ArchSampleLocalizations(Locale('en')),
                  todo: Todo('take out trash'),
                ));
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 100.0,
                width: 100.0,
                key: tapTarget,
              ),
            );
          }),
        ),
      ));
      await tester.tap(find.byKey(tapTarget));
      await tester.pump();

      var snackBarFinder = find.byKey(snackBarKey);

      expect(snackBarFinder, findsOneWidget);
      expect(
        ((snackBarFinder.evaluate().first.widget as SnackBar).content as Text)
            .data,
        'Deleted "take out trash"',
      );
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('should call onUndo when undo tapped',
        (WidgetTester tester) async {
      var tapCount = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                Scaffold.of(context).showSnackBar(DeleteTodoSnackBar(
                  onUndo: () {
                    ++tapCount;
                  },
                  localizations: ArchSampleLocalizations(Locale('en')),
                  todo: Todo('take out trash'),
                ));
              },
              child: const Text('X'),
            );
          }),
        ),
      ));
      await tester.tap(find.text('X'));
      await tester.pump(); // start animation
      await tester.pump(const Duration(milliseconds: 750));

      expect(tapCount, equals(0));
      await tester.tap(find.text('Undo'));
      expect(tapCount, equals(1));
    });
  });
}
