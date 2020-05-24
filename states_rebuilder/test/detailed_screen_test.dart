import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:states_rebuilder_sample/app.dart';
import 'package:states_rebuilder_sample/ui/pages/home_screen/todo_item.dart';
import 'package:todos_app_core/todos_app_core.dart';

import 'fake_repository.dart';

void main() {
  final todoItem1Finder = find.byKey(ArchSampleKeys.todoItem('1'));

  testWidgets('delete item from the detailed screen', (tester) async {
    await tester.pumpWidget(
      StatesRebuilderApp(
        repository: FakeRepository(),
      ),
    );

    await tester.pumpAndSettle();
    //expect to see three Todo items
    expect(find.byType(TodoItem), findsNWidgets(3));

    //tap to navigate to detail screen
    await tester.tap(todoItem1Finder);
    await tester.pumpAndSettle();

    //expect we are in the detailed screen
    expect(find.byKey(ArchSampleKeys.todoDetailsScreen), findsOneWidget);

    //
    await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
    await tester.pumpAndSettle();

    //expect we are back in the home screen
    expect(find.byKey(ArchSampleKeys.todoList), findsOneWidget);
    //expect to see two Todo items
    expect(find.byType(TodoItem), findsNWidgets(2));
    //expect to see a SnackBar to reinsert the deleted todo
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);

    //reinsert the deleted todo
    await tester.tap(find.byType(SnackBarAction));
    await tester.pump();
    //expect to see three Todo items
    expect(find.byType(TodoItem), findsNWidgets(3));
    await tester.pumpAndSettle();
  });

  testWidgets('delete item from the detailed screen and reinsert it on error',
      (tester) async {
    await tester.pumpWidget(
      StatesRebuilderApp(
        repository: FakeRepository()
          ..throwError = true
          ..delay = 1000,
      ),
    );

    await tester.pumpAndSettle();

    //tap to navigate to detail screen
    await tester.tap(todoItem1Finder);
    await tester.pumpAndSettle();

    //
    await tester.tap(find.byKey(ArchSampleKeys.deleteTodoButton));
    await tester.pumpAndSettle();

    //expect we are back in the home screen
    expect(find.byKey(ArchSampleKeys.todoList), findsOneWidget);
    //expect to see two Todo items
    expect(find.byType(TodoItem), findsNWidgets(2));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Undo'), findsOneWidget);

    //
    await tester.pump(Duration(milliseconds: 1000));
    await tester.pumpAndSettle();

    expect(find.byType(TodoItem), findsNWidgets(3));
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('There is a problem in saving todos'), findsOneWidget);
  });
}
