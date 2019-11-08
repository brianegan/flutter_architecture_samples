// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_library/localization.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'package:bloc_library/widgets/todo_item.dart';
import 'package:bloc_library/models/models.dart';

void main() {
  group('TodoItem', () {
    testWidgets('should render properly with no note',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              onCheckboxChanged: (_) => null,
              onDismissed: (_) => null,
              onTap: () => null,
              todo: Todo('wash car', id: '0'),
            ),
          ),
          localizationsDelegates: [
            ArchSampleLocalizationsDelegate(),
            FlutterBlocLocalizationsDelegate(),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoItem('0')), findsOneWidget);
      expect(find.text('wash car'), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.todoItemNote('0')), findsNothing);
    });

    testWidgets('should render properly with note',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TodoItem(
              onCheckboxChanged: (_) => null,
              onDismissed: (_) => null,
              onTap: () => null,
              todo: Todo('wash car', note: 'some note', id: '0'),
            ),
          ),
          localizationsDelegates: [
            ArchSampleLocalizationsDelegate(),
            FlutterBlocLocalizationsDelegate(),
          ],
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(ArchSampleKeys.todoItem('0')), findsOneWidget);
      expect(find.text('wash car'), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.todoItemNote('0')), findsOneWidget);
      expect(find.text('some note'), findsOneWidget);
    });
  });
}
