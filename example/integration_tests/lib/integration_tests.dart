// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

library integration_tests;

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

import 'page_objects/page_objects.dart';

main() {
  group('Todo App Test', () {
    FlutterDriver driver;
    HomeTestScreen homeScreen;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      homeScreen = new HomeTestScreen(driver);
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('should show a loading screen while the todos are fetched', () async {
      expect(await homeScreen.isLoading(), isTrue);
    });

    test('should start with a list of Todos', () async {
      expect(await homeScreen.isReady(), isTrue);
      expect(await homeScreen.todoList.todoItem('1').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('2').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('3').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('4').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('5').isVisible, isTrue);
    });

    test('should be able to click on an item to see details', () async {
      final detailsScreen = await homeScreen.todoList.todoItem('2').tap();
      expect(await detailsScreen.task, isNotEmpty);
      expect(await detailsScreen.note, isNotEmpty);

      final editScreen = detailsScreen.tapEditTodoButton();

      expect(await editScreen.isReady(), isTrue);

      await editScreen.tapBackButton();
    });

    test('should be able to delete a todo on the details screen', () async {
      final detailsScreen = new DetailsTestScreen(driver);

      await detailsScreen.tapDeleteButton();

      expect(await homeScreen.todoList.todoItem('2').isAbsent, isTrue,
          reason: 'TodoItem2 should be absent');
      expect(await homeScreen.snackbarVisible, isTrue,
          reason: 'snackbar should be visible');
    });

    test('should filter to completed todos', () async {
      await homeScreen.tapFilterButton().tapShowCompleted();

      expect(await homeScreen.todoList.todoItem('3').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('5').isVisible, isTrue);
    });

    test('should filter to active todos', () async {
      await homeScreen.tapFilterButton().tapShowActive();

      expect(await homeScreen.todoList.todoItem('1').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('4').isVisible, isTrue);
    });

    test('should once again filter to all todos', () async {
      await homeScreen.tapFilterButton().tapShowAll();

      expect(await homeScreen.todoList.todoItem('1').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('3').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('4').isVisible, isTrue);
      expect(await homeScreen.todoList.todoItem('5').isVisible, isTrue);
    });

    test('should be able to view stats', () async {
      final stats = await homeScreen.tapStatsTab();

      expect(await stats.numActive, 2);
      expect(await stats.numCompleted, 2);
    });

    test('should be able to toggle a todo complete', () async {
      await homeScreen.tapTodosTab().todoItem('1').tapCheckbox();
      final stats = homeScreen.tapStatsTab();

      // This is a hacky way to check if the tapping the checkbox was
      // successful. Would be better to have an `isChecked` method from the
      // driver or perhaps need to write a custom Matcher.
      expect(await stats.numActive, 1);
      expect(await stats.numCompleted, 3);
    });

    test('should be able to clear the completed todos', () async {
      await homeScreen.tapExtraActionsButton().tapClearCompleted();

      final stats = homeScreen.tapStatsTab();

      expect(await stats.numActive, 1);
      expect(await stats.numCompleted, 0);
    });

    test('should be able to toggle all todos complete', () async {
      await homeScreen.tapExtraActionsButton().tapToggleAll();

      expect(await homeScreen.stats.numActive, 0);
      expect(await homeScreen.stats.numCompleted, 1);
    });
  });
}
