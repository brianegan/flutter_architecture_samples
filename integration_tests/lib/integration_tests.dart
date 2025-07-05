// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library integration_tests;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'page_objects/page_objects.dart';

void run({required Future<Widget> Function() appBuilder}) {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Todo App Test', (WidgetTester tester) async {
    final app = await appBuilder();
    final homeScreen = HomeTestScreen(tester);

    // Build the app
    await tester.pumpWidget(app);

    // should show a loading screen while the todos are fetched
    expect(await homeScreen.isLoading(), isTrue);

    // should start with a list of Todos
    expect(await homeScreen.isReady(), isTrue);
    expect(await homeScreen.todoList.todoItem('1').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('2').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('3').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('4').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('5').isVisible, isTrue);

    // should be able to click on an item to see details
    var detailsScreen = await homeScreen.todoList.todoItem('2').tap();
    expect(await detailsScreen.isReady(), isTrue);
    expect(await detailsScreen.task, isNotEmpty);
    expect(await detailsScreen.note, isNotEmpty);

    var editScreen = await detailsScreen.tapEditTodoButton();

    expect(await editScreen.isReady(), isTrue);

    await editScreen.tapBackButton();

    // should be able to delete a todo on the details screen
    await detailsScreen.tapDeleteButton();

    expect(
      await homeScreen.todoList.todoItem('2').isAbsent,
      isTrue,
      reason: 'TodoItem2 should be absent',
    );

    expect(
      await homeScreen.snackbarVisible,
      isTrue,
      reason: 'snackbar should be visible',
    );

    // should filter to completed todos
    await (await homeScreen.tapFilterButton()).tapShowCompleted();

    expect(await homeScreen.todoList.todoItem('3').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('5').isVisible, isTrue);

    // should filter to active todos
    await (await homeScreen.tapFilterButton()).tapShowActive();
    expect(await homeScreen.todoList.todoItem('1').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('4').isVisible, isTrue);

    // should once again filter to all todos
    await (await homeScreen.tapFilterButton()).tapShowAll();
    expect(await homeScreen.todoList.todoItem('1').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('3').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('4').isVisible, isTrue);
    expect(await homeScreen.todoList.todoItem('5').isVisible, isTrue);

    // should be able to view stats
    var stats = await homeScreen.tapStatsTab();
    expect(await stats.numActive, 2);
    expect(await stats.numCompleted, 2);

    // should be able to toggle a todo complete
    await (await homeScreen.tapTodosTab()).todoItem('1').tapCheckbox();
    stats = await homeScreen.tapStatsTab();

    // This is a hacky way to check if the tapping the checkbox was
    // successful. Would be better to have an `isChecked` method from the
    // driver or perhaps need to write a custom Matcher.
    expect(await stats.numActive, 1);
    expect(await stats.numCompleted, 3);

    // should be able to clear the completed todos
    await (await homeScreen.tapExtraActionsButton()).tapClearCompleted();

    stats = await homeScreen.tapStatsTab();

    expect(await stats.numActive, 1);
    expect(await stats.numCompleted, 0);

    // should be able to toggle all todos complete
    await (await homeScreen.tapExtraActionsButton()).tapToggleAll();

    expect(await homeScreen.stats.numActive, 0);
    expect(await homeScreen.stats.numCompleted, 1);

    // should be able to add a todo
    final taskAdd = 'Plan day trip to pyramids';
    final noteAdd = 'Take picture next to Great Pyramid of Giza!';

    // init to home screen
    await homeScreen.tapTodosTab();
    expect(await homeScreen.isReady(), isTrue);

    // go to add screen and enter a _todo
    final addScreen = await homeScreen.tapAddTodoButton();
    await addScreen.enterTask(taskAdd);
    await addScreen.enterNote(noteAdd);

    // save and return to home screen and find new _todo
    await addScreen.tapSaveNewButton();
    expect(await homeScreen.isReady(), isTrue);
    expect(find.text(taskAdd), findsOneWidget);

    // should be able to modify a todo'
    final taskEdit = 'Plan full day trip to pyramids';
    final noteEdit =
        'Have lunch next to Great Pyramid of Giza and take pictures!';

    // init to home screen
    await homeScreen.tapTodosTab();
    expect(await homeScreen.isReady(), isTrue);

    // find the _todo text to edit and go to details screen
    detailsScreen = await homeScreen.tapTodo(taskAdd);
    expect(await detailsScreen.isReady(), isTrue);

    // go to edit screen and edit this _todo
    editScreen = await detailsScreen.tapEditTodoButton();
    expect(await editScreen.isReady(), isTrue);
    await editScreen.editTask(taskEdit);
    await editScreen.editNote(noteEdit);

    // save and return to details screen
    await editScreen.tapSaveFab();
    expect(await detailsScreen.isReady(), isTrue);
    expect(find.text(taskEdit), findsOneWidget);
    expect(find.text(noteEdit), findsOneWidget);

    // check shows up on home screen
    await detailsScreen.tapBackButton();
    expect(await homeScreen.isReady(), isTrue);
    expect(find.text(taskEdit), findsOneWidget);
  });
}
