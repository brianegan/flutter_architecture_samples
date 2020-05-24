import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder_sample/app.dart';
import 'package:todos_app_core/todos_app_core.dart';
import 'fake_repository.dart';

/// Demonstrates how to test Widgets
void main() {
  group('HomeScreen', () {
    final todoListFinder = find.byKey(ArchSampleKeys.todoList);
    final todoItem1Finder = find.byKey(ArchSampleKeys.todoItem('1'));
    final todoItem2Finder = find.byKey(ArchSampleKeys.todoItem('2'));
    final todoItem3Finder = find.byKey(ArchSampleKeys.todoItem('3'));

    testWidgets('should render loading indicator at first', (tester) async {
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository(),
        ),
      );
      await tester.pump(Duration.zero);
      expect(find.byKey(ArchSampleKeys.todosLoading), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('should display a list after loading todos', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository(),
        ),
      );
      await tester.pumpAndSettle();

      final checkbox1 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('1')),
        matching: find.byType(Focus),
      );
      final checkbox2 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('2')),
        matching: find.byType(Focus),
      );
      final checkbox3 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('3')),
        matching: find.byType(Focus),
      );

      expect(todoListFinder, findsOneWidget);
      expect(todoItem1Finder, findsOneWidget);
      expect(find.text('Task1'), findsOneWidget);
      expect(find.text('Note1'), findsOneWidget);
      expect(tester.getSemantics(checkbox1), isChecked(false));
      expect(todoItem2Finder, findsOneWidget);
      expect(find.text('Task2'), findsOneWidget);
      expect(find.text('Note2'), findsOneWidget);
      expect(tester.getSemantics(checkbox2), isChecked(false));
      expect(todoItem3Finder, findsOneWidget);
      expect(find.text('Task3'), findsOneWidget);
      expect(find.text('Note3'), findsOneWidget);
      expect(tester.getSemantics(checkbox3), isChecked(true));

      handle.dispose();
    });

    testWidgets('should remove todos using a dismissible', (tester) async {
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(todoItem1Finder, Offset(-1000, 0));
      await tester.pumpAndSettle();

      expect(todoItem1Finder, findsNothing);
      expect(todoItem2Finder, findsOneWidget);
      expect(todoItem3Finder, findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets(
        'should remove todos using a dismissible and insert back the removed element if throws',
        (tester) async {
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository()..throwError = true,
        ),
      );

      await tester.pumpAndSettle();
      await tester.drag(todoItem1Finder, Offset(-1000, 0));
      await tester.pumpAndSettle();

      //Removed item in inserted back to the list
      expect(todoItem1Finder, findsOneWidget);
      expect(todoItem2Finder, findsOneWidget);
      expect(todoItem3Finder, findsOneWidget);
      //SnackBar with error message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('There is a problem in saving todos'), findsOneWidget);
    });

    testWidgets('should display stats when switching tabs', (tester) async {
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ArchSampleKeys.statsTab));
      await tester.pump();

      expect(find.byKey(ArchSampleKeys.statsNumActive), findsOneWidget);
      expect(find.byKey(ArchSampleKeys.statsNumActive), findsOneWidget);
    });

    testWidgets('should toggle a todo', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository(),
        ),
      );
      await tester.pumpAndSettle();

      final checkbox1 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('1')),
        matching: find.byType(Focus),
      );
      expect(tester.getSemantics(checkbox1), isChecked(false));

      await tester.tap(checkbox1);
      await tester.pump();
      expect(tester.getSemantics(checkbox1), isChecked(true));

      await tester.pumpAndSettle();
      handle.dispose();
    });

    testWidgets('should toggle a todo and toggle back if throws',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        StatesRebuilderApp(
          repository: FakeRepository()..throwError = true,
        ),
      );
      await tester.pumpAndSettle();

      final checkbox1 = find.descendant(
        of: find.byKey(ArchSampleKeys.todoItemCheckbox('1')),
        matching: find.byType(Focus),
      );
      expect(tester.getSemantics(checkbox1), isChecked(false));

      await tester.tap(checkbox1);
      await tester.pump();

      expect(tester.getSemantics(checkbox1), isChecked(true));
      //NO Error,
      expect(find.byType(SnackBar), findsNothing);

      //
      await tester.pumpAndSettle();
      expect(tester.getSemantics(checkbox1), isChecked(false));

      //SnackBar with error message
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('There is a problem in saving todos'), findsOneWidget);
      handle.dispose();
    });
  });
}

Matcher isChecked(bool isChecked) {
  return matchesSemantics(
    isChecked: isChecked,
    hasCheckedState: true,
    hasEnabledState: true,
    isEnabled: true,
    isFocusable: true,
    hasTapAction: true,
  );
}
